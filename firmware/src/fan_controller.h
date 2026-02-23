// =============================================================================
// The Void -- Fan PWM Controller
// =============================================================================
//
// Hardware PWM driver for the 30mm axial fan via ESP32 LEDC peripheral.
// Uses LEDC channel 0 at 25kHz with 8-bit resolution (0-255 duty range).
//
// The fan requires a minimum duty cycle (FAN_MIN_DUTY) to avoid stalling.
// Any non-zero duty below FAN_MIN_DUTY is clamped up to FAN_MIN_DUTY.
//
// Pin: GPIO 14 (PIN_FAN_PWM from config.h)
// LEDC channel: 0 (FAN_PWM_CHANNEL from config.h)
// Frequency: 25kHz (FAN_PWM_FREQ from config.h)
// Resolution: 8-bit (FAN_PWM_RESOLUTION from config.h)
//
// =============================================================================

#ifndef VOID_FAN_CONTROLLER_H
#define VOID_FAN_CONTROLLER_H

#include <Arduino.h>

class FanController {
public:
    /// Configure LEDC PWM channel for the fan.
    /// Sets up hardware PWM on GPIO 14 at 25kHz, 8-bit resolution.
    /// Fan starts stopped (duty = 0).
    void begin();

    /// Set PWM duty cycle directly (0 = off, 255 = max).
    /// Non-zero values below FAN_MIN_DUTY are clamped up to prevent stalling.
    void setSpeed(uint8_t duty);

    /// Convenience: set speed as a percentage (0.0 - 100.0).
    /// Maps to 0-255 duty cycle range.
    void setSpeedPercent(float percent);

    /// Stop the fan (set duty to 0).
    void stop();

    /// Return the current duty cycle value (0-255).
    uint8_t getSpeed() const;

    /// Return true if the fan is currently running (duty > 0).
    bool isRunning() const;

private:
    uint8_t currentDuty = 0;
};

#endif // VOID_FAN_CONTROLLER_H
