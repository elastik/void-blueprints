// =============================================================================
// The Void -- Web Dashboard Server Implementation
// =============================================================================

#include "web_server.h"
#include "config.h"
#include "sensor_reader.h"
#include "led_controller.h"
#include "uvc_controller.h"
#include "climate_controller.h"

#include <WiFi.h>
#include <SPIFFS.h>
#include <ArduinoJson.h>

// =============================================================================
// Helper: Map LightMode enum to/from JSON string
// =============================================================================

static const char* lightModeToString(LightMode mode) {
    switch (mode) {
        case LightMode::VOID_GLOW: return "void_glow";
        case LightMode::UV_ONLY:   return "uv_only";
        case LightMode::BLUE_ONLY: return "blue_only";
        case LightMode::OFF:       return "off";
        default:                   return "unknown";
    }
}

static bool stringToLightMode(const char* str, LightMode& out) {
    if (strcmp(str, "void_glow") == 0) { out = LightMode::VOID_GLOW; return true; }
    if (strcmp(str, "uv_only")   == 0) { out = LightMode::UV_ONLY;   return true; }
    if (strcmp(str, "blue_only") == 0) { out = LightMode::BLUE_ONLY; return true; }
    if (strcmp(str, "off")       == 0) { out = LightMode::OFF;       return true; }
    return false;
}

// =============================================================================
// Constructor
// =============================================================================

VoidWebServer::VoidWebServer(SensorReader& sensor, LedController& led,
                             UvcController& uvc, ClimateController& climate)
    : server(80)
    , sensorReader(sensor)
    , ledController(led)
    , uvcController(uvc)
    , climateController(climate)
{
}

// =============================================================================
// begin() — WiFi AP + SPIFFS + Routes + Server start
// =============================================================================

void VoidWebServer::begin() {
    // --- Start WiFi in Access Point mode ---
    WiFi.softAP(AP_SSID, AP_PASSWORD);
    Serial.print("[Web] WiFi AP started — SSID: ");
    Serial.println(AP_SSID);
    Serial.print("[Web] IP address: ");
    Serial.println(WiFi.softAPIP());

    // --- Initialize SPIFFS for serving the dashboard HTML ---
    if (!SPIFFS.begin(true)) {
        Serial.println("[Web] SPIFFS mount failed");
    } else {
        Serial.println("[Web] SPIFFS mounted");
    }

    // --- Register REST API routes and static file serving ---
    registerRoutes();

    // --- Start the async web server ---
    server.begin();
    Serial.println("[Web] Server started on port 80");
}

// =============================================================================
// getIPAddress()
// =============================================================================

String VoidWebServer::getIPAddress() const {
    return WiFi.softAPIP().toString();
}

// =============================================================================
// Route Registration
// =============================================================================

void VoidWebServer::registerRoutes() {
    // --- CORS: Add default headers to all responses ---
    DefaultHeaders::Instance().addHeader("Access-Control-Allow-Origin", "*");
    DefaultHeaders::Instance().addHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
    DefaultHeaders::Instance().addHeader("Access-Control-Allow-Headers", "Content-Type");

    // --- GET /status ---
    server.on("/status", HTTP_GET, [this](AsyncWebServerRequest* request) {
        handleStatus(request);
    });

    // --- POST /mode ---
    server.on("/mode", HTTP_POST, [](AsyncWebServerRequest* request) {
        // Body handler sends the response; this is the request-complete callback
    }, nullptr, [this](AsyncWebServerRequest* request, uint8_t* data, size_t len,
                       size_t index, size_t total) {
        handleSetMode(request, data, len);
    });

    // --- POST /settings ---
    server.on("/settings", HTTP_POST, [](AsyncWebServerRequest* request) {
    }, nullptr, [this](AsyncWebServerRequest* request, uint8_t* data, size_t len,
                       size_t index, size_t total) {
        handleSetSettings(request, data, len);
    });

    // --- POST /sterilize ---
    server.on("/sterilize", HTTP_POST, [](AsyncWebServerRequest* request) {
    }, nullptr, [this](AsyncWebServerRequest* request, uint8_t* data, size_t len,
                       size_t index, size_t total) {
        handleSterilize(request, data, len);
    });

    // --- GET /config ---
    server.on("/config", HTTP_GET, [this](AsyncWebServerRequest* request) {
        handleConfig(request);
    });

    // --- OPTIONS preflight for CORS ---
    server.on("/mode", HTTP_OPTIONS, [](AsyncWebServerRequest* request) {
        request->send(204);
    });
    server.on("/settings", HTTP_OPTIONS, [](AsyncWebServerRequest* request) {
        request->send(204);
    });
    server.on("/sterilize", HTTP_OPTIONS, [](AsyncWebServerRequest* request) {
        request->send(204);
    });

    // --- Static files: serve index.html from SPIFFS ---
    server.serveStatic("/", SPIFFS, "/").setDefaultFile("index.html");
}

