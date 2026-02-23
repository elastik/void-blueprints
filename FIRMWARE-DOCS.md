# The Void -- Firmware & Electronics Documentation

> Electronics behavior and programming documentation for all three Void dome variants.
> This document explains how the Void's electronics work, for builders who want to understand, modify, or program their dome.
> For component sourcing, see PARTS-GUIDE.md. For physical assembly, see BUILD-GUIDE.md.

---

## 1. Overview

### Purpose

This document covers the electronic behavior of every Void variant -- from the completely passive Dark Dome to the fully programmable Void Core. Whether you are building a base Void with hardware-only logic or developing software for the Void Core, this is your reference.

### Three Variant Electronics Profiles

| Variant | Electronics | Controller | Complexity |
|---|---|---|---|
| **Dark Dome** | None | None | Zero -- skip to CONTRIBUTING.md for mechanical modifications |
| **The Void** (base) | Discrete components + optional ATtiny85 | Hardware logic (555 timers) or ATtiny85 | Low -- mostly hardware, minimal or no firmware |
| **Void Core** | Full smart electronics | Raspberry Pi Zero W 2 | High -- Python control daemon, sensors, Wi-Fi, app |

### How This Document is Organized

- **Section 2** covers the base Void's hardware-only logic -- no microcontroller required
- **Section 3** covers the optional ATtiny85 microcontroller upgrade for the base Void
- **Section 4** covers the Void Core's Raspberry Pi Zero W 2 software architecture
- **Section 5** confirms the Dark Dome has zero electronics

If you are building a base Void, read Sections 2 and (optionally) 3. If you are contributing to Void Core development, read Section 4. If you are building a Dark Dome, Section 5 is all you need.

---

## 2. Base Void -- Hardware Logic

The base Void uses no microcontroller. All behavior is implemented with discrete components and hardware timing circuits. This means fewer failure modes, lower cost, and zero firmware to maintain.

### 2.1 Circuit Description

Every component in the base Void serves a specific purpose. Here is what each one does and why it is there.

**USB-C PD Sink IC (CH224K)**
Negotiates 5V power from any USB-C source. This tiny IC (SOT-23 package) ensures the Void receives a stable 5V supply from any standard USB charger. It handles the USB-C Power Delivery handshake so you do not need a specific charger -- any phone charger rated 5V/1A or higher works.

**LED Driver (PT4115)**
Constant-current driver that powers the UV-A and Blue LED strings. The PT4115 delivers a fixed 20mA per LED regardless of voltage fluctuations, protecting the LEDs from overcurrent damage and ensuring consistent brightness. It drives two strings of 6 LEDs each (UV-A string and Blue string).

**555 Timer #1 -- 12-Hour Light Cycle**
Configured in astable mode, this timer alternates the lights on a 12-hour on / 12-hour off cycle. This matches the natural fruiting light schedule required by all target mushroom species. The timer enables and disables the LED driver IC, so both UV-A and Blue LEDs follow the same cycle.

**555 Timer #2 -- 15-Minute UV-C Auto-Shutoff**
Configured in monostable mode, this timer limits every UV-C sterilization cycle to exactly 15 minutes. When triggered, it outputs a single 15-minute pulse that powers the UV-C LED. After 15 minutes, it automatically shuts off -- regardless of button state, reed switch state, or anything else. This is a hardware safety guarantee.

**Reed Switch -- Dome Presence Detection**
A normally-open glass reed switch positioned in the base near the dome seating rim. When the dome's embedded neodymium magnet is within 5mm, the reed switch closes and completes the UV-C power circuit. When the dome is removed, the switch opens and UV-C power is physically cut. This is the UV-C safety interlock.

**Mode Button**
A 12mm waterproof tactile switch on the base exterior. Tap to cycle through the four light modes. Press and hold for 3 seconds to trigger a UV-C sterilization cycle. The 3-second hold is detected by an RC delay circuit that prevents accidental UV-C activation from brief taps.

### 2.2 Wiring Architecture

