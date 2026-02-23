// =============================================================================
// The Void -- Climate Controller Implementation
// =============================================================================

#include "climate_controller.h"
#include "config.h"
#include <Preferences.h>

// Preferences namespace for climate settings
static const char* CLIMATE_NS = "climate";

// =============================================================================
// Constructor
// =============================================================================

ClimateController::ClimateController(SensorReader& sensor, FanController& fan,
                                     HumidifierController& humidifier)
    : sensorReader(sensor)
    , fanController(fan)
    , humidifierController(humidifier)
{
}

// =============================================================================
// Initialization
// =============================================================================

void ClimateController::begin() {
    // Initialize actuators
    fanController.begin();
    humidifierController.begin();

    // Load saved settings from NVS
    loadSettings();

    // Start fan at base speed for continuous air circulation
    fanController.setSpeed(settings.fanBaseSpeed);

    Serial.println("[Climate] Initialized");
    Serial.print("[Climate] Setpoint: ");
    Serial.print(settings.humiditySetpoint, 1);
    Serial.print("% +/- ");
    Serial.print(settings.humidityDeadband, 1);
    Serial.print("%, Auto: ");
    Serial.println(settings.autoMode ? "ON" : "OFF");
}

// =============================================================================
// Main Control Loop
// =============================================================================

void ClimateController::update() {
    // Only control in auto mode
    if (!settings.autoMode) {
        return;
    }

    // Only act on valid sensor data
    const SensorData& data = sensorReader.getData();
    if (!data.valid) {
        return;
    }

    float humidity = data.humidity;
    float setpoint = settings.humiditySetpoint;
    float deadband = settings.humidityDeadband;
    unsigned long now = millis();

    // --- Humidity LOW: activate humidifier proportionally ---
    if (humidity < (setpoint - deadband)) {
        float deficit = setpoint - humidity;

        // Proportional duty: deficit/10 gives 0.0-1.0 range
        // 5% below setpoint -> 50% duty, 10%+ below -> 100% duty
        float duty = deficit / 10.0f;
        if (duty > 1.0f) duty = 1.0f;

        humidifierController.setDutyCycle(duty);
        humidifierController.setEnabled(true);

        // Keep fan at base speed -- don't blow away the mist
        fanController.setSpeed(settings.fanBaseSpeed);
        ventingActive = false;

        Serial.print("[Climate] ");
        Serial.print(humidity, 1);
        Serial.print("% RH (target ");
        Serial.print(setpoint, 0);
        Serial.print("+/-");
        Serial.print(deadband, 0);
        Serial.print(") | Fan: ");
        Serial.print((settings.fanBaseSpeed * 100) / 255);
        Serial.print("% | Humidifier: ");
        Serial.print(static_cast<int>(duty * 100));
        Serial.println("% duty");
    }
    // --- Humidity HIGH: vent with fan ---
    else if (humidity > (setpoint + deadband)) {
        // Disable humidifier
        humidifierController.setEnabled(false);

        // Start or continue venting at 80% fan speed
        if (!ventingActive) {
            ventingActive = true;
            ventStartTime = now;
            fanController.setSpeedPercent(80.0f);
        }

        // After 30 seconds, return to base speed
        if (ventingActive && (now - ventStartTime >= VENT_DURATION_MS)) {
            fanController.setSpeed(settings.fanBaseSpeed);
            ventingActive = false;
        }

        Serial.print("[Climate] ");
        Serial.print(humidity, 1);
        Serial.print("% RH (target ");
        Serial.print(setpoint, 0);
        Serial.print("+/-");
        Serial.print(deadband, 0);
        Serial.print(") | Fan: ");
        Serial.print(ventingActive ? "VENTING 80%" : "base");
        Serial.println(" | Humidifier: OFF");
    }
    // --- Within deadband: steady state ---
    else {
        humidifierController.setEnabled(false);
        fanController.setSpeed(settings.fanBaseSpeed);
        ventingActive = false;

        Serial.print("[Climate] ");
        Serial.print(humidity, 1);
        Serial.print("% RH (target ");
        Serial.print(setpoint, 0);
        Serial.print("+/-");
        Serial.print(deadband, 0);
        Serial.println(") | Fan: base | Humidifier: OFF | Steady state");
    }
}

// =============================================================================
// Settings Management
// =============================================================================

void ClimateController::setSettings(const ClimateSettings& s) {
    settings = s;
    saveSettings();

    // Apply immediately
    if (settings.autoMode) {
        fanController.setSpeed(settings.fanBaseSpeed);
    }

    Serial.print("[Climate] Settings updated: ");
    Serial.print(settings.humiditySetpoint, 1);
    Serial.print("% +/- ");
    Serial.print(settings.humidityDeadband, 1);
    Serial.println("%");
}

const ClimateSettings& ClimateController::getSettings() const {
    return settings;
}

bool ClimateController::isHumidifierActive() const {
    return humidifierController.isEnabled();
}

uint8_t ClimateController::getCurrentFanSpeed() const {
    return fanController.getSpeed();
}

String ClimateController::getStatus() const {
    const SensorData& data = sensorReader.getData();

    String status = "Climate: ";

    if (data.valid) {
        status += String(data.humidity, 1) + "% RH";
    } else {
        status += "no data";
    }

    status += " (target " + String(settings.humiditySetpoint, 0);
    status += "+/-" + String(settings.humidityDeadband, 0) + ")";
    status += " | Fan: " + String((fanController.getSpeed() * 100) / 255) + "%";
    status += " | Humidifier: ";
    status += humidifierController.isEnabled() ? "ON" : "OFF";
    status += " | Mode: ";
    status += settings.autoMode ? "AUTO" : "MANUAL";

    return status;
}

// =============================================================================
// Preferences Persistence
// =============================================================================

void ClimateController::saveSettings() {
    Preferences prefs;
    prefs.begin(CLIMATE_NS, false);
    prefs.putFloat("setpoint", settings.humiditySetpoint);
    prefs.putFloat("deadband", settings.humidityDeadband);
    prefs.putUChar("fanBase", settings.fanBaseSpeed);
    prefs.putBool("autoMode", settings.autoMode);
    prefs.end();
}

void ClimateController::loadSettings() {
    Preferences prefs;
    prefs.begin(CLIMATE_NS, true);  // read-only

    settings.humiditySetpoint = prefs.getFloat("setpoint", HUMIDITY_SETPOINT);
    settings.humidityDeadband = prefs.getFloat("deadband", HUMIDITY_DEADBAND);
    settings.fanBaseSpeed     = prefs.getUChar("fanBase", FAN_MIN_DUTY);
    settings.autoMode         = prefs.getBool("autoMode", true);

    prefs.end();
}
