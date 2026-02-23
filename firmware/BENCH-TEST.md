# The Void -- Bench Test Procedure

> Comprehensive bench testing procedures for validating all Void Core firmware
> subsystems with physical hardware. Run all 9 tests after assembly and before
> first use.
>
> **References:**
> - [WIRING.md](WIRING.md) -- Pin assignments and circuit wiring
> - [UV-C-SAFETY-TEST.md](UV-C-SAFETY-TEST.md) -- Detailed UV-C safety tests

---

## Prerequisites

Before running any tests, verify the following:

- [ ] ESP32 DevKit V1 wired per [WIRING.md](WIRING.md)
- [ ] Components connected: BME280, at least 1 LED (UV-A or Blue), fan, button, reed switch + magnet, indicator LED
- [ ] Humidifier optional (can test control logic via Serial output)
- [ ] USB cable connected to ESP32
- [ ] Serial monitor at 115200 baud
- [ ] PlatformIO installed, firmware compiled and uploaded

## Upload Procedure

```
cd firmware
pio run --target upload
pio device monitor
```

Wait for the startup banner to appear before proceeding.

---

## Test 1 -- Boot & Initialization

Verifies that all firmware modules initialize correctly at power-on.

**Steps:**

1. Power on ESP32 (connect USB cable or press reset button)
2. Observe Serial monitor output

**Expected Results:**

- ASCII art "THE VOID" startup banner appears
- Firmware version displayed (e.g., `Void Core Firmware v0.1.0`)
- Each module reports initialization status:
  - `[Init] BME280 sensor... OK`
  - `[Init] LED controller... OK (mode X)`
  - `[Init] Button handler... OK`
  - `[Init] UV-C controller... OK`
  - `[Init] Climate controller... OK`
  - `[Init] Web server... OK (AP: VoidCore, IP: 192.168.4.1)`
- Final message: `Setup complete. All systems initialized.`

**Pass Criteria:**

All modules report initialized. If BME280 shows FAILED, check I2C wiring (SDA=GPIO 21, SCL=GPIO 22) but note that other modules should still function.

---

## Test 2 -- Sensor Readings

Verifies that the BME280 sensor returns valid environmental data.

**Steps:**

1. Wait 30 seconds after boot for the first sensor poll
2. Observe Serial output for BME280 readings
3. Breathe on the sensor to change humidity

**Expected Results:**

- Serial shows: `BME280: XX.X°C, XX.X% RH, XXXX.X hPa`
- Temperature is reasonable for room environment (18-30°C)
- Humidity increases noticeably when breathing on sensor
- Readings repeat every 30 seconds

**Pass Criteria:**

Readings change in response to environment. Values are within plausible ranges (temperature 10-50°C, humidity 10-100%, pressure 900-1100 hPa).

---

## Test 3 -- Button & LED Modes

Verifies button debounce, mode cycling, and LED pin state changes.

**Steps:**

1. Short press button (quick tap, < 1 second)
2. Observe Serial output and LED state change
3. Short press 3 more times to cycle through all modes
4. Verify each mode:
   - Mode 1 (Void Glow): UV-A ON, Blue ON
   - Mode 2 (UV Only): UV-A ON, Blue OFF
   - Mode 3 (Blue Only): UV-A OFF, Blue ON
   - Mode 4 (Off): UV-A OFF, Blue OFF
5. Press once more to cycle back to Mode 1 (Void Glow)

**Expected Results:**

- Serial shows `[Main] Mode cycled to: X` on each press
- LED pins change state to match the active mode
- No false triggers from button bounce
- Mode wraps from 4 back to 1

**Pass Criteria:**

All 4 modes cycle correctly. LEDs match expected on/off states for each mode. No double-triggers or missed presses.

---

## Test 4 -- UV-C Safety (CRITICAL)

Verifies all UV-C safety mechanisms. **This test is mandatory before first use.**

**Run all 4 tests from [UV-C-SAFETY-TEST.md](UV-C-SAFETY-TEST.md):**

1. Reed Switch Interlock Verification -- UV-C cannot activate without dome
2. Dome Removal Emergency Stop -- removing dome stops active UV-C immediately
3. Auto-Shutoff Timer -- UV-C stops after timeout (test with 10-second override)
4. No Restart After Dome Re-Seat -- UV-C does not auto-restart when dome is replaced

```
===========================================================================
  SAFETY: UV-C RADIATION HAZARD

  - NEVER look directly at the UV-C LED when powered
  - ALWAYS ensure the dome is fully seated during sterilization
  - If the interlock fails, IMMEDIATELY disconnect USB power
===========================================================================
```

**Pass Criteria:**

All 4 UV-C safety tests pass. See UV-C-SAFETY-TEST.md for detailed steps, expected results, and fail conditions.

---

## Test 5 -- Fan Control

Verifies that the fan responds to the climate controller based on humidity readings.

**Steps:**

1. Observe fan after boot -- it should spin at base speed (minimum duty for air circulation)
2. Breathe on BME280 sensor to spike humidity above setpoint (88% default)
3. Wait for the next sensor poll (30 seconds) and observe fan response
4. Allow humidity to drop back below setpoint and observe fan returning to base speed

**Expected Results:**