```
USB-C port
    |
    v
[USB-C PD Sink IC (CH224K)] --> 5V rail
    |
    +---> [LED Driver (PT4115)] ---> UV-A LED string (6x series, 395nm)
    |         |
    |         +--------------------> Blue LED string (6x series, 450nm)
    |
    +---> [555 Timer #1] ---> 12h cycle control (enables/disables LED driver)
    |
    +---> [Button] ---> [Mode logic] ---> LED driver enable/channel select
    |                        |
    |                        +---> [3-sec hold detect (RC)] ---> UV-C trigger
    |
    +---> [Reed switch] ---> [555 Timer #2] ---> UV-C LED (275nm)
    |                                             (interlock IN SERIES)
    |
    +---> [Red indicator LED] (wired in parallel with UV-C power)
```

**Key wiring rules:**
- The reed switch is wired **in series** with the UV-C LED power line. UV-C physically cannot receive power without the dome magnet closing the reed switch.
- The red indicator LED is wired in parallel with the UV-C power line. It lights whenever UV-C is active, warning users not to remove the dome.
- Both 555 timers and the LED driver operate from the single 5V rail supplied through USB-C.
- All components fit on a single 2-layer PCB, 50mm x 30mm.

### 2.3 Light Modes

The base Void has five operating modes, cycled with the physical button.

| Mode | UV-A (395nm) | Blue (450nm) | UV-C (275nm) | Trigger |
|---|---|---|---|---|
| 1. Void Glow | ON | ON | OFF | Button tap (default at power-on) |
| 2. UV Only | ON | OFF | OFF | Button tap |
| 3. Blue Only | OFF | ON | OFF | Button tap |
| 4. Off | OFF | OFF | OFF | Button tap |
| 5. Sterilize | OFF | OFF | ON (15 min) | Button hold 3 seconds (dome must be seated) |

**Mode cycling behavior:**
- Tap the button to advance: 1 -> 2 -> 3 -> 4 -> 1 (loops back)
- The 12-hour timer applies to modes 1-3: lights auto-off after 12 hours, auto-on after 12 hours of darkness
- Mode 4 (Off) overrides the timer -- lights stay off until the user taps again
- Mode 5 (Sterilize) is independent of the light cycle timer; it runs for exactly 15 minutes and then stops
- UV-A/Blue and UV-C are never on simultaneously. UV-C only runs between grows with the dome sealed and grow lights off.

### 2.4 555 Timer Configurations

#### 12-Hour Timer (Astable Mode)

The first NE555 timer generates a 12-hour on / 12-hour off square wave that controls the LED driver.

**Astable mode formula:**

```
T_high = 0.693 x (R1 + R2) x C
T_low  = 0.693 x R2 x C
Total period = T_high + T_low
```

For a 24-hour period (12h on, 12h off):
- Target: T_high = T_low = 43,200 seconds (12 hours)
- Using a large electrolytic capacitor (e.g., 1000uF) and high-value resistors:
  - R1 = 1k ohm (small compared to R2 to get ~50% duty cycle)
  - R2 = 62.4M ohm (achieved with series resistor network)
  - C = 1000uF

**Practical note:** Achieving a precise 12-hour period with a 555 timer and passive components is challenging due to component tolerances. Real-world electrolytic capacitors have +/-20% tolerance, and mega-ohm resistors drift with temperature. Builders should expect the cycle to vary between 10-14 hours and may need to adjust R2 to fine-tune the period. Using a CMOS variant (LMC555) reduces current draw and improves timing stability.

**Alternative approach:** If precise 12-hour timing is important, use the ATtiny85 option (Section 3), which implements timing in software with crystal-accurate precision.

#### 15-Minute UV-C Timer (Monostable Mode)

The second NE555 timer generates a single 15-minute pulse when triggered.

**Monostable mode formula:**

```
T_pulse = 1.1 x R x C
```

For a 15-minute (900-second) pulse:
- R = 8.2M ohm
- C = 100uF
- T_pulse = 1.1 x 8,200,000 x 0.0001 = 902 seconds (~15 minutes)

