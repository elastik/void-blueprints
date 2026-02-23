// =============================================================================
// The Void -- Fan PWM Controller Implementation
// =============================================================================

#include "fan_controller.h"
#include "config.h"

void FanController::begin() {
    ledcSetup(FAN_PWM_CHANNEL, FAN_PWM_FREQ, FAN_PWM_RESOLUTION);
    ledcAttachPin(PIN_FAN_PWM, FAN_PWM_CHANNEL);
    ledcWrite(FAN_PWM_CHANNEL, 0);
    currentDuty = 0;

    Serial.println("[Fan] Initialized: GPIO 14, LEDC ch0, 25kHz, 8-bit");
}

void FanController::setSpeed(uint8_t duty) {
    // Clamp non-zero duty to minimum to prevent fan stalling
    if (duty > 0 && duty < FAN_MIN_DUTY) {
        duty = FAN_MIN_DUTY;
    }

    ledcWrite(FAN_PWM_CHANNEL, duty);
    currentDuty = duty;
}

void FanController::setSpeedPercent(float percent) {
    // Clamp to 0-100 range
    if (percent < 0.0f) percent = 0.0f;
    if (percent > 100.0f) percent = 100.0f;

    // Map 0-100% to 0-255
    uint8_t duty = static_cast<uint8_t>((percent / 100.0f) * 255.0f);
    setSpeed(duty);
}

void FanController::stop() {
    ledcWrite(FAN_PWM_CHANNEL, 0);
    currentDuty = 0;
}

uint8_t FanController::getSpeed() const {
    return currentDuty;
}

bool FanController::isRunning() const {
    return currentDuty > 0;
}
