# The Void -- ESP32 Prototype Wiring Guide

> Circuit wiring reference for the Void Core ESP32 DevKit V1 prototype.
> For production Void Core (Pi Zero W 2), see FIRMWARE-DOCS.md Section 4.
> For base Void hardware-only circuit, see FIRMWARE-DOCS.md Section 2.

---

## Pin Assignments

ESP32 DevKit V1 (38-pin) GPIO mapping for all Void Core prototype peripherals.

| GPIO | Function | Direction | Signal | Notes |
|------|----------|-----------|--------|-------|
| 21 | BME280 I2C data (SDA) | Bidirectional | I2C SDA | 3.3V logic, external pull-up on breakout |
| 22 | BME280 I2C clock (SCL) | Output | I2C SCL | 3.3V logic, external pull-up on breakout |
| 25 | UV-A LED string enable | Output | Active HIGH | Drives N-channel MOSFET gate |
| 26 | Blue LED string enable | Output | Active HIGH | Drives N-channel MOSFET gate |
| 27 | UV-C trigger | Output | Active HIGH | Gated by reed switch in series on drain side |
| 14 | Fan PWM | Output | Hardware PWM (LEDC) | 25 kHz, 8-bit resolution |
| 13 | Humidifier enable | Output | Active HIGH | Drives N-channel MOSFET gate |
| 16 | Reed switch input | Input | Internal pull-up | LOW = dome seated (magnet closes reed switch) |
| 17 | Button input | Input | Internal pull-up | LOW = pressed |
| 2 | Red indicator LED | Output | Active HIGH | Built-in LED on most DevKits; UV-C warning |

---

## ASCII Wiring Diagram

```
                        +---------------------+
                        |   ESP32 DevKit V1   |
                        |                     |
                 3V3 ---|  3V3           GND  |--- GND bus
                        |                     |
    BME280 SDA  <------>| GPIO 21 (SDA)       |
    BME280 SCL  <-------| GPIO 22 (SCL)       |
                        |                     |
    UV-A MOSFET (220R)<-| GPIO 25             |
    Blue MOSFET (220R)<-| GPIO 26             |
    UV-C MOSFET (220R)<-| GPIO 27             |
                        |                     |
    Fan MOSFET (220R) <-| GPIO 14             |
    Hum. MOSFET (220R)<-| GPIO 13             |
                        |                     |
    Reed switch in ---->| GPIO 16             |
    Button in --------->| GPIO 17             |
                        |                     |
    Red LED (220R) <----| GPIO 2              |
                        |                     |
                    USB | 5V (USB)            |
                        +---------------------+


    === BME280 Breakout ===

    ESP32 3V3 -------> BME280 VIN
    ESP32 GND -------> BME280 GND
    ESP32 GPIO 21 ---> BME280 SDA  (I2C data, pull-ups on breakout)
    ESP32 GPIO 22 ---> BME280 SCL  (I2C clock, pull-ups on breakout)


    === UV-A LED String (6x 395nm, series via PT4115 driver) ===

    5V rail ---> [PT4115 LED driver] ---> UV-A LED+ (anode)
    UV-A LED- (cathode) ---> MOSFET drain (Q1)
    MOSFET source (Q1) ---> GND
    ESP32 GPIO 25 ---> 220R ---> MOSFET gate (Q1)

                  +5V
                   |
            [PT4115 driver]
                   |
          UV-A LED string (6x series)
                   |
             Drain |
        Q1 [IRLZ44N] MOSFET
             Source|
                   |
                  GND
        Gate <--- 220R <--- GPIO 25


    === Blue LED String (6x 450nm, series via PT4115 driver) ===

    5V rail ---> [PT4115 LED driver] ---> Blue LED+ (anode)
    Blue LED- (cathode) ---> MOSFET drain (Q2)
    MOSFET source (Q2) ---> GND
    ESP32 GPIO 26 ---> 220R ---> MOSFET gate (Q2)

    (Same topology as UV-A string above, GPIO 26 to Q2 gate)


    === UV-C LED (275nm) with Reed Switch Interlock ===

    NOTE: Most 275nm UV-C LEDs have Vf of 5.5-6.5V, which exceeds the
    5V rail. If your UV-C LED Vf > 5V, replace the current-limiting
    resistor with a 5V-to-9V boost converter module (MT3608 or similar).
    The base Void production design uses a boost stage for this reason
    (see FIRMWARE-DOCS.md Section 2.6). For prototype testing with a
    low-Vf UV-C LED (Vf < 4.5V), the resistor circuit below works.

    5V rail ---> UV-C LED+ (with current-limiting resistor or boost converter)
    UV-C LED- ---> Reed switch terminal A
    Reed switch terminal B ---> MOSFET drain (Q3)
    MOSFET source (Q3) ---> GND
    ESP32 GPIO 27 ---> 220R ---> MOSFET gate (Q3)

                  +5V
                   |
         [Resistor or Boost]
                   |
              UV-C LED (275nm)
                   |
             [Reed Switch]     <-- HARDWARE INTERLOCK
                   |               (open = dome removed = UV-C OFF)
             Drain |
        Q3 [IRLZ44N] MOSFET
             Source|
                   |
                  GND
        Gate <--- 220R <--- GPIO 27


    === 30mm 5V Fan (PWM speed control) ===

    5V rail ---> Fan+ (red wire)
    Fan- (black wire) ---> MOSFET drain (Q4)
    MOSFET source (Q4) ---> GND
    ESP32 GPIO 14 ---> 220R ---> MOSFET gate (Q4)

                  +5V
                   |
              Fan (30mm)
                   |
             Drain |
        Q4 [IRLZ44N] MOSFET
             Source|
                   |
                  GND
        Gate <--- 220R <--- GPIO 14


    === Piezo Humidifier Disc ===

    5V rail ---> Humidifier+ (red wire)
    Humidifier- (black wire) ---> MOSFET drain (Q5)
    MOSFET source (Q5) ---> GND
    ESP32 GPIO 13 ---> 220R ---> MOSFET gate (Q5)

    (Same topology as fan above, GPIO 13 to Q5 gate)


    === Reed Switch (Dome Presence) ===

    ESP32 GPIO 16 ---> Reed switch terminal A
    Reed switch terminal B ---> GND

    (Uses ESP32 internal pull-up; LOW when dome magnet closes switch)


    === 12mm Tactile Button ===

    ESP32 GPIO 17 ---> Button terminal A
    Button terminal B ---> GND

    (Uses ESP32 internal pull-up; LOW when pressed)


    === Red Indicator LED (UV-C Warning) ===

    ESP32 GPIO 2 ---> 220 ohm resistor ---> Red LED anode
    Red LED cathode ---> GND
```