// =============================================================================
// GET /status — Current readings and system state
// =============================================================================

void VoidWebServer::handleStatus(AsyncWebServerRequest* request) {
    JsonDocument doc;

    // Sensor data
    const SensorData& d = sensorReader.getData();
    doc["temperature"]  = serialized(String(d.temperature, 1));
    doc["humidity"]     = serialized(String(d.humidity, 1));
    doc["pressure"]     = serialized(String(d.pressure, 1));
    doc["sensorValid"]  = d.valid;

    // Light state
    doc["lightMode"]    = lightModeToString(ledController.getMode());
    doc["lightCycleOn"] = ledController.isLightCycleOn();

    // UV-C state
    doc["uvcActive"]      = uvcController.isActive();
    doc["uvcRemainingMs"] = uvcController.getRemainingMs();
    doc["domeSeated"]     = uvcController.isDomeSeated();

    // Climate state
    const ClimateSettings& cs = climateController.getSettings();
    doc["fanSpeed"]         = climateController.getCurrentFanSpeed();
    doc["humidifierActive"] = climateController.isHumidifierActive();
    doc["climateAuto"]      = cs.autoMode;

    // System info
    doc["uptime"]  = millis() / 1000;
    doc["version"] = FIRMWARE_VERSION;

    String json;
    serializeJson(doc, json);
    request->send(200, "application/json", json);
}

// =============================================================================
// POST /mode — Set light mode
// =============================================================================

void VoidWebServer::handleSetMode(AsyncWebServerRequest* request,
                                   uint8_t* data, size_t len) {
    JsonDocument doc;
    DeserializationError err = deserializeJson(doc, data, len);

    if (err || !doc["mode"].is<const char*>()) {
        request->send(400, "application/json",
                      "{\"error\":\"Invalid JSON or missing 'mode' field\"}");
        return;
    }

    const char* modeStr = doc["mode"];
    LightMode mode;

    if (!stringToLightMode(modeStr, mode)) {
        request->send(400, "application/json",
                      "{\"error\":\"Invalid mode. Use: void_glow, uv_only, blue_only, off\"}");
        return;
    }

    ledController.setMode(mode);
    Serial.print("[Web] Light mode set to: ");
    Serial.println(modeStr);

    JsonDocument resp;
    resp["success"] = true;
    resp["mode"]    = modeStr;

    String json;
    serializeJson(resp, json);
    request->send(200, "application/json", json);
}

// =============================================================================
// POST /settings — Update climate settings
// =============================================================================

