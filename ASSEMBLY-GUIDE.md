# The Void Core -- Assembly Guide

> Step-by-step assembly instructions for the Void Core ESP32 prototype.
> Total build time: approximately 90-120 minutes (excluding print time).

**Before you start:** Verify all components are on hand using [BOM-CHECKLIST.md](BOM-CHECKLIST.md). Print all parts per [PRINT-SETTINGS.md](PRINT-SETTINGS.md). Flash firmware to the ESP32 using PlatformIO before assembly (see `firmware/platformio.ini`).

**Tools needed:** Soldering iron + solder, wire strippers, multimeter, small Phillips screwdriver, flush cutters.

---

## Phase A: Pre-Assembly Inspection (~5 min)

Inspect all printed parts before committing to wiring and gluing. Catching fit issues now saves hours of rework.

### Steps

1. **Lay out all printed parts.** You should have: base housing (203mm dia x 89mm tall), dome (full or upper + lower halves), substrate platform (140mm dia), and 4 vent caps (16mm dia each). Check for warping -- the base must sit flat on a table with no rocking.

2. **Test-fit vent caps into dome exhaust holes.** Each cap (16mm outer diameter) should friction-fit into the 12mm exhaust vent holes with slight resistance from the snap-fit tabs. If too tight, sand the inner diameter lightly with 220-grit sandpaper. If too loose, reprint vent caps at 0.1mm less tolerance (reduce `fdm_tolerance` in `cad/parameters.scad` from 0.2mm to 0.1mm).

3. **If using split dome:** Dry-fit the upper and lower halves together. The 1mm alignment step ring on the inner wall should register cleanly with less than 0.5mm visible gap. Do NOT glue yet -- that happens in Phase E.

4. **Verify platform seats correctly.** Place the substrate platform (140mm dia) inside the base housing. It should rest flat on the platform support ledge at z=45mm on the 3mm-wide support ring (r=67-70mm). The 8 drainage ribs (1mm tall, 1.5mm wide, at 45-degree intervals) should face up.

5. **Check connector cutouts on base housing.** Inspect the USB-C cutout (9mm x 3.5mm), button hole (12mm diameter), and LED indicator hole (3mm diameter) on the base wall. All should be clean openings with no stringing or bridging residue. Clean with flush cutters if needed.

### Go / No-Go Checkpoint A

- [ ] Base sits flat, no warping
- [ ] Vent caps friction-fit into dome exhaust holes
- [ ] Split dome halves register cleanly (if applicable)
- [ ] Platform sits flat on support ledge inside base
- [ ] Connector cutouts are clean

**Proceed to Phase B only if all checks pass.**

---

## Phase B: Magnet & Reed Switch Installation (~10 min)

Install the dome magnet and base reed switch that form the UV-C hardware safety interlock. This interlock physically prevents UV-C radiation when the dome is removed.

### Steps

1. **Press-fit the 6x2mm neodymium magnet into the dome seating lip pocket.** The pocket is 6.5mm diameter x 2.5mm deep (from `parameters.scad`: `magnet_pocket_diameter=6.5`, `magnet_pocket_depth=2.5`), giving 0.5mm clearance around the 6mm magnet. The magnet should sit flush with or slightly below the lip surface. If the fit is loose, secure with a small drop of CA glue. The magnet pocket is located at 0 degrees on the dome seating lip.

2. **Mount the reed switch inside the base housing wall.** Position the glass-body reed switch on the interior of the base wall, aligned with the magnet position (0 degrees on the base rim, directly below where the dome magnet sits when seated). Solder two 150mm wire tails (use signal-colored wire for easy identification) to the reed switch leads. Use heat shrink tubing on the solder joints to prevent shorts.

3. **VERIFY -- UV-C SAFETY INTERLOCK TEST (mandatory):**
   - Place the dome on the base with the alignment notch (5mm wide x 3mm deep) registered correctly.
   - Set your multimeter to continuity mode.
   - Touch the probes to the two reed switch wire tails.
   - **Dome seated:** Multimeter should beep (circuit closed -- magnet closes reed switch).
   - **Dome lifted:** Multimeter should show open circuit (no beep -- magnet too far from reed switch).
   - This is the UV-C safety interlock. **DO NOT proceed to Phase C if this test fails.** Check magnet polarity/orientation, reed switch alignment, and magnet-to-switch distance (should be less than 10mm when dome is seated).

### Go / No-Go Checkpoint B

- [ ] Magnet seated flush in dome lip pocket
- [ ] Reed switch mounted and aligned with magnet position
- [ ] **Continuity test PASSES: closed when dome seated, open when dome lifted**

