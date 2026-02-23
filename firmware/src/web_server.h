// =============================================================================
// The Void -- Web Dashboard Server
// =============================================================================
//
// WiFi Access Point + REST API + SPIFFS-served HTML dashboard for remote
// monitoring and control of the Void Core.
//
// Runs ESPAsyncWebServer on port 80 in WiFi AP mode (SSID/password from
// config.h). Serves a responsive single-page dashboard from SPIFFS and
// exposes 5 REST API endpoints:
//
//   GET  /status    -- Current sensor readings and system state (JSON)
//   POST /mode      -- Set light mode (JSON body: { "mode": "void_glow" })
//   POST /settings  -- Update climate settings (JSON body)
//   POST /sterilize -- Trigger UV-C cycle (JSON body: { "confirm": true })
//   GET  /config    -- Current configuration and firmware info (JSON)
//   GET  /          -- Serve index.html from SPIFFS
//
// All JSON built with ArduinoJson. CORS headers enabled (local network only).
//
// =============================================================================

#ifndef VOID_WEB_SERVER_H
#define VOID_WEB_SERVER_H

#include <Arduino.h>
#include <ESPAsyncWebServer.h>

// Forward declarations — avoids pulling in full headers
class SensorReader;
class LedController;
class UvcController;
class ClimateController;

// -----------------------------------------------------------------------------
// Web Server Class
// -----------------------------------------------------------------------------

class VoidWebServer {
public:
    /// Constructor: takes references to all controller modules.
    VoidWebServer(SensorReader& sensor, LedController& led,
                  UvcController& uvc, ClimateController& climate);

    /// Start WiFi AP, initialize SPIFFS, register routes, start server.
    void begin();

    /// Return the AP IP address as a String (usually "192.168.4.1").
    String getIPAddress() const;

private:
    AsyncWebServer server;

    SensorReader&      sensorReader;
    LedController&     ledController;
    UvcController&     uvcController;
    ClimateController& climateController;

    /// Register all API routes and static file serving.
    void registerRoutes();

    // --- Route handlers ---
    void handleStatus(AsyncWebServerRequest* request);
    void handleSetMode(AsyncWebServerRequest* request, uint8_t* data, size_t len);
    void handleSetSettings(AsyncWebServerRequest* request, uint8_t* data, size_t len);
    void handleSterilize(AsyncWebServerRequest* request, uint8_t* data, size_t len);
    void handleConfig(AsyncWebServerRequest* request);
};

#endif // VOID_WEB_SERVER_H
