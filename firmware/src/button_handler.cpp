// =============================================================================
// The Void -- Button Handler Implementation
// =============================================================================

#include "button_handler.h"
#include "config.h"

// -----------------------------------------------------------------------------
// begin()
// -----------------------------------------------------------------------------

void ButtonHandler::begin() {
    pinMode(PIN_BUTTON, INPUT_PULLUP);

    lastReading    = HIGH;
    pressing       = false;
    lastDebounceTime = 0;
    pressStartTime   = 0;

    Serial.println("[BTN] Button handler ready (GPIO 17, INPUT_PULLUP)");
}

// -----------------------------------------------------------------------------
// update()
// -----------------------------------------------------------------------------

ButtonEvent ButtonHandler::update() {
    bool reading = digitalRead(PIN_BUTTON);

    // Reset debounce timer whenever the raw reading changes
    if (reading != lastReading) {
        lastDebounceTime = millis();
    }
    lastReading = reading;

    // If not enough time has passed since last change, ignore (debounce)
    if (millis() - lastDebounceTime < BUTTON_DEBOUNCE_MS) {
        return ButtonEvent::NONE;
    }

    // Reading is now stable — process state transitions
    // Stable LOW (pressed) and wasn't pressing before
    if (reading == LOW && !pressing) {
        pressing = true;
        pressStartTime = millis();
        return ButtonEvent::NONE;
    }

    // Stable HIGH (released) and was pressing
    if (reading == HIGH && pressing) {
        pressing = false;

        unsigned long holdDuration = millis() - pressStartTime;

        if (holdDuration >= BUTTON_HOLD_MS) {
            return ButtonEvent::LONG_PRESS;
        } else {
            return ButtonEvent::SHORT_PRESS;
        }
    }

    return ButtonEvent::NONE;
}