**Proceed to Phase C only if the interlock test passes.**

---

## Phase C: Electronics Wiring (~45-60 min)

Wire all electronic components following [firmware/WIRING.md](firmware/WIRING.md) exactly. Wire in the order below -- power connections come last to prevent accidental shorts during assembly.

### Steps

**1. I2C Bus -- BME280 Sensor**

Wire the BME280 breakout board to the ESP32:
- BME280 VIN --> ESP32 3V3
- BME280 GND --> ESP32 GND
- BME280 SDA --> ESP32 GPIO 21
- BME280 SCL --> ESP32 GPIO 22

The breakout board has on-board pull-up resistors for I2C -- no external pull-ups needed.

**2. LED MOSFETs -- UV-A, Blue, UV-C**

Wire 3 N-channel MOSFETs (IRLZ44N) for the LED strings. Each MOSFET follows the same pattern:

| MOSFET | GPIO | Gate Resistor | Drain Connection | Source |
|--------|------|---------------|------------------|--------|
| Q1 (UV-A) | GPIO 25 | 220 ohm | UV-A LED string cathode (via PT4115 driver from 5V) | GND |
| Q2 (Blue) | GPIO 26 | 220 ohm | Blue LED string cathode (via PT4115 driver from 5V) | GND |
| Q3 (UV-C) | GPIO 27 | 220 ohm | Reed switch terminal B (see step 3) | GND |

For each MOSFET:
- Solder a 220 ohm resistor between the ESP32 GPIO pin and the MOSFET gate.
- Connect MOSFET source to the GND bus.
- Connect MOSFET drain to the LED string cathode (Q1, Q2) or reed switch (Q3).

The PT4115 constant-current LED driver sits between the 5V rail and the UV-A/Blue LED string anodes, providing regulated 20mA per string.

**3. UV-C Series Interlock**

This is the critical safety circuit. The reed switch is wired IN SERIES in the UV-C LED power path so that UV-C physically cannot operate without the dome seated:

```
[5V rail] --> [UV-C LED + current limiting] --> [Reed switch terminal A]
[Reed switch terminal B] --> [Q3 MOSFET drain] --> [Q3 source] --> [GND]
```

**Important:** If your UV-C LED has Vf > 5V (most 275nm LEDs are 5.5-6.5V), replace the current-limiting resistor with a 5V-to-9V boost converter module (MT3608 or similar). See WIRING.md for details.

The interlock works even if firmware crashes -- it is a physical circuit break, not a software check.

**3b. Reed Switch -- Software Monitoring (GPIO 16)**

In addition to the hardware interlock above, the firmware monitors dome presence via GPIO 16 for logging and dashboard status. Connect ESP32 GPIO 16 to reed switch terminal A (the same terminal connected to the UV-C LED cathode). The ESP32's internal pull-up on GPIO 16 reads LOW when the reed switch is closed (dome seated) and HIGH when open (dome removed). See WIRING.md "Reed Switch (Dome Presence)" section for the full circuit.

**4. Fan**

Wire the 30mm 5V fan through MOSFET Q4:
- Fan+ (red wire) --> 5V rail
- Fan- (black wire) --> Q4 MOSFET drain
- Q4 source --> GND
- ESP32 GPIO 14 --> 220 ohm --> Q4 gate

GPIO 14 provides hardware PWM at 25 kHz, 8-bit resolution (duty cycle 0-255) for fan speed control.

**5. Humidifier**

Wire the piezo humidifier disc through MOSFET Q5:
- Humidifier+ (red wire) --> 5V rail
- Humidifier- (black wire) --> Q5 MOSFET drain
- Q5 source --> GND
- ESP32 GPIO 13 --> 220 ohm --> Q5 gate

Same topology as the fan circuit, but driven with on/off duty cycling (not PWM).

**6. Button**

Wire the 12mm waterproof tactile button between GPIO 17 and GND:
- Button terminal A --> ESP32 GPIO 17
- Button terminal B --> GND

The ESP32 uses its internal pull-up resistor on GPIO 17 -- no external resistor needed. The button reads LOW when pressed.

**7. Indicator LED**

Wire the red 3mm indicator LED with a current-limiting resistor:
- ESP32 GPIO 2 --> 220 ohm resistor --> Red LED anode
- Red LED cathode --> GND

This LED lights during UV-C sterilization as a visual warning. GPIO 2 is the built-in LED on most ESP32 DevKits.

**8. Power**