**Trigger mechanism:** When the user holds the mode button for 3 seconds, an RC delay circuit (separate from the timer) pulls the 555 trigger pin (pin 2) low, starting the monostable pulse. A brief tap does not charge the RC circuit enough to reach the trigger threshold, preventing accidental activation.

**Auto-shutoff guarantee:** After the pulse duration, the 555 output goes low and UV-C power is cut. The timer must be re-triggered (another 3-second hold) to start a new cycle. There is no way for UV-C to run continuously -- the hardware enforces the time limit.

### 2.5 UV-C Safety Interlock -- CRITICAL

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

**How the interlock works:**

The reed switch is wired **in series** with the UV-C LED power line. This is not a software check -- it is a physical circuit break. The UV-C LED's power path is:

```
5V rail --> [555 Timer #2 output] --> [Reed switch] --> [UV-C LED] --> GND
```

If the reed switch is open (dome removed), the circuit is broken and no current can flow to the UV-C LED. Period. This works even if:
- The 555 timer is stuck in the "on" state
- The button is held down permanently
- There is no microcontroller (base Void has none)
- Any other component has failed

**The dome magnet must be within 5mm of the reed switch for it to close.** The 6mm x 2mm neodymium disc magnet is embedded in the dome's seating lip, and the reed switch is positioned in the base rim directly below it.

**Safety features summary:**

| Feature | Type | How It Works |
|---|---|---|
| Reed switch in series with UV-C power | Hardware interlock | Dome removal physically cuts UV-C power |
| 555 timer auto-shutoff (15 min) | Hardware timer | UV-C cannot run longer than 15 minutes |
| 3-second button hold required | RC delay circuit | Prevents accidental activation from button taps |
| Red indicator LED | Visual warning | Lights during entire UV-C cycle |
| Polycarbonate/PETG dome | Radiation enclosure | Dome material blocks 100% of UV-C below 300nm |
| Warning label on base | Physical warning | "CAUTION: UV-C germicidal light" |

**Interlock test procedure (mandatory before first use):**

1. Seat the dome on the base and connect USB power
2. Press and hold the mode button for 3 seconds -- the red LED should light
3. While the red LED is on, carefully lift the dome off the base
4. The red LED should immediately turn off (UV-C power cut)
5. Replace the dome -- UV-C should NOT restart (requires new 3-second hold)

**If the interlock fails** (red LED stays on with dome removed): disconnect power immediately. Check reed switch position, wiring, and magnet placement. See BUILD-GUIDE.md troubleshooting section.

### 2.6 Power Budget

All components operate from a single 5V USB rail.

| Component | Voltage | Current (typ) | Current (max) | Power (typ) | Power (max) |
|---|---|---|---|---|---|
| UV-A LEDs (6x 395nm) | 3.2V via 5V | 120mA | 150mA | 0.40W | 0.50W |
| Blue LEDs (6x 450nm) | 3.0V via 5V | 120mA | 150mA | 0.36W | 0.45W |
| LED driver IC (PT4115) | 5V | 10mA | 15mA | 0.05W | 0.08W |
| 555 timer ICs (x2) | 5V | 2mA | 4mA | 0.01W | 0.02W |
| UV-C LED (when active) | 6.5V via 5V boost | 250mA | 350mA | 1.25W | 1.75W |
| Red indicator LED | 5V | 10mA | 15mA | 0.05W | 0.08W |
| USB-C PD sink IC | 5V | 1mA | 2mA | 0.01W | 0.01W |
| Button + reed switch | -- | negligible | negligible | -- | -- |
| **TOTAL (normal grow, lights on)** | | **~253mA** | **~321mA** | **~0.83W** | **~1.05W** |
| **TOTAL (UV-C sterilize)** | | **~263mA** | **~371mA** | **~1.32W** | **~1.85W** |

**Key takeaways:**
- Normal growing mode draws under 1.1W -- well within any USB charger's capability
- Even during UV-C sterilization, total draw is under 2W
- The base Void stays comfortably under the USB 2.0 500mA / 2.5W limit
- UV-A/Blue and UV-C are never on simultaneously, so the real peak is UV-C + red indicator (~1.3W)

### 2.7 Power States

