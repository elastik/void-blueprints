// =============================================================================
// The Void -- Main Firmware Entry Point
// =============================================================================
//
// Complete firmware integration for the Void Core ESP32 prototype.
// All 8 modules initialized in dependency order, non-blocking loop with
// millis()-based task scheduling.
//
// Module initialization order:
//   1. SensorReader      -- BME280 I2C (no dependencies)
//   2. LedController     -- UV-A/Blue LED pins + Preferences restore
//   3. ButtonHandler     -- GPIO 17 INPUT_PULLUP
//   4. UvcController     -- UV-C trigger + reed switch + indicator
//   5. FanController     -- LEDC hardware PWM (initialized via ClimateController)
//   6. HumidifierController -- GPIO 13 output (initialized via ClimateController)
//   7. ClimateController -- refs: SensorReader, FanController, HumidifierController
//   8. VoidWebServer     -- refs: SensorReader, LedController, UvcController, ClimateController
//
// UV-C / LED integration:
//   - Long press starts sterilization: grow lights disabled, UV-C activated
//   - Long press during active UV-C: stops sterilization, grow lights restored
//   - UV-C auto-shutoff or emergency stop: grow lights restored automatically
//
// =============================================================================

#include <Arduino.h>
#include "config.h"
#include "sensor_reader.h"
#include "led_controller.h"
#include "button_handler.h"
#include "uvc_controller.h"
#include "fan_controller.h"
#include "humidifier_controller.h"
#include "climate_controller.h"
#include "web_server.h"

// -----------------------------------------------------------------------------
// Global Instances (ordered by initialization dependencies)
// -----------------------------------------------------------------------------

SensorReader         sensorReader;
LedController        ledController;
ButtonHandler        buttonHandler;
UvcController        uvcController;
FanController        fanController;
HumidifierController humidifierController;
ClimateController    climateController(sensorReader, fanController, humidifierController);
VoidWebServer        webServer(sensorReader, ledController, uvcController, climateController);

// -----------------------------------------------------------------------------
// State
// -----------------------------------------------------------------------------

static unsigned long lastSensorRead = 0;
static bool wasUvcActive = false;  // Tracks UV-C state to detect cycle completion

// -----------------------------------------------------------------------------
// Helper: Cycle light mode 1 -> 2 -> 3 -> 4 -> 1
// -----------------------------------------------------------------------------

static LightMode nextMode(LightMode current) {
    uint8_t m = static_cast<uint8_t>(current) + 1;
    if (m > static_cast<uint8_t>(LightMode::OFF)) {
        m = static_cast<uint8_t>(LightMode::VOID_GLOW);
    }
    return static_cast<LightMode>(m);
}

// -----------------------------------------------------------------------------
// Setup
// -----------------------------------------------------------------------------

void setup() {
    Serial.begin(115200);

    // --- Startup banner ---
    Serial.println();
    Serial.println("========================================");
    Serial.println("  _____ _  _ ___  __   ___  ___ ___    ");
    Serial.println(" |_   _| || | __| \\ \\ / / \\|_ _|   \\  ");
    Serial.println("   | | | __ | _|   \\ V / O || || |) |  ");
    Serial.println("   |_| |_||_|___|   \\_/ \\___/___|___/  ");
    Serial.println("========================================");
    Serial.print("  Void Core Firmware v");
    Serial.println(FIRMWARE_VERSION);
    Serial.println("  ESP32 Prototype");
    Serial.println("========================================");
    Serial.println();

    // --- Module initialization (dependency order) ---

    // 1. BME280 sensor — warn but don't halt if not found
    Serial.print("[Init] BME280 sensor... ");
    if (sensorReader.begin()) {
        Serial.println("OK");
    } else {
        Serial.println("FAILED (check wiring — climate runs in manual mode)");
    }

    // 2. LED controller (restores last mode from Preferences)
    Serial.print("[Init] LED controller... ");
    ledController.begin();
    Serial.print("OK (mode ");
    Serial.print(static_cast<int>(ledController.getMode()));
    Serial.println(")");

    // 3. Button handler (GPIO 17, INPUT_PULLUP)
    Serial.print("[Init] Button handler... ");
    buttonHandler.begin();
    Serial.println("OK");

    // 4. UV-C sterilization controller
    Serial.print("[Init] UV-C controller... ");
    uvcController.begin();
    // uvcController.begin() prints its own status

    // 5-7. Climate controller (also initializes fan and humidifier)
    Serial.print("[Init] Climate controller... ");
    climateController.begin();
    Serial.println("OK");

    // 8. Web dashboard (WiFi AP + REST API + SPIFFS)
    Serial.print("[Init] Web server... ");
    webServer.begin();
    Serial.print("OK (AP: ");
    Serial.print(AP_SSID);
    Serial.print(", IP: ");
    Serial.print(webServer.getIPAddress());
    Serial.println(")");

    Serial.println();
    Serial.println("========================================");
    Serial.println("  Setup complete. All systems initialized.");
    Serial.println("========================================");
    Serial.println();
}

