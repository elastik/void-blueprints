// =============================================================================
// The Void -- Humidifier Duty Cycle Controller
// =============================================================================
//
// Software duty cycling controller for the piezo humidifier disc.
// The humidifier disc has its own 113kHz oscillator circuit -- the ESP32
// GPIO simply enables/disables the driver board. No hardware PWM needed.
//
// Uses software on/off cycling with a configurable period (default 10s).
// Example: duty=0.3, period=10000ms -> on for 3s, off for 7s.
//
// Pin: GPIO 13 (PIN_HUMIDIFIER from config.h)
//
// IMPORTANT: Call update() every iteration of loop() for accurate timing.
//
// =============================================================================

#ifndef VOID_HUMIDIFIER_CONTROLLER_H
#define VOID_HUMIDIFIER_CONTROLLER_H

#include <Arduino.h>

class HumidifierController {
public:
    /// Configure GPIO 13 as OUTPUT and set LOW (humidifier off).
    void begin();

    /// Enable or disable the humidifier.
    /// When disabled, GPIO is set LOW immediately.
    void setEnabled(bool on);

    /// Set the software duty cycle (0.0 - 1.0) and period in milliseconds.
    /// Default period is 10000ms (10 seconds).
    /// Resets the cycle timer on change.
    void setDutyCycle(float duty, unsigned long periodMs = 10000);

    /// Call every loop() iteration for software PWM timing.
    /// Toggles GPIO based on current position within the duty cycle period.
    void update();

    /// Return true if the humidifier is currently enabled.
    bool isEnabled() const;

    /// Return true if the GPIO is currently HIGH (actively misting).
    bool isCurrentlyOn() const;

    /// Return the current duty cycle setting (0.0 - 1.0).
    float getDutyCycle() const;

private:
    bool enabled = false;
    float dutyCycle = 0.0f;
    unsigned long periodMs = 10000;
    unsigned long cycleStart = 0;
    bool currentlyOn = false;
};

#endif // VOID_HUMIDIFIER_CONTROLLER_H
