// =============================================================================
// The Void -- Humidifier Duty Cycle Controller Implementation
// =============================================================================

#include "humidifier_controller.h"
#include "config.h"

void HumidifierController::begin() {
    pinMode(PIN_HUMIDIFIER, OUTPUT);
    digitalWrite(PIN_HUMIDIFIER, LOW);
    enabled = false;
    currentlyOn = false;
    cycleStart = millis();

    Serial.println("[Humidifier] Initialized: GPIO 13, software duty cycling");
}

void HumidifierController::setEnabled(bool on) {
    enabled = on;

    if (!enabled) {
        // Immediately turn off when disabled
        digitalWrite(PIN_HUMIDIFIER, LOW);
        currentlyOn = false;
    } else {
        // Reset cycle timer when enabling
        cycleStart = millis();
    }
}

void HumidifierController::setDutyCycle(float duty, unsigned long period) {
    // Clamp duty to 0.0 - 1.0
    if (duty < 0.0f) duty = 0.0f;
    if (duty > 1.0f) duty = 1.0f;

    dutyCycle = duty;
    periodMs = period;

    // Reset cycle timer on change
    cycleStart = millis();
}

void HumidifierController::update() {
    if (!enabled) {
        return;
    }

    // Zero duty means always off
    if (dutyCycle <= 0.0f) {
        if (currentlyOn) {
            digitalWrite(PIN_HUMIDIFIER, LOW);
            currentlyOn = false;
        }
        return;
    }

    // Full duty means always on
    if (dutyCycle >= 1.0f) {
        if (!currentlyOn) {
            digitalWrite(PIN_HUMIDIFIER, HIGH);
            currentlyOn = true;
        }
        return;
    }

    // Calculate position within current period
    unsigned long now = millis();
    unsigned long elapsed = now - cycleStart;

    // Wrap around at end of period
    if (elapsed >= periodMs) {
        cycleStart = now;
        elapsed = 0;
    }

    // On for (dutyCycle * periodMs), off for the rest
    unsigned long onTime = static_cast<unsigned long>(dutyCycle * periodMs);
    bool shouldBeOn = (elapsed < onTime);

    if (shouldBeOn && !currentlyOn) {
        digitalWrite(PIN_HUMIDIFIER, HIGH);
        currentlyOn = true;
    } else if (!shouldBeOn && currentlyOn) {
        digitalWrite(PIN_HUMIDIFIER, LOW);
        currentlyOn = false;
    }
}

bool HumidifierController::isEnabled() const {
    return enabled;
}

bool HumidifierController::isCurrentlyOn() const {
    return currentlyOn;
}

float HumidifierController::getDutyCycle() const {
    return dutyCycle;
}
