// =============================================================================
// The Void -- UV-C Sterilization Controller
// =============================================================================
//
// Controls the UV-C sterilization cycle with dual safety layers:
//   1. HARDWARE (PRIMARY): Reed switch wired IN SERIES with UV-C LED power.
//      Even if GPIO 27 is HIGH and all software fails, UV-C physically cannot
//      receive power without the dome magnet closing the reed switch.
//   2. SOFTWARE (ADDITIONAL): This controller checks the reed switch state
//      before activation and continuously during the cycle as a secondary
//      safety layer.
//
// The 15-minute auto-shutoff is implemented in software via millis().
// The base Void uses a hardware 555 timer for this; the ESP32 variant relies
// on software. For production, consider adding a hardware timer as backup.
//
// Pin assignments sourced from config.h:
//   PIN_UVC       (GPIO 27) -- UV-C trigger output (active HIGH)
//   PIN_REED      (GPIO 16) -- Reed switch input (INPUT_PULLUP, LOW = dome seated)
//   PIN_INDICATOR (GPIO 2)  -- Red indicator LED (active HIGH, mirrors UV-C state)
//
// Timing constants sourced from config.h:
//   UVC_TIMEOUT_MS (900000 = 15 minutes)
//
// =============================================================================

#ifndef VOID_UVC_CONTROLLER_H
#define VOID_UVC_CONTROLLER_H

#include <Arduino.h>

// -----------------------------------------------------------------------------
// UV-C Sterilization Controller Class
// -----------------------------------------------------------------------------

class UvcController {
public:
    /// Configure UV-C trigger, reed switch, and indicator GPIO pins.
    /// Ensures UV-C starts in the OFF state.
    void begin();

    /// Attempt to start a UV-C sterilization cycle.
    /// Returns false if the dome is not detected (reed switch open).
    /// Returns true if the cycle was successfully started.
    bool startSterilization();

    /// Immediately cut UV-C power and turn off the indicator LED.
    void stop();

    /// Call every loop iteration. Handles:
    ///   - 15-minute auto-shutoff timer
    ///   - Continuous reed switch monitoring (emergency stop)
    /// Uses millis() -- no delay().
    void update();

    /// Return true if a UV-C sterilization cycle is currently running.
    bool isActive() const;

    /// Return true if the reed switch detects the dome (GPIO 16 == LOW).
    bool isDomeSeated() const;

    /// Return milliseconds remaining in the current cycle (0 if not active).
    unsigned long getRemainingMs() const;

private:
    bool active = false;
    unsigned long startTime = 0;
};

#endif // VOID_UVC_CONTROLLER_H