- Fan runs at base speed after boot (continuous FAE)
- When humidity exceeds setpoint + deadband (90%): fan speed increases for venting
- When humidity returns within deadband: fan returns to base speed
- Serial logs show climate controller status changes

**Pass Criteria:**

Fan responds to climate controller. Speed increases when humidity is above setpoint, returns to base when humidity normalizes.

---

## Test 6 -- Humidifier Control

Verifies humidifier activation in response to low humidity.

**Steps (with humidifier connected):**

1. Ensure ambient humidity is below setpoint (88% default)
2. Observe GPIO 13 -- humidifier should activate with duty cycling
3. Watch for misting behavior (on/off cycling over 10-second period)

**Steps (without humidifier -- Serial/multimeter only):**

1. Ensure ambient humidity is below setpoint
2. Monitor Serial output for climate controller log messages
3. Optionally: use multimeter on GPIO 13 to verify voltage toggling

**Expected Results:**

- Humidifier activates when humidity is below setpoint - deadband (86%)
- Duty cycling visible: GPIO 13 toggles high/low within each 10-second period
- Duty cycle is proportional to humidity deficit (larger deficit = longer on-time)
- Humidifier deactivates when humidity reaches setpoint

**Pass Criteria:**

Humidifier activates proportionally to humidity deficit. If not connected, verify GPIO 13 toggles via Serial log or multimeter reading.

---

## Test 7 -- Web Dashboard

Verifies WiFi AP, REST API, and dashboard functionality.

**Steps:**

1. On phone or laptop, connect to WiFi:
   - SSID: `VoidCore`
   - Password: `voidgrows`
2. Open browser to `http://192.168.4.1`
3. Verify dashboard loads with sensor readings
4. Test mode buttons -- LED should change on the device
5. Test climate settings -- change humidity setpoint, verify controller adjusts
6. Test sterilize button:
   - With dome seated: should start UV-C cycle (red indicator on)
   - Without dome: should show error/refusal

**Expected Results:**

- WiFi connection succeeds with SSID "VoidCore" and password "voidgrows"
- Dashboard loads at 192.168.4.1 with a responsive layout
- Sensor readings update approximately every 2 seconds
- Mode buttons change LED state and dashboard reflects the change
- Climate settings persist and controller adjusts behavior
- Sterilize button respects dome interlock

**Pass Criteria:**

All dashboard features functional. Sensor data displays and updates, controls work bidirectionally (dashboard changes hardware state, hardware changes reflect on dashboard).

---

## Test 8 -- 12-Hour Light Cycle (Abbreviated)

Verifies the automatic day/night light cycle timer.

**Steps:**

1. In `firmware/src/config.h`, temporarily change:
   ```cpp
   constexpr unsigned long LIGHT_CYCLE_MS = 30000UL;  // 30 seconds for testing
   ```
2. Rebuild and upload firmware: `pio run --target upload`
3. Set LED mode to Void Glow (mode 1) so lights are visible
4. Observe lights toggle on/off every 30 seconds
5. After verifying at least 2 full cycles (on -> off -> on), restore original value:
   ```cpp
   constexpr unsigned long LIGHT_CYCLE_MS = 43200000UL;  // 12 hours
   ```
6. Rebuild and upload firmware

**Expected Results:**

- Lights turn on for 30 seconds, then off for 30 seconds
- Cycle repeats automatically without user interaction
- Serial output reflects cycle state changes
- LED mode is preserved across cycle transitions (e.g., UV Only stays UV Only)

**Pass Criteria:**

Lights auto-toggle on the configured schedule. Restore 12-hour value after test.

---

## Test 9 -- Power Cycle Persistence

Verifies that the LED mode persists across reboots via ESP32 Preferences (NVS).

**Steps:**

1. Set a specific light mode (e.g., short press to Blue Only / mode 3)
2. Verify Serial shows `[Main] Mode cycled to: 3`
3. Disconnect USB power (unplug cable)
4. Wait 3 seconds
5. Reconnect USB power
6. Observe boot sequence and restored mode

**Expected Results:**

- After reboot, Serial shows `[Init] LED controller... OK (mode 3)`
- Blue LED is on, UV-A LED is off (matching Blue Only mode)
- No need to re-set mode after power loss

**Pass Criteria:**

Mode persists across power cycles. ESP32 boots into the previously selected mode.

---

## Test Summary

| # | Test | Status | Notes |
|---|------|--------|-------|
| 1 | Boot & Initialization | [ ] | |
| 2 | Sensor Readings | [ ] | |
| 3 | Button & LED Modes | [ ] | |
| 4 | UV-C Safety (CRITICAL) | [ ] | |
| 5 | Fan Control | [ ] | |
| 6 | Humidifier Control | [ ] | |
| 7 | Web Dashboard | [ ] | |
| 8 | 12-Hour Light Cycle | [ ] | |
| 9 | Power Cycle Persistence | [ ] | |

**Date tested:** _______________

**Tester:** _______________

**Firmware version:** _______________

**All tests passed:** [ ] Yes / [ ] No

---

*Part of the Void Blueprints firmware package.*
*See [WIRING.md](WIRING.md) for circuit wiring reference.*
*See [UV-C-SAFETY-TEST.md](UV-C-SAFETY-TEST.md) for detailed UV-C safety validation.*
