// =============================================================================
// The Void -- UV-C Sterilization Controller Implementation
// =============================================================================
//
// SAFETY NOTE:
// The reed switch is wired IN SERIES with the UV-C LED hardware power line.
// This means UV-C physically cannot receive power when the dome is removed,
// regardless of software state. The software checks below are an ADDITIONAL
// safety layer -- the hardware interlock is the PRIMARY safety mechanism.
//
// See FIRMWARE-DOCS.md Section 2.5 for full safety documentation.
// See firmware/UV-C-SAFETY-TEST.md for the mandatory test procedure.
//
// =============================================================================

#include "uvc_controller.h"
#include "config.h"

// -----------------------------------------------------------------------------
// begin()
// -----------------------------------------------------------------------------

void UvcController::begin() {
    // Configure UV-C trigger as output, ensure OFF at startup
    pinMode(PIN_UVC, OUTPUT);
    digitalWrite(PIN_UVC, LOW);

    // Configure reed switch as input with pull-up (LOW = dome seated)
    pinMode(PIN_REED, INPUT_PULLUP);

    // Configure indicator LED as output, ensure OFF at startup
    pinMode(PIN_INDICATOR, OUTPUT);
    digitalWrite(PIN_INDICATOR, LOW);

    active = false;
    startTime = 0;

    Serial.println("[UVC] Controller ready (GPIO 27=trigger, GPIO 16=reed, GPIO 2=indicator)");
}

// -----------------------------------------------------------------------------
// isDomeSeated()
// -----------------------------------------------------------------------------

bool UvcController::isDomeSeated() const {
    // Reed switch is INPUT_PULLUP: LOW when magnet closes the switch (dome seated)
    return digitalRead(PIN_REED) == LOW;
}

// -----------------------------------------------------------------------------
// startSterilization()
// -----------------------------------------------------------------------------

bool UvcController::startSterilization() {
    // SOFTWARE SAFETY CHECK (additional layer -- hardware interlock is primary)
    if (!isDomeSeated()) {
        Serial.println("[UVC] UV-C REFUSED: dome not detected");
        return false;
    }

    // Start the sterilization cycle
    active = true;
    startTime = millis();

    // Activate UV-C trigger (hardware reed switch still gates actual power)
    digitalWrite(PIN_UVC, HIGH);

    // Activate red indicator LED to warn users
    digitalWrite(PIN_INDICATOR, HIGH);

    Serial.println("[UVC] UV-C STARTED: 15-minute sterilization cycle");
    return true;
}

// -----------------------------------------------------------------------------
// stop()
// -----------------------------------------------------------------------------

void UvcController::stop() {
    // Cut UV-C trigger signal
    digitalWrite(PIN_UVC, LOW);

    // Turn off indicator LED
    digitalWrite(PIN_INDICATOR, LOW);

    active = false;

    Serial.println("[UVC] UV-C STOPPED");
}

// -----------------------------------------------------------------------------
// update()
// -----------------------------------------------------------------------------

void UvcController::update() {
    if (!active) {
        return;
    }

    // --- Auto-shutoff check: 15-minute maximum cycle duration ---
    if (millis() - startTime >= UVC_TIMEOUT_MS) {
        stop();
        Serial.println("[UVC] UV-C AUTO-SHUTOFF: 15 minutes elapsed");
        return;
    }

    // --- Reed switch safety check (additional software layer) ---
    // Hardware interlock already cuts power if dome is removed, but we also
    // stop the software cycle to keep state consistent and log the event.
    if (!isDomeSeated()) {
        stop();
        Serial.println("[UVC] UV-C EMERGENCY STOP: dome removed during sterilization");
        return;
    }
}

// -----------------------------------------------------------------------------
// isActive()
// -----------------------------------------------------------------------------

bool UvcController::isActive() const {
    return active;
}

// -----------------------------------------------------------------------------
// getRemainingMs()
// -----------------------------------------------------------------------------

unsigned long UvcController::getRemainingMs() const {
    if (!active) {
        return 0;
    }

    unsigned long elapsed = millis() - startTime;
    if (elapsed >= UVC_TIMEOUT_MS) {
        return 0;
    }

    return UVC_TIMEOUT_MS - elapsed;
}
