// =============================================================================
// The Void -- Firmware Configuration
// =============================================================================
//
// All pin assignments, timing constants, climate setpoints, and system
// defaults for the Void Core ESP32 prototype.
//
// Pin assignments must match firmware/WIRING.md.
// Timing and climate values sourced from FIRMWARE-DOCS.md.
//
// =============================================================================

#ifndef VOID_CONFIG_H
#define VOID_CONFIG_H

// -----------------------------------------------------------------------------
// Firmware Version
// -----------------------------------------------------------------------------

constexpr const char* FIRMWARE_VERSION = "0.1.0";

// -----------------------------------------------------------------------------
// Pin Assignments (ESP32 DevKit V1)
// See firmware/WIRING.md for wiring diagram and circuit details.
// -----------------------------------------------------------------------------

// I2C -- BME280 sensor
constexpr int PIN_SDA        = 21;  // GPIO 21: BME280 I2C data (bidirectional)
constexpr int PIN_SCL        = 22;  // GPIO 22: BME280 I2C clock (output)

// LED control -- active HIGH, drives N-channel MOSFET gate
constexpr int PIN_UVA        = 25;  // GPIO 25: UV-A LED string enable
constexpr int PIN_BLUE       = 26;  // GPIO 26: Blue LED string enable
constexpr int PIN_UVC        = 27;  // GPIO 27: UV-C trigger (reed switch in series)

// Actuators
constexpr int PIN_FAN_PWM    = 14;  // GPIO 14: Fan PWM (hardware PWM via LEDC)
constexpr int PIN_HUMIDIFIER = 13;  // GPIO 13: Humidifier enable (MOSFET gate)

// Inputs -- internal pull-up, active LOW
constexpr int PIN_REED       = 16;  // GPIO 16: Reed switch (LOW = dome seated)
constexpr int PIN_BUTTON     = 17;  // GPIO 17: Button (LOW = pressed)

// Indicator
constexpr int PIN_INDICATOR  = 2;   // GPIO 2: Red LED (active HIGH, built-in on most DevKits)

// -----------------------------------------------------------------------------
// Timing Constants
// From FIRMWARE-DOCS.md Section 3.3
// -----------------------------------------------------------------------------

constexpr unsigned long LIGHT_CYCLE_MS    = 43200000UL;  // 12 hours in ms
constexpr unsigned long UVC_TIMEOUT_MS    = 900000UL;    // 15 minutes in ms
constexpr unsigned long BUTTON_HOLD_MS    = 3000UL;      // 3-second hold threshold
constexpr unsigned long BUTTON_DEBOUNCE_MS = 50UL;       // Button debounce time

// -----------------------------------------------------------------------------
// Sensor Constants
// -----------------------------------------------------------------------------

constexpr unsigned long SENSOR_POLL_MS    = 30000UL;     // 30-second sensor polling interval

// -----------------------------------------------------------------------------
// Climate Constants
// From FIRMWARE-DOCS.md Section 4.3
// -----------------------------------------------------------------------------

constexpr float HUMIDITY_SETPOINT  = 88.0f;   // Target RH% (user-adjustable 80-95%)
constexpr float HUMIDITY_DEADBAND  = 2.0f;    // +/- RH% deadband around setpoint
constexpr int   CO2_WARNING        = 600;     // ppm -- fan speed starts increasing
constexpr int   CO2_ALARM          = 1000;    // ppm -- maximum fan speed, app notification

// -----------------------------------------------------------------------------
// Fan PWM Constants
// -----------------------------------------------------------------------------

constexpr int FAN_PWM_CHANNEL    = 0;      // LEDC channel for fan PWM
constexpr int FAN_PWM_FREQ       = 25000;  // 25 kHz PWM frequency
constexpr int FAN_PWM_RESOLUTION = 8;      // 8-bit resolution (0-255)
constexpr int FAN_MIN_DUTY       = 50;     // Minimum duty cycle (fan stall threshold)
constexpr int FAN_MAX_DUTY       = 255;    // Maximum duty cycle (full speed)

// -----------------------------------------------------------------------------
// WiFi Defaults
// -----------------------------------------------------------------------------

constexpr const char* AP_SSID     = "VoidCore";
constexpr const char* AP_PASSWORD = "voidgrows";

#endif // VOID_CONFIG_H