- **Component 5V rail:** The CH224K USB-C PD sink IC negotiates 5V from the USB-C PD power adapter. This 5V rail powers all external components (LEDs, fan, humidifier, UV-C). Requires a USB-C PD adapter rated for at least 5V/3A (15W). Typical draw is ~5.5W, peak ~10W.
- **ESP32 power:** The ESP32 DevKit V1 is powered separately through its own micro-USB port. The DevKit's onboard regulator provides 3.3V to GPIO pins.
- **Common ground:** All GND connections (ESP32 GND, 5V rail GND, all MOSFET sources, sensor GND) MUST share a common ground bus. Connect the ESP32 GND pin to the 5V rail GND.

**9. Pre-Power Verification (mandatory before connecting ESP32):**

Use a multimeter to check:
- [ ] No short between 5V rail and GND bus (should read open / high resistance)
- [ ] No short between any GPIO pin and GND or VCC
- [ ] Each MOSFET gate resistor reads approximately 220 ohm
- [ ] Reed switch wires are not shorted to adjacent pins
- [ ] All solder joints are clean with no bridging

### Go / No-Go Checkpoint C

- [ ] All 10 GPIO connections wired per WIRING.md pin table (including GPIO 16 to reed switch)
- [ ] 5 MOSFETs installed with gate resistors
- [ ] UV-C series interlock wired (reed switch in series with UV-C LED)
- [ ] No shorts detected on multimeter check
- [ ] All solder joints heat-shrunk or insulated

**Proceed to Phase D only if all checks pass.**

---

## Phase D: Component Mounting (~20 min)

Mount all electronics and components into the base housing.

### Steps

1. **Mount ESP32 DevKit V1** on the +X side standoffs in the base housing using M2 screws. The ESP32 mount is at position (35, -25) inside the base, with 4 standoffs in a 23x58mm hole pattern. The micro-USB port should face the USB-C cutout (9mm x 3.5mm) in the base wall.

2. **Mount BME280 breakout** elevated approximately 20mm above the base floor on its sensor shelf at position (0, 75) near the wall. The sensor needs air circulation, not contact with the base floor. The shelf has a retention lip to hold the breakout board. Secure with M2 hardware if needed.

3. **Position fan** centered in the base housing at origin (0, 0), oriented to blow upward into the dome cavity. The fan sits in the 30mm floor opening with 4 M3 standoffs at 24mm spacing. Secure with M3 screws.

4. **Place humidifier piezo disc** in the humidifier well on the -X side of the base (position -35, 0). The well is a raised cylindrical wall -- 40mm diameter (from `parameters.scad`: `humidifier_reservoir_diameter=40`) x 25mm deep (`humidifier_reservoir_depth=25`). The well has a 1mm weep hole for overflow drainage. For testing, fill with distilled water to 15mm depth.

5. **Route all wires** through the cable channels in the base floor. The channels are 3mm wide x 2mm deep, connecting USB-C to ESP32, ESP32 to fan, ESP32 to BME280, and ESP32 to humidifier. Use small cable ties or hot glue to secure wires in channels. Keep wires below the platform support ledge at z=45mm.

6. **Place substrate platform** on the drainage ribs inside the base. The platform (140mm diameter) rests on the support ledge ring at z=45mm (r=67-70mm). The 6 drain slots (4mm x 20mm each, at 60-degree intervals) and 8 drainage ribs (at 45-degree intervals) should face up for proper moisture management.

### Go / No-Go Checkpoint D

- [ ] ESP32 mounted securely on +X side standoffs
- [ ] BME280 elevated ~20mm, not touching base floor
- [ ] Fan centered, blowing upward
- [ ] Humidifier disc seated in well on -X side
- [ ] All wires routed through channels, below platform ledge
- [ ] Platform seated flat on support ring

**Before proceeding to Phase E -- complete the safety verification below.**

---

> ## STOP -- Safety Verification Before Dome Assembly
>
> Before seating the dome for the first time with all electronics connected, you MUST verify the UV-C safety interlock one more time with the complete wiring in place.
>
> ### Pre-Dome Interlock Test
>
> 1. Connect the USB-C PD power adapter (5V rail) and the ESP32 micro-USB cable.
> 2. Wait for the ESP32 to boot (serial monitor should show `[Init]` startup messages and the "Void Core" ASCII banner).
> 3. **Seat the dome** on the base. Verify the alignment notch (5mm wide x 3mm deep) registers with the base notch.
> 4. Trigger a UV-C sterilization cycle: **press and hold the button for 3 seconds** (long press).
> 5. The red indicator LED (GPIO 2) should light, confirming UV-C is active.
> 6. **Carefully lift the dome off the base.**
> 7. The red indicator LED should **immediately turn off** -- the reed switch opened, breaking the UV-C circuit.
> 8. **Replace the dome.** UV-C should NOT restart automatically (requires a new 3-second button hold to trigger).
>
> ### If the interlock fails:
>
> - **Red LED stays on with dome removed:** IMMEDIATELY disconnect USB power. Check reed switch wiring, magnet alignment, and MOSFET Q3 connections. The reed switch must be wired IN SERIES in the UV-C power path, not just as a GPIO input.
> - **Red LED never turns on:** Check GPIO 27 wiring, Q3 MOSFET gate resistor (220 ohm), and 5V rail power.
> - **DO NOT proceed to Phase E until this test passes.**

