// =============================================================================
// The Void -- LED Controller
// =============================================================================
//
// Manages UV-A and Blue LED channels with 4 light modes, persistent mode
// storage via ESP32 Preferences, and a 12-hour on/off light cycle timer.
//
// Modes 1-3 follow the 12h cycle. Mode 4 (Off) keeps lights off regardless.
// setLightsEnabled(false) forces all lights off for UV-C sterilization.
//
// Pin assignments sourced from config.h. Timing from FIRMWARE-DOCS.md.
//
// =============================================================================

#ifndef VOID_LED_CONTROLLER_H
#define VOID_LED_CONTROLLER_H

#include <Arduino.h>

// -----------------------------------------------------------------------------
// Light Mode Enum
// -----------------------------------------------------------------------------

enum class LightMode : uint8_t {
    VOID_GLOW = 1,  // UV-A ON, Blue ON
    UV_ONLY   = 2,  // UV-A ON, Blue OFF
    BLUE_ONLY = 3,  // UV-A OFF, Blue ON
    OFF       = 4   // UV-A OFF, Blue OFF
};

// -----------------------------------------------------------------------------
// LED Controller Class
// -----------------------------------------------------------------------------

class LedController {
public:
    /// Configure UV-A and Blue GPIO pins as OUTPUT, restore mode from
    /// Preferences, initialize 12h light cycle timer.
    void begin();

    /// Set the active light mode and persist to flash via Preferences.
    /// Applies pin states immediately if lights are enabled and cycle is on.
    void setMode(LightMode mode);

    /// Return the current light mode.
    LightMode getMode() const;

    /// Call in loop() -- handles the 12-hour day/night cycle toggle.
    void update();

    /// Override to force all lights off (e.g., during UV-C sterilization).
    /// Pass true to re-enable and re-apply the current mode.
    void setLightsEnabled(bool enabled);

    /// Return true if the 12h cycle is currently in the "day" (lights-on) phase.
    bool isLightCycleOn() const;

private:
    LightMode currentMode = LightMode::VOID_GLOW;
    bool lightsEnabled    = true;
    bool lightCycleOn     = true;
    unsigned long cycleStartTime = 0;

    /// Apply pin states for the current mode, respecting lightsEnabled
    /// and lightCycleOn flags.
    void applyMode();
};

#endif // VOID_LED_CONTROLLER_H
