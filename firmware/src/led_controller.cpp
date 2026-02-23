// =============================================================================
// The Void -- LED Controller Implementation
// =============================================================================

#include "led_controller.h"
#include "config.h"
#include <Preferences.h>

// Preferences namespace and key for persistent mode storage
static const char* PREFS_NAMESPACE = "void";
static const char* PREFS_MODE_KEY  = "lightMode";

// -----------------------------------------------------------------------------
// begin()
// -----------------------------------------------------------------------------

void LedController::begin() {
    // Configure LED pins as outputs, start LOW (off)
    pinMode(PIN_UVA, OUTPUT);
    pinMode(PIN_BLUE, OUTPUT);
    digitalWrite(PIN_UVA, LOW);
    digitalWrite(PIN_BLUE, LOW);

    // Restore last mode from Preferences (ESP32 flash-backed key-value store)
    Preferences prefs;
    prefs.begin(PREFS_NAMESPACE, true);  // read-only
    uint8_t stored = prefs.getUChar(PREFS_MODE_KEY, 0);
    prefs.end();

    if (stored >= static_cast<uint8_t>(LightMode::VOID_GLOW) &&
        stored <= static_cast<uint8_t>(LightMode::OFF)) {
        currentMode = static_cast<LightMode>(stored);
    } else {
        currentMode = LightMode::VOID_GLOW;
    }

    // Initialize cycle state
    lightsEnabled  = true;
    lightCycleOn   = true;
    cycleStartTime = millis();

    Serial.print("[LED] Mode restored: ");
    Serial.println(static_cast<int>(currentMode));

    applyMode();
}

// -----------------------------------------------------------------------------
// setMode()
// -----------------------------------------------------------------------------

void LedController::setMode(LightMode mode) {
    currentMode = mode;

    // Persist to Preferences
    Preferences prefs;
    prefs.begin(PREFS_NAMESPACE, false);  // read-write
    prefs.putUChar(PREFS_MODE_KEY, static_cast<uint8_t>(mode));
    prefs.end();

    Serial.print("[LED] Mode set: ");
    Serial.println(static_cast<int>(currentMode));

    applyMode();
}

// -----------------------------------------------------------------------------
// getMode()
// -----------------------------------------------------------------------------

LightMode LedController::getMode() const {
    return currentMode;
}

// -----------------------------------------------------------------------------
// update()
// -----------------------------------------------------------------------------

void LedController::update() {
    unsigned long now = millis();

    if (now - cycleStartTime >= LIGHT_CYCLE_MS) {
        lightCycleOn   = !lightCycleOn;
        cycleStartTime = now;

        Serial.print("[LED] 12h cycle: ");
        Serial.println(lightCycleOn ? "DAY (lights on)" : "NIGHT (lights off)");

        applyMode();
    }
}

// -----------------------------------------------------------------------------
// setLightsEnabled()
// -----------------------------------------------------------------------------

void LedController::setLightsEnabled(bool enabled) {
    lightsEnabled = enabled;

    Serial.print("[LED] Lights enabled: ");
    Serial.println(enabled ? "true" : "false");

    applyMode();
}

// -----------------------------------------------------------------------------
// isLightCycleOn()
// -----------------------------------------------------------------------------

bool LedController::isLightCycleOn() const {
    return lightCycleOn;
}

// -----------------------------------------------------------------------------
// applyMode() — private
// -----------------------------------------------------------------------------

void LedController::applyMode() {
    // If lights are disabled (UV-C sterilization) or in night phase,
    // force both pins LOW regardless of mode.
    if (!lightsEnabled || !lightCycleOn) {
        digitalWrite(PIN_UVA, LOW);
        digitalWrite(PIN_BLUE, LOW);
        return;
    }

    switch (currentMode) {
        case LightMode::VOID_GLOW:
            digitalWrite(PIN_UVA, HIGH);
            digitalWrite(PIN_BLUE, HIGH);
            break;
        case LightMode::UV_ONLY:
            digitalWrite(PIN_UVA, HIGH);
            digitalWrite(PIN_BLUE, LOW);
            break;
        case LightMode::BLUE_ONLY:
            digitalWrite(PIN_UVA, LOW);
            digitalWrite(PIN_BLUE, HIGH);
            break;
        case LightMode::OFF:
            digitalWrite(PIN_UVA, LOW);
            digitalWrite(PIN_BLUE, LOW);
            break;
    }
}
