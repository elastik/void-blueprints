// =============================================================================
// The Void -- Climate Controller
// =============================================================================
//
// Coordinates BME280 sensor readings with fan and humidifier actuators to
// maintain target humidity inside the cultivation dome.
//
// Control behavior (from FIRMWARE-DOCS.md Section 4.3):
//   - Humidity LOW  (< setpoint - deadband): activate humidifier proportionally
//   - Humidity HIGH (> setpoint + deadband): disable humidifier, vent with fan
//   - Humidity OK   (within deadband):       disable humidifier, fan at base
//
// Fan always runs at minimum base speed for continuous air circulation (FAE).
//
// TODO: CO2 management requires SCD40 sensor (not in prototype BOM).
//       When SCD40 is added, implement: <600ppm normal, 600-1000ppm ramp fan,
//       >1000ppm alarm + max fan. See FIRMWARE-DOCS.md Section 4.3.
//
// =============================================================================

#ifndef VOID_CLIMATE_CONTROLLER_H
#define VOID_CLIMATE_CONTROLLER_H

#include <Arduino.h>
#include "config.h"
#include "sensor_reader.h"
#include "fan_controller.h"
#include "humidifier_controller.h"

// -----------------------------------------------------------------------------
// Climate Settings
// -----------------------------------------------------------------------------

struct ClimateSettings {
    float humiditySetpoint = HUMIDITY_SETPOINT;   // Target RH% (default 88%)
    float humidityDeadband = HUMIDITY_DEADBAND;    // +/- RH% (default 2%)
    uint8_t fanBaseSpeed   = FAN_MIN_DUTY;         // Minimum fan duty for FAE
    bool autoMode          = true;                 // Auto climate control enabled
};

// -----------------------------------------------------------------------------
// Climate Controller Class
// -----------------------------------------------------------------------------

class ClimateController {
public:
    /// Constructor: takes references to sensor reader and both actuators.
    ClimateController(SensorReader& sensor, FanController& fan,
                      HumidifierController& humidifier);

    /// Initialize actuators and load settings from Preferences.
    void begin();

    /// Main control loop -- call after each sensor read.
    /// Adjusts fan speed and humidifier duty based on current humidity.
    void update();

    /// Update climate settings and save to Preferences.
    void setSettings(const ClimateSettings& s);

    /// Return current climate settings.
    const ClimateSettings& getSettings() const;

    /// Return true if the humidifier is currently enabled.
    bool isHumidifierActive() const;

    /// Return the current fan duty cycle (0-255).
    uint8_t getCurrentFanSpeed() const;

    /// Return human-readable status string.
    String getStatus() const;

private:
    SensorReader& sensorReader;
    FanController& fanController;
    HumidifierController& humidifierController;

    ClimateSettings settings;

    // Fan venting state for excess humidity
    bool ventingActive = false;
    unsigned long ventStartTime = 0;
    static constexpr unsigned long VENT_DURATION_MS = 30000;  // 30 seconds

    /// Save settings to NVS Preferences.
    void saveSettings();

    /// Load settings from NVS Preferences.
    void loadSettings();
};

#endif // VOID_CLIMATE_CONTROLLER_H