void VoidWebServer::handleSetSettings(AsyncWebServerRequest* request,
                                       uint8_t* data, size_t len) {
    JsonDocument doc;
    DeserializationError err = deserializeJson(doc, data, len);

    if (err) {
        request->send(400, "application/json",
                      "{\"error\":\"Invalid JSON\"}");
        return;
    }

    // Get current settings as base, then overlay any provided values
    ClimateSettings settings = climateController.getSettings();

    if (doc["humiditySetpoint"].is<float>()) {
        float val = doc["humiditySetpoint"];
        if (val < 80.0f || val > 95.0f) {
            request->send(400, "application/json",
                          "{\"error\":\"humiditySetpoint must be 80-95\"}");
            return;
        }
        settings.humiditySetpoint = val;
    }

    if (doc["humidityDeadband"].is<float>()) {
        float val = doc["humidityDeadband"];
        if (val < 1.0f || val > 5.0f) {
            request->send(400, "application/json",
                          "{\"error\":\"humidityDeadband must be 1-5\"}");
            return;
        }
        settings.humidityDeadband = val;
    }

    if (doc["fanBaseSpeed"].is<int>()) {
        int val = doc["fanBaseSpeed"];
        if (val < 0 || val > 100) {
            request->send(400, "application/json",
                          "{\"error\":\"fanBaseSpeed must be 0-100\"}");
            return;
        }
        // Convert percentage (0-100) to duty cycle (0-255) for fan controller
        settings.fanBaseSpeed = static_cast<uint8_t>((val * 255) / 100);
    }

    if (doc["autoMode"].is<bool>()) {
        settings.autoMode = doc["autoMode"];
    }

    climateController.setSettings(settings);
    Serial.println("[Web] Climate settings updated");

    // Build response with current settings
    JsonDocument resp;
    resp["success"] = true;

    JsonObject s = resp["settings"].to<JsonObject>();
    s["humiditySetpoint"] = settings.humiditySetpoint;
    s["humidityDeadband"] = settings.humidityDeadband;
    s["fanBaseSpeed"]     = (settings.fanBaseSpeed * 100) / 255;
    s["autoMode"]         = settings.autoMode;

    String json;
    serializeJson(resp, json);
    request->send(200, "application/json", json);
}

// =============================================================================
// POST /sterilize — Trigger UV-C sterilization cycle
// =============================================================================

void VoidWebServer::handleSterilize(AsyncWebServerRequest* request,
                                     uint8_t* data, size_t len) {
    JsonDocument doc;
    DeserializationError err = deserializeJson(doc, data, len);

    if (err || !doc["confirm"].is<bool>() || doc["confirm"].as<bool>() != true) {
        request->send(400, "application/json",
                      "{\"error\":\"Must confirm sterilization\"}");
        return;
    }

    // Disable grow lights before UV-C
    ledController.setLightsEnabled(false);

    // Attempt to start UV-C cycle
    if (!uvcController.startSterilization()) {
        // Dome not seated — restore grow lights
        ledController.setLightsEnabled(true);
        request->send(409, "application/json",
                      "{\"error\":\"Dome not detected\"}");
        return;
    }

    Serial.println("[Web] UV-C sterilization started");

    JsonDocument resp;
    resp["success"]         = true;
    resp["durationMinutes"] = 15;

    String json;
    serializeJson(resp, json);
    request->send(200, "application/json", json);
}

// =============================================================================
// GET /config — Current configuration
// =============================================================================

void VoidWebServer::handleConfig(AsyncWebServerRequest* request) {
    JsonDocument doc;

    // Climate settings
    const ClimateSettings& cs = climateController.getSettings();
    JsonObject climate = doc["climate"].to<JsonObject>();
    climate["humiditySetpoint"] = cs.humiditySetpoint;
    climate["humidityDeadband"] = cs.humidityDeadband;
    climate["fanBaseSpeed"]     = (cs.fanBaseSpeed * 100) / 255;
    climate["autoMode"]         = cs.autoMode;

    // Light mode
    doc["lightMode"] = lightModeToString(ledController.getMode());

    // System
    doc["version"] = FIRMWARE_VERSION;
    doc["uptime"]  = millis() / 1000;
    doc["ssid"]    = AP_SSID;

    String json;
    serializeJson(doc, json);
    request->send(200, "application/json", json);
}