| State | Components Active | Power Draw | Duration |
|---|---|---|---|
| **Off** | None (USB disconnected or mode 4) | 0W | -- |
| **Standby** | 555 timer only (during 12h dark period) | <0.01W | 12 hours |
| **Growing (lights on)** | UV-A + Blue LEDs + LED driver + timer | ~0.8-1.1W | 12 hours |
| **Sterilizing** | UV-C LED + red indicator + timer | ~1.3W | 15 minutes |

---

## 3. Base Void -- ATtiny85 Firmware (Optional)

The ATtiny85 is an optional upgrade that replaces the discrete timing and mode logic with a single 8-pin microcontroller. It is not required for a functional Void, but it adds useful features.

### 3.1 When to Use the ATtiny85

**The ATtiny85 adds:**
- **Mode memory** -- remembers the last selected light mode after power cycle (stored in EEPROM)
- **Simpler button-hold detection** -- replaces the discrete RC delay circuit with firmware debouncing
- **Software timing** -- replaces both 555 timers with more accurate software timers
- **Reduced component count** -- eliminates 2x NE555 ICs and their associated passive components

**Cost:** $0.50-1.00 additional (ATtiny85 IC)

**Trade-off:** The ATtiny85 introduces a software dependency. The 555-based design is purely hardware and has zero firmware to fail. Choose based on whether mode memory and simplified wiring are worth the added complexity.

