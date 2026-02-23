// =============================================================================
// The Void -- Button Handler
// =============================================================================
//
// Debounced button input with short-press and long-press detection.
// Uses INPUT_PULLUP on GPIO 17 (active LOW — LOW = pressed).
//
// Debounce time and hold threshold sourced from config.h constants:
//   BUTTON_DEBOUNCE_MS = 50ms
//   BUTTON_HOLD_MS     = 3000ms (3-second long press)
//
// Call update() every loop iteration. It returns NONE most of the time,
// SHORT_PRESS on release after a brief tap, or LONG_PRESS on release
// after holding >= 3 seconds.
//
// =============================================================================

#ifndef VOID_BUTTON_HANDLER_H
#define VOID_BUTTON_HANDLER_H

#include <Arduino.h>

// -----------------------------------------------------------------------------
// Button Event Enum
// -----------------------------------------------------------------------------

enum class ButtonEvent : uint8_t {
    NONE,
    SHORT_PRESS,
    LONG_PRESS
};

// -----------------------------------------------------------------------------
// Button Handler Class
// -----------------------------------------------------------------------------

class ButtonHandler {
public:
    /// Configure button GPIO as INPUT_PULLUP and initialize state.
    void begin();

    /// Call every loop iteration. Returns the detected event (if any).
    /// Events are returned on button release only.
    ButtonEvent update();

private:
    bool lastReading      = HIGH;   // Previous raw reading (HIGH = not pressed)
    bool pressing         = false;  // True while button is held down (debounced)
    unsigned long lastDebounceTime = 0;
    unsigned long pressStartTime   = 0;
};

#endif // VOID_BUTTON_HANDLER_H
