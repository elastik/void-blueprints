# UV-C Sterilization Safety Test Procedure

```
===========================================================================
  SAFETY: UV-C RADIATION HAZARD

  The UV-C LED (275nm) emits germicidal ultraviolet radiation that is
  harmful to eyes and skin. The dose inside the dome (90-180 mJ/cm2)
  is 15-30x the ACGIH 8-hour exposure limit for humans.

  - NEVER look directly at the UV-C LED when powered
  - ALWAYS ensure the dome is fully seated during sterilization
  - The hardware interlock prevents UV-C from activating without the
    dome, but you MUST verify it works before first use (see below)
  - The red indicator LED on the base lights during UV-C -- if it is
    on, do NOT remove the dome
  - If the interlock fails, IMMEDIATELY disconnect USB power
===========================================================================
```

## Pre-Test Requirements

Before running any tests, verify the following:

- [ ] Reed switch wired **in series** with UV-C LED power line (verify wiring before powering on)
- [ ] Dome with embedded neodymium magnet available
- [ ] USB power source connected to ESP32
- [ ] Serial monitor open at 115200 baud
- [ ] Fire extinguisher accessible (electronics bench safety)

---

## Test 1 -- Reed Switch Interlock Verification

Verifies that UV-C cannot activate when the dome is not present.

**Steps:**

1. Remove dome from base (ensure magnet is not near reed switch)
2. Press and hold the button for 3+ seconds, then release

**Expected Results:**

- Serial log shows `[UVC] UV-C REFUSED: dome not detected`
- Serial log shows `[Main] UV-C refused -- grow lights restored`
- Red indicator LED (GPIO 2) stays OFF
- UV-C LED does NOT illuminate

**Fail Condition:**

Red indicator LED turns on, or UV-C LED illuminates without dome present. **DISCONNECT POWER IMMEDIATELY.** Check reed switch wiring -- it must be in series with UV-C power, not just a software input.

---

## Test 2 -- Dome Removal Emergency Stop

Verifies that removing the dome during an active UV-C cycle immediately stops sterilization.

**Steps:**

1. Seat dome on base (magnet closes reed switch)
2. Press and hold the button for 3+ seconds, then release
3. Confirm red indicator LED turns on and Serial shows `[UVC] UV-C STARTED: 15-minute sterilization cycle`
4. While red LED is on, carefully lift the dome off the base

**Expected Results:**

- Red indicator LED immediately turns off
- Serial log shows `[UVC] UV-C EMERGENCY STOP: dome removed during sterilization`
- Serial log shows `[Main] UV-C cycle complete -- grow lights restored`

**Fail Condition:**

Red indicator LED stays on after dome removal. **DISCONNECT POWER IMMEDIATELY.** The hardware interlock (reed switch in series) should have cut power at the hardware level regardless -- if the LED stays on, the reed switch is not wired in series. Fix wiring before proceeding.

---

## Test 3 -- Auto-Shutoff Timer

Verifies that UV-C automatically stops after the timeout period.

**Steps:**

1. In `firmware/src/config.h`, temporarily change `UVC_TIMEOUT_MS` to `10000UL` (10 seconds)
2. Rebuild and flash firmware
3. Seat dome on base
4. Press and hold the button for 3+ seconds, then release
5. Wait 10 seconds without touching anything

**Expected Results:**

- Red indicator LED turns off automatically after 10 seconds
- Serial log shows `[UVC] UV-C AUTO-SHUTOFF: 15 minutes elapsed`
- Serial log shows `[Main] UV-C cycle complete -- grow lights restored`

**After Test:**

Restore `UVC_TIMEOUT_MS` to `900000UL` (15 minutes) in `config.h` and reflash.

---

## Test 4 -- No Restart After Dome Re-Seat

Verifies that UV-C does not automatically restart when the dome is replaced after an emergency stop.

**Steps:**

1. Seat dome on base
2. Press and hold the button for 3+ seconds to start UV-C cycle
3. Remove dome (emergency stop triggers -- red LED turns off)
4. Replace dome on base
5. Wait 5 seconds

**Expected Results:**

- UV-C does NOT restart automatically after dome is replaced
- Red indicator LED stays OFF
- A new 3-second button hold is required to start a new UV-C cycle

**Fail Condition:**

UV-C restarts automatically when dome is replaced. This indicates the `startSterilization()` function is being called on dome re-seat rather than only on button long press. Fix the main loop logic -- UV-C should only start from the `LONG_PRESS` handler.

---

## Pass Criteria

All 4 tests must pass before the UV-C sterilization feature is considered safe for use.

| Test | Result | Date | Tester |
|------|--------|------|--------|
| 1. Reed Switch Interlock | | | |
| 2. Dome Removal Emergency Stop | | | |
| 3. Auto-Shutoff Timer | | | |
| 4. No Restart After Dome Re-Seat | | | |