**Total firmware size:** ~500 bytes (fits easily in the ATtiny85's 8KB flash)

### 3.2 ATtiny85 Pin Assignments

The ATtiny85 has 6 I/O pins (PB0-PB5, where PB5 is shared with RESET).

| Pin | ATtiny85 Pin | Function | Direction | Notes |
|---|---|---|---|---|
| 1 | PB5 / RESET | Reset (not used as I/O) | -- | Leave as reset; needed for ISP programming |
| 2 | PB3 | Button input | Input (pull-up) | 12mm tactile switch; internal pull-up enabled |
| 3 | PB4 | Reed switch input | Input (pull-up) | Normally-open; reads HIGH when dome is removed |
| 4 | GND | Ground | -- | -- |
| 5 | PB0 | UV-A LED string enable | Output | HIGH = UV-A LEDs on via LED driver |
| 6 | PB1 | Blue LED string enable | Output | HIGH = Blue LEDs on via LED driver |
| 7 | PB2 | UV-C trigger | Output | HIGH = UV-C LED on (still gated by reed switch in hardware) |
| 8 | VCC | 5V power | -- | -- |

**Note on PB5/RESET:** PB5 is not used as a general I/O pin because repurposing it as I/O disables ISP programming. The red indicator LED is wired in parallel with the UV-C power line (hardware), not controlled by the ATtiny85.

**Critical safety note:** Even with the ATtiny85, the reed switch remains wired **in series** with the UV-C LED power line. The ATtiny85 checks the reed switch state in software as an additional safety layer, but the hardware interlock is the primary safety mechanism. If the firmware crashes or hangs, the hardware interlock still prevents UV-C from activating without the dome.

### 3.3 Firmware Behavior (Pseudocode)

The following pseudocode describes the complete ATtiny85 firmware. This is a specification, not implementation -- actual C code will be released separately.

```
CONSTANTS:
    LIGHT_CYCLE_MS     = 43,200,000    // 12 hours in milliseconds
    UVC_TIMEOUT_MS     = 900,000       // 15 minutes in milliseconds
    BUTTON_HOLD_MS     = 3,000         // 3-second hold threshold
    DEBOUNCE_MS        = 50            // Button debounce time
    EEPROM_MODE_ADDR   = 0             // EEPROM address for stored mode

VARIABLES:
    current_mode       = 1             // 1=Void Glow, 2=UV Only, 3=Blue Only, 4=Off
    uvc_active         = false
    uvc_start_time     = 0
    cycle_timer        = 0
    lights_on          = true          // Current phase of 12h cycle

// ===== STARTUP =====
FUNCTION setup():
    configure PB0 (UV-A) as OUTPUT, set LOW
    configure PB1 (Blue) as OUTPUT, set LOW
    configure PB2 (UV-C trigger) as OUTPUT, set LOW
    configure PB3 (Button) as INPUT with internal PULL-UP
    configure PB4 (Reed switch) as INPUT with internal PULL-UP

    // Read last mode from EEPROM
    stored_mode = EEPROM.read(EEPROM_MODE_ADDR)
    IF stored_mode >= 1 AND stored_mode <= 4:
        current_mode = stored_mode
    ELSE:
        current_mode = 1    // Default to Void Glow

    apply_mode(current_mode)
    cycle_timer = millis()

// ===== MAIN LOOP =====
FUNCTION loop():
    // --- Handle 12-hour light cycle ---
    IF millis() - cycle_timer >= LIGHT_CYCLE_MS:
        lights_on = NOT lights_on
        cycle_timer = millis()
        IF lights_on:
            apply_mode(current_mode)
        ELSE:
            set PB0 LOW    // UV-A off
            set PB1 LOW    // Blue off

    // --- Handle UV-C auto-shutoff ---
    IF uvc_active:
        IF millis() - uvc_start_time >= UVC_TIMEOUT_MS:
            set PB2 LOW        // UV-C trigger off
            uvc_active = false

        // Additional software safety: check reed switch
        IF PB4 reads HIGH:    // Dome removed
            set PB2 LOW        // UV-C trigger off
            uvc_active = false

    // --- Handle button input ---
    IF button_pressed():        // Debounced read of PB3
        hold_time = measure_hold_duration()

        IF hold_time >= BUTTON_HOLD_MS:
            // Long press: start UV-C cycle
            start_uvc_cycle()
        ELSE:
            // Short press: cycle light mode
            current_mode = current_mode + 1
            IF current_mode > 4:
                current_mode = 1
            EEPROM.write(EEPROM_MODE_ADDR, current_mode)
            apply_mode(current_mode)

// ===== APPLY LIGHT MODE =====
FUNCTION apply_mode(mode):
    IF NOT lights_on AND mode != 4:
        RETURN    // In dark phase of 12h cycle; don't turn on lights

    SWITCH mode:
        CASE 1 (Void Glow):
            set PB0 HIGH    // UV-A on
            set PB1 HIGH    // Blue on
        CASE 2 (UV Only):
            set PB0 HIGH    // UV-A on
            set PB1 LOW     // Blue off
        CASE 3 (Blue Only):
            set PB0 LOW     // UV-A off
            set PB1 HIGH    // Blue on
        CASE 4 (Off):
            set PB0 LOW     // UV-A off
            set PB1 LOW     // Blue off

// ===== START UV-C CYCLE =====
FUNCTION start_uvc_cycle():
    // Check reed switch (software safety -- hardware interlock is primary)
    IF PB4 reads HIGH:        // Dome not detected
        RETURN                // Refuse to start UV-C

    // Turn off grow lights during sterilization
    set PB0 LOW
    set PB1 LOW

    // Start UV-C
    set PB2 HIGH              // UV-C trigger on
    uvc_active = true
    uvc_start_time = millis()
```

### 3.4 Programming the ATtiny85

**Required hardware:**
- USBasp programmer ($3-5 from AliExpress) **or** an Arduino Uno used as ISP programmer ("Arduino as ISP")
- 6 jumper wires for ISP connection
- Breadboard (optional but helpful)

**Fuse settings:**
- CKSEL: 8MHz internal oscillator (no external crystal needed)
- SUT: 65ms startup delay
- CKDIV8: disabled (run at full 8MHz, not divided to 1MHz)
- BOD: 2.7V brownout detection enabled (prevents corruption during power fluctuation)

**Fuse byte values:** Low: 0xE2, High: 0xDF, Extended: 0xFF

**Recommended development environment:**
- Arduino IDE with the "ATtiny" board package by David A. Mellis (or SpenceKonde's ATTinyCore)
- Board: "ATtiny85"
- Clock: "Internal 8 MHz"
- Programmer: "USBasp" or "Arduino as ISP"

**Flash procedure:**
1. Connect ISP programmer to ATtiny85: VCC, GND, MOSI (PB0/pin 5), MISO (PB1/pin 6), SCK (PB2/pin 7), RESET (PB5/pin 1)
2. In Arduino IDE, select Tools > Board > ATtiny85, Clock > Internal 8 MHz
3. Select Tools > Programmer > USBasp (or Arduino as ISP)
4. Click Tools > Burn Bootloader (sets fuse bits -- do this once)
5. Open the firmware sketch and click Upload

**Note:** The ATtiny85 firmware is not included in Void Blueprints v1.0. The pseudocode above is the specification. Community contributors are welcome to implement it -- see CONTRIBUTING.md for how to contribute firmware.

---

## 4. Void Core -- Pi Zero W 2 Software

The Void Core adds a Raspberry Pi Zero W 2 running a Python control daemon. This transforms the Void from a passive hardware device into a fully programmable smart cultivation dome with sensors, active environmental control, timelapse photography, and app connectivity.

**Important:** The Void Core software is NOT included in Void Blueprints v1.0. This section documents the architecture for contributors who want to help build it. The base Void (hardware-only) is the primary open-source release.

### 4.1 Hardware Setup

**Pi Zero W 2 connections:**

| Interface | Connected To | Protocol | Notes |
|---|---|---|---|
| I2C (SDA/SCL) | BME280 sensor | I2C (400kHz) | Temperature + humidity + pressure |
| I2C (SDA/SCL) | SCD40 CO2 sensor | I2C (100kHz) | Optional; shares I2C bus with BME280 |
| GPIO | UV-A LED string enable | Digital output | Same LED ring as base Void |
| GPIO | Blue LED string enable | Digital output | Same LED ring as base Void |
| GPIO | UV-C trigger | Digital output | Still gated by hardware reed switch interlock |
| GPIO | Fan speed control | PWM output | 30mm axial fan, 5V DC |
| GPIO | Humidifier on/off | Digital output | Piezo disc, 20mm, 113 KHz |
| GPIO | Motorized damper #1 | PWM/servo | Intake vent aperture control |
| GPIO | Motorized damper #2 | PWM/servo | Exhaust vent aperture control |
| GPIO | WS2812B data | Single-wire NZR | 8 addressable RGB LEDs |
| CSI | Camera module | Ribbon cable | 5MP or 8MP Pi-compatible module |
| Wi-Fi | Void app | 2.4 GHz | Local network communication |
| BLE | Initial setup | Bluetooth LE | WiFi provisioning |

**Pin mapping (BCM numbering):**

| BCM Pin | Function | Direction |
|---|---|---|
| GPIO 2 (SDA) | I2C data (BME280, SCD40) | Bidirectional |
| GPIO 3 (SCL) | I2C clock (BME280, SCD40) | Output |
| GPIO 4 | UV-A LED string enable | Output |
| GPIO 5 | Blue LED string enable | Output |
| GPIO 6 | UV-C trigger | Output |
| GPIO 12 | Fan PWM | Output (hardware PWM) |
| GPIO 13 | Humidifier enable | Output |
| GPIO 16 | Damper #1 servo PWM | Output |
| GPIO 17 | Damper #2 servo PWM | Output |
| GPIO 18 | WS2812B data | Output |
| GPIO 22 | Reed switch input | Input (pull-up) |
| GPIO 27 | Button input | Input (pull-up) |
| CSI port | Camera module | -- |

**Power requirements:**
- Void Core requires USB-C PD at 5V/3A (15W)
- The Pi Zero W 2 alone draws 300-500mA at 5V
- Total Void Core typical power: ~5.5W; peak (all systems active): ~10W
- Standard USB 2.0 (500mA/2.5W) is NOT sufficient for Void Core

### 4.2 Software Architecture

**Operating system:** Raspberry Pi OS Lite (headless, no desktop environment)

**Control daemon:** A Python application running as a systemd service. It starts automatically on boot and manages all Void Core hardware.

**Module structure:**

```
void-core/
    |-- voidcore.py              # Main daemon entry point
    |-- sensor_reader.py         # BME280 / SCD40 polling
    |-- climate_controller.py    # PID loop for humidity and CO2
    |-- light_controller.py      # LED modes, 12h cycle, UV-C control
    |-- camera_controller.py     # Timelapse capture
    |-- web_server.py            # Flask/FastAPI local API for Void app
    |-- wifi_setup.py            # BLE-based WiFi configuration
    |-- config.py                # User-configurable settings
    |-- requirements.txt         # Python dependencies
```

**Module descriptions:**

| Module | Responsibility | Poll Interval |
|---|---|---|
| `sensor_reader.py` | Reads BME280 (temp, humidity, pressure) and SCD40 (CO2) via I2C | Every 30 seconds |
| `climate_controller.py` | PID control loop -- adjusts fan speed, humidifier duty cycle, and damper position based on sensor readings | Every 30 seconds (tied to sensor reads) |
| `light_controller.py` | Manages all LED modes (base modes + Void Core modes like Deep Space, Aurora, Music Sync), 12-hour cycle timer, and UV-C sterilization control | Event-driven + 12h timer |
| `camera_controller.py` | Captures timelapse images at configurable intervals and stores them on the microSD card | Configurable (default: every 15 minutes) |
| `web_server.py` | Exposes a local REST API for the Void app to read sensor data, change modes, and adjust settings | Always running (HTTP server) |
| `wifi_setup.py` | Handles initial WiFi provisioning via BLE -- the user configures WiFi credentials from their phone without needing a keyboard or monitor | Runs on first boot or when WiFi is unconfigured |

### 4.3 Control Logic

#### Humidity PID Controller

| Parameter | Value | Notes |
|---|---|---|
| Setpoint | 88% RH | Default; user-adjustable via app (80-95% range) |
| Deadband | +/- 2% RH | No action taken within 86-90% RH |
| Sensor | BME280 | +/- 3% RH accuracy |
| Actuator | Piezo humidifier disc (20mm, 113 KHz) | PWM duty cycle proportional to humidity deficit |
| Secondary actuator | 30mm fan (brief speed increase) | Used to vent excess humidity if RH > setpoint + 2% |

**Control behavior:**
1. Read humidity from BME280 every 30 seconds
2. If RH < (setpoint - 2%): activate humidifier at duty cycle proportional to deficit
3. If RH > (setpoint + 2%): pause humidifier; briefly increase fan speed to vent excess
4. If RH is within deadband: no action (steady state)

#### CO2 Management

| CO2 Level | Action |
|---|---|
| < 600 ppm | Normal -- fan at baseline speed |
| 600-1000 ppm | Fan speed increases proportionally |
| > 1000 ppm | Alarm -- maximum fan speed, app notification |
| > 2000 ppm (Reishi antler mode) | Intentional -- close dampers to accumulate CO2 for antler growth |

**Reishi antler mode:** When enabled via the app, the climate controller closes the motorized dampers to restrict airflow, allowing CO2 to accumulate above 2000 ppm. This triggers reishi to produce antler formations instead of conks. The fan runs at minimum speed for air circulation only, not exchange.

#### Void Core Light Modes

In addition to the four base modes (Void Glow, UV Only, Blue Only, Off), Void Core adds:

| Mode | Description | LEDs Used |
|---|---|---|
| Deep Space | Slow UV-A pulse with deep blue undertone | UV-A + Blue (PWM dimming) |
| Bioluminescence | Minimal light for Panellus viewing | Blue at 5% duty cycle |
| Aurora | Slow color sweep across UV-A intensity levels | UV-A (PWM sweep) |
| Blacklight | Maximum UV-A intensity | UV-A at 100% |
| Music Sync | Beat-reactive UV-A + Blue flashing | UV-A + Blue (microphone input) |
| Custom | User-defined intensity and timing per channel | All channels, app-configured |

The WS2812B RGB ring (8 LEDs) provides additional color accent capabilities for Deep Space, Aurora, and Music Sync modes.

### 4.4 API Endpoints (for Void App)

The Void Core exposes a local REST API via Flask or FastAPI, accessible over WiFi.

| Method | Endpoint | Description | Request Body | Response |
|---|---|---|---|---|
| GET | `/status` | Current sensor readings, mode, uptime | -- | `{ temp, humidity, co2, mode, uptime, uvc_active }` |
| POST | `/mode` | Set light mode | `{ mode: "void_glow" }` | `{ success: true, mode: "void_glow" }` |
| POST | `/settings` | Update control setpoints | `{ humidity_setpoint, co2_target, light_schedule }` | `{ success: true, settings: {...} }` |
| GET | `/timelapse` | List captured timelapse images | -- | `{ images: [{ filename, timestamp, size }] }` |
| POST | `/sterilize` | Trigger UV-C sterilization cycle | `{ confirm: true }` | `{ success: true, duration_minutes: 15 }` |
| GET | `/config` | Read current configuration | -- | `{ all current settings }` |
| POST | `/wifi` | Update WiFi credentials | `{ ssid, password }` | `{ success: true }` |

**Safety note on `/sterilize`:** The API requires `confirm: true` in the request body as an additional confirmation step. This is a software safety layer on top of the hardware reed switch interlock. The hardware interlock is the primary safety mechanism -- even if the API is called maliciously, UV-C cannot activate without the dome in place.

### 4.5 Void Core Power Budget

| Component | Voltage | Current (typ) | Power (typ) |
|---|---|---|---|
| Base Void components | 5V | 253mA | 0.83W |
| Raspberry Pi Zero W 2 | 5V | 300mA | 1.50W |
| BME280 sensor | 3.3V | 1mA | 0.003W |
| SCD40 CO2 sensor (optional) | 3.3V | 15mA | 0.05W |
| Piezo humidifier | 5V | 300mA | 1.50W |
| 30mm fan | 5V | 80mA | 0.40W |
| WS2812B RGB ring (8x) | 5V | 160mA | 0.80W |
| Camera module | 3.3V | 50mA | 0.17W |
| Motorized dampers (x2) | 5V | 50mA | 0.25W |
| **TOTAL (typical)** | | **~1,209mA** | **~5.5W** |
| **TOTAL (all active, peak)** | | **~2,123mA** | **~10W** |

### 4.6 Void Core Power States

| State | Components Active | Power Draw | Duration |
|---|---|---|---|
| **Void Core idle** | Pi Zero + sensors (lights in dark period) | ~1.6W | 12 hours |
| **Void Core growing** | Pi + sensors + LEDs + fan + occasional mist | ~5.5W | 12 hours |
| **Void Core peak** | All systems active simultaneously | ~10W | Brief bursts |
| **Void Core sterilizing** | Pi + UV-C + red indicator | ~3.0W | 15-30 minutes |

---

## 5. Dark Dome -- No Electronics

The Dark Dome is the simplest variant. It has **zero electronics**.

### What the Dark Dome Is

- The same physical shell as The Void (8.0" diameter x 10.0" tall)
- Same dome, same base, same substrate platform, same airflow vents
- No PCB, no LEDs, no USB port, no button, no reed switch, no magnet
- No wiring of any kind
- Purely passive cultivation chamber

### What the Dark Dome Is For

The Dark Dome is designed for:
- **Bioluminescent species** (Panellus stipticus) -- any artificial light competes with the natural glow, so the dome provides total darkness
- **Budget builds** -- skip all electronics and just print the enclosure (~$11.50 in filament)
- **Growers who already have lighting** -- use your own LED setup externally

### Electronics Cost

Zero. The Dark Dome costs only the filament to print. Total estimated material cost: ~$11.50 (PETG, ~380g).

### What to Build Instead

If you are building a Dark Dome, skip Sections 2, 3, and 4 of this document entirely. Your build process is:

1. Print the dome, base, platform, and vent caps (see BUILD-GUIDE.md)
2. Install the silicone gasket in the base rim
3. Apply micropore tape to all vents
4. Skip the magnet -- there is no reed switch to trigger
5. Place a substrate block and grow

For community modifications and remix ideas, see CONTRIBUTING.md.

---

*Firmware Documentation version: 1.0*
*Part of the Void Blueprints open-source package.*