---

## Power Notes

- **ESP32 powered via USB:** The ESP32 DevKit V1 is powered through its own micro-USB port, separate from the component 5V rail. The DevKit's onboard regulator provides 3.3V to the GPIO pins.

- **Component 5V rail:** All external components (LEDs, fan, humidifier, UV-C) are powered from a separate 5V USB-C rail via the CH224K PD sink IC (see FIRMWARE-DOCS.md Section 2.1). This isolates the ESP32 from high-current loads.

- **Power budget (from FIRMWARE-DOCS.md Section 4.5):**
  - Typical draw (normal growing): ~5.5W
  - Peak draw (all systems active): ~10W
  - Requires USB-C PD at 5V/3A (15W) for headroom

- **Ground bus:** All GND connections (ESP32 GND, 5V rail GND, all MOSFET sources, sensor GND) must share a common ground. Connect the ESP32 GND pin to the 5V rail GND.

- **MOSFET selection:** Use logic-level N-channel MOSFETs (IRLZ44N or equivalent) that fully turn on at 3.3V gate voltage. The ESP32 GPIO outputs are 3.3V -- standard (non-logic-level) MOSFETs will not fully saturate and may overheat.

---

## Component BOM

| Component | Qty | Specification | Notes |
|-----------|-----|---------------|-------|
| ESP32 DevKit V1 | 1 | 38-pin, dual-core, Wi-Fi + BLE | Prototype controller |
| BME280 breakout | 1 | I2C, 3.3V, with pull-ups | Temperature / humidity / pressure sensor |
| 30mm axial fan | 1 | 5V DC | PWM speed control via MOSFET |
| Piezo humidifier disc | 1 | 20mm, 113 kHz | Ultrasonic mist generation |
| UV-A LEDs | 6 | 395nm, 20mA, 5050 SMD | Series string for grow lighting |
| Blue LEDs | 6 | 450nm, 20mA, 5050 SMD | Series string for fruiting light |
| UV-C LED | 1 | 275nm, 3535 SMD | Germicidal sterilization, with current-limiting resistor |
| Reed switch | 1 | Normally-open, glass body | Dome presence interlock |
| Neodymium magnet | 1 | 6x2mm disc | Embedded in dome seating lip |
| 12mm tactile button | 1 | Waterproof silicone cap | Mode cycling / UV-C trigger |
| Red 3mm LED | 1 | Standard through-hole | UV-C active indicator |
| N-channel MOSFETs | 5 | IRLZ44N or similar logic-level | LED / fan / humidifier switching |
| 220 ohm resistors | 6 | 1/4W | MOSFET gate resistors (Q1-Q5) + indicator LED current limiting |
| PT4115 LED driver | 1 | Constant-current, 20mA per string | Drives UV-A + Blue LED strings |

---

## UV-C Safety Warning

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

The reed switch is wired **in series** with the UV-C LED power path. This is a physical circuit break, not a software check. The UV-C power path is:

```
5V rail --> [UV-C LED] --> [Reed switch] --> [MOSFET drain] --> GND
```

If the reed switch is open (dome removed), the circuit is broken and no current can flow to the UV-C LED. This works even if the ESP32 firmware crashes, hangs, or sets GPIO 27 HIGH permanently.

**Interlock test procedure (mandatory before first use):**

1. Seat the dome on the base and connect power
2. Trigger a UV-C sterilization cycle -- the red LED (GPIO 2) should light
3. While the red LED is on, carefully lift the dome off the base
4. The red LED should immediately turn off (UV-C power cut by reed switch)
5. Replace the dome -- UV-C should NOT restart (requires new trigger)

**If the interlock fails** (red LED stays on with dome removed): disconnect power immediately. Check reed switch wiring, magnet placement, and MOSFET connections.

---

*Part of the Void Blueprints firmware package.*
*See FIRMWARE-DOCS.md for complete electronics documentation.*