---

## Phase E: Dome Assembly (~5-10 min)

### Steps

1. **If using split dome:** Apply medium CA (cyanoacrylate) glue to the alignment step ring on the lower half. Press the upper half firmly onto the lower half, aligning the step ring. Hold for 30 seconds. Apply accelerator spray to the visible joint. Let cure for 5 minutes before handling.

2. **Insert 4 vent caps** into the dome exhaust holes. The caps have a 16mm outer flange and 12mm insertion body with snap-fit tabs. Push each cap inward until the flange seats flush against the dome exterior surface. The caps should hold by friction -- if they fall out, a small dot of CA glue on the snap tab will secure them.

3. **Seat dome onto base.** Align the dome's alignment notch (5mm wide, `alignment_notch_width=5` from `parameters.scad`) with the matching notch on the base rim. The dome seating lip (2.0mm height, 2.0mm inset from `dome_seating_lip_height` and `dome_seating_lip_inset`) should drop into the base seating channel (2.0mm deep x 2.0mm wide from `dome_seating_channel_depth` and `dome_seating_channel_width`). If using the optional silicone gasket O-ring (203mm ID, 2mm cross-section), install it in the gasket groove (1.5mm deep x 2.0mm wide) before seating the dome.

4. **VERIFY dome stability:** The dome should not wobble on the base. Lift and re-seat the dome 3-4 times -- the fit should be repeatable and consistent. The total assembled height should be approximately 254mm (from `parameters.scad`: `total_height=254`).

### Go / No-Go Checkpoint E

- [ ] Split dome halves glued and cured (if applicable)
- [ ] All 4 vent caps seated flush
- [ ] Dome seats firmly in base channel with alignment notch registered
- [ ] No wobble -- dome sits stable and level
- [ ] Assembled height approximately 254mm (10.0")

---

## Post-Assembly: First Power-On

With the dome seated and all checks passing:

1. Connect ESP32 via micro-USB to a computer running PlatformIO.
2. Open serial monitor (115200 baud) to verify boot messages.
3. Connect USB-C PD adapter for the 5V component rail.
4. Test each subsystem using the button:
   - **Short press:** Cycles light modes (Void Glow --> UV Only --> Blue Only --> Off).
   - **Long press (3 sec):** Triggers UV-C sterilization (15-minute cycle). Red indicator should light.
5. Open a web browser and connect to the ESP32 WiFi AP:
   - SSID: `VoidCore`
   - Password: `voidgrows`
   - Dashboard: `http://192.168.4.1`
6. Verify sensor readings on the web dashboard -- temperature, humidity, and pressure should update every 30 seconds.

See [firmware/BENCH-TEST.md](firmware/BENCH-TEST.md) for the full 9-test bench validation procedure.

---

## Wiring Quick Reference

For complete circuit diagrams, see [firmware/WIRING.md](firmware/WIRING.md).

| GPIO | Function | MOSFET | Gate Resistor |
|------|----------|--------|---------------|
| 21 | BME280 SDA | -- | -- |
| 22 | BME280 SCL | -- | -- |
| 25 | UV-A LEDs | Q1 (IRLZ44N) | 220 ohm |
| 26 | Blue LEDs | Q2 (IRLZ44N) | 220 ohm |
| 27 | UV-C LED | Q3 (IRLZ44N) | 220 ohm |
| 14 | Fan PWM | Q4 (IRLZ44N) | 220 ohm |
| 13 | Humidifier | Q5 (IRLZ44N) | 220 ohm |
| 16 | Reed switch | -- | -- (internal pull-up) |
| 17 | Button | -- | -- (internal pull-up) |
| 2 | Red indicator | -- | 220 ohm (LED current limiting) |

---

*Part of the Void Blueprints documentation.*
*See [BOM-CHECKLIST.md](BOM-CHECKLIST.md) for the complete parts list.*
*See [firmware/WIRING.md](firmware/WIRING.md) for full circuit diagrams.*
*Generated from Phase 12 Plan 02 -- Assembly Guide*
*Last updated: 2026-02-22*
