# The Void Core -- Bill of Materials Checklist

> Printable BOM checklist for the Void Core ESP32 prototype build.
> Check off each item as you source and receive it. All components must be on hand before starting the [Assembly Guide](ASSEMBLY-GUIDE.md).

> **Note:** This BOM is for the **prototype build** using the ESP32 DevKit V1.
> The production Void Core uses a Pi Zero W 2 -- see FIRMWARE-DOCS.md (Phase 20+) for the production BOM.

---

## 3D Printed Parts

Print all parts per [PRINT-SETTINGS.md](PRINT-SETTINGS.md). Material: PETG recommended, PLA acceptable for test prints only.

| | Part | Qty | Export Script | Notes |
|---|------|-----|--------------|-------|
| [ ] | Base Housing | 1 | `cad/export/export_base.scad` | 203mm dia x 89mm H, ~200g PETG, ~12 hrs |
| [ ] | Dome -- Full **OR** Upper + Lower | 1 or 2 | `export_dome_full.scad` or `export_dome_upper.scad` + `export_dome_lower.scad` | Full requires 250mm+ build height; split fits 220mm beds |
| [ ] | Substrate Platform | 1 | `cad/export/export_platform.scad` | 140mm dia x 8mm H, ~30g PETG, ~1.5 hrs |
| [ ] | Vent Caps | 4 (printed as 1 set) | `cad/export/export_vent_cap.scad` | 16mm dia x 4mm H each, ~12g PETG total |

**Total filament:** ~380-440g PETG (one 1kg spool is sufficient with margin for test prints)

---

## Electronics -- Core

| | Component | Qty | Specification | Notes |
|---|-----------|-----|---------------|-------|
| [ ] | ESP32 DevKit V1 | 1 | 38-pin, dual-core, Wi-Fi + BLE | Prototype controller. Must be 38-pin variant for correct GPIO layout |
| [ ] | BME280 breakout board | 1 | I2C, 3.3V, with on-board pull-ups | Temperature / humidity / pressure sensor. I2C address 0x76 or 0x77 |
| [ ] | Micro-USB cable | 1 | Data-capable (not charge-only) | Powers ESP32 separately from component 5V rail |

---

## Electronics -- LEDs

| | Component | Qty | Specification | Notes |
|---|-----------|-----|---------------|-------|
| [ ] | UV-A LEDs 395nm | 6 | 5050 SMD, 20mA | Series string for grow/observation light |
| [ ] | Blue LEDs 450nm | 6 | 5050 SMD, 20mA | Series string for fruiting light |
| [ ] | UV-C LED 275nm | 1 | 3535 SMD | Germicidal sterilization. If Vf > 5V, add boost converter (see WIRING.md) |
| [ ] | PT4115 constant-current LED driver | 1 | 20mA per string | Drives UV-A + Blue LED strings from 5V rail |
| [ ] | Red 3mm indicator LED | 1 | Standard through-hole | UV-C active warning indicator, driven from GPIO 2 |

---

## Electronics -- Actuators

| | Component | Qty | Specification | Notes |
|---|-----------|-----|---------------|-------|
| [ ] | 30mm 5V axial fan | 1 | 5V DC, 30mm | FAE (Fresh Air Exchange), PWM speed control via MOSFET on GPIO 14 |
| [ ] | Piezo humidifier disc | 1 | 20mm diameter, 113 kHz | Ultrasonic mist generation, sits in humidifier well (-X side of base) |

---

## Electronics -- Input / Safety

| | Component | Qty | Specification | Notes |
|---|-----------|-----|---------------|-------|
| [ ] | Reed switch, normally-open | 1 | Glass body | Dome presence interlock -- wired IN SERIES with UV-C LED power path |
| [ ] | Neodymium magnet 6x2mm disc | 1 | 6mm diameter, 2mm thick | Press-fit into dome seating lip pocket (6.5mm pocket gives 0.5mm clearance) |
| [ ] | 12mm waterproof tactile button | 1 | With silicone cap | Mode cycling (short press) / UV-C trigger (3-second hold) |

---

## Electronics -- Power

| | Component | Qty | Specification | Notes |
|---|-----------|-----|---------------|-------|
| [ ] | N-channel MOSFETs (IRLZ44N) | 5 | Logic-level, must saturate at 3.3V gate | Q1: UV-A, Q2: Blue, Q3: UV-C, Q4: Fan, Q5: Humidifier |
| [ ] | 220 ohm resistors | 6 | 1/4W | 5x MOSFET gate resistors (Q1-Q5) + 1x indicator LED current limiting |
| [ ] | CH224K USB-C PD sink IC | 1 | Negotiates 5V from USB-C PD source | Provides component 5V rail, separate from ESP32 USB power |
| [ ] | USB-C PD power adapter | 1 | 5V/3A minimum (15W) | Main power supply. Typical draw ~5.5W, peak ~10W |

---

## Hardware

| | Item | Qty | Notes |
|---|------|-----|-------|
| [ ] | M2 screws + nuts | Assorted (8-12) | PCB mounting (ESP32 standoffs, BME280 mount) |
| [ ] | 22 AWG silicone wire | ~2m total | Red, black, and signal colors. Silicone jacket for flexibility in tight routing |
| [ ] | Heat shrink tubing | Assortment | For insulating solder joints, especially on MOSFET leads and LED connections |
| [ ] | Medium CA glue + accelerator | 1 set | Required if using split dome; optional for securing magnet in pocket |
| [ ] | Silicone gasket O-ring | 1 | 203mm ID, 2mm cross-section -- optional dome seal for humidity retention |

---

## Tools Required

| | Tool | Notes |
|---|------|-------|
| [ ] | Soldering iron + solder | For all wire connections, MOSFET gate resistors, LED strings |
| [ ] | Wire strippers | 22 AWG compatible |
| [ ] | Multimeter | Continuity mode (reed switch test) + voltage mode (power rail verification) |
| [ ] | Small Phillips screwdriver | M2 hardware |
| [ ] | Flush cutters | Trimming component leads and wire ends |
| [ ] | Computer with PlatformIO | For compiling and flashing firmware to ESP32. See `firmware/platformio.ini` |

---

## Quick Reference: GPIO Pin Map

For wiring reference, see [firmware/WIRING.md](firmware/WIRING.md) for full circuit diagrams.

| GPIO | Function | Signal |
|------|----------|--------|
| 21 | BME280 SDA | I2C data |
| 22 | BME280 SCL | I2C clock |
| 25 | UV-A LEDs | MOSFET gate (Q1) |
| 26 | Blue LEDs | MOSFET gate (Q2) |
| 27 | UV-C LED | MOSFET gate (Q3), reed switch in series |
| 14 | Fan PWM | MOSFET gate (Q4), 25 kHz |
| 13 | Humidifier | MOSFET gate (Q5) |
| 16 | Reed switch | Input, internal pull-up, LOW = dome seated |
| 17 | Button | Input, internal pull-up, LOW = pressed |
| 2 | Red indicator LED | UV-C warning, active HIGH |

---

*Part of the Void Blueprints documentation.*
*See [ASSEMBLY-GUIDE.md](ASSEMBLY-GUIDE.md) for build instructions.*
*Generated from Phase 12 Plan 02 -- BOM Checklist*
*Last updated: 2026-02-22*