// -----------------------------------------------------------------------------
// Main Loop (non-blocking, millis()-based scheduling)
// -----------------------------------------------------------------------------

void loop() {
    unsigned long now = millis();

    // -------------------------------------------------------------------------
    // 1. Button input (runs every iteration for responsive input)
    // -------------------------------------------------------------------------
    ButtonEvent event = buttonHandler.update();

    if (event == ButtonEvent::SHORT_PRESS) {
        // Cycle LED mode: 1 -> 2 -> 3 -> 4 -> 1
        LightMode next = nextMode(ledController.getMode());
        ledController.setMode(next);
        Serial.print("[Main] Mode cycled to: ");
        Serial.println(static_cast<int>(next));

    } else if (event == ButtonEvent::LONG_PRESS) {
        if (uvcController.isActive()) {
            // UV-C is running — stop sterilization and restore grow lights
            uvcController.stop();
            ledController.setLightsEnabled(true);
            Serial.println("[Main] UV-C manually stopped — grow lights restored");
        } else {
            // UV-C is not running — disable grow lights and start sterilization
            ledController.setLightsEnabled(false);

            if (!uvcController.startSterilization()) {
                // UV-C refused (dome not seated) — restore grow lights
                ledController.setLightsEnabled(true);
                Serial.println("[Main] UV-C refused — grow lights restored");
            }
        }
    }

    // -------------------------------------------------------------------------
    // 2. LED 12-hour cycle timer
    // -------------------------------------------------------------------------
    ledController.update();

    // -------------------------------------------------------------------------
    // 3. UV-C sterilization controller (auto-shutoff + reed switch monitoring)
    // -------------------------------------------------------------------------
    uvcController.update();

    // Detect UV-C cycle completion: restore grow lights when UV-C finishes
    // (handles auto-shutoff and emergency stop — not manual stop, which is
    // handled above in the LONG_PRESS handler)
    if (wasUvcActive && !uvcController.isActive()) {
        ledController.setLightsEnabled(true);
        Serial.println("[Main] UV-C cycle complete — grow lights restored");
    }
    wasUvcActive = uvcController.isActive();

    // -------------------------------------------------------------------------
    // 4. Sensor polling (non-blocking, SENSOR_POLL_MS interval)
    // -------------------------------------------------------------------------
    if (now - lastSensorRead >= SENSOR_POLL_MS || lastSensorRead == 0) {
        lastSensorRead = now;

        if (sensorReader.read()) {
            const SensorData& d = sensorReader.getData();
            Serial.print("BME280: ");
            Serial.print(d.temperature, 1);
            Serial.print("\xC2\xB0""C, ");
            Serial.print(d.humidity, 1);
            Serial.print("% RH, ");
            Serial.print(d.pressure, 1);
            Serial.println(" hPa");

            // Climate control runs after each successful sensor read
            climateController.update();
        } else {
            Serial.println("BME280: read failed");
        }
    }

    // -------------------------------------------------------------------------
    // 5. Humidifier software PWM (must run every loop iteration)
    // -------------------------------------------------------------------------
    humidifierController.update();
}
