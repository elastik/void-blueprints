# The Void -- Parts Sourcing Guide

> Complete component sourcing guide for community builders.
> This document lists every component needed to build The Void, with specifications, quantities, costs, and recommended suppliers.
> For assembly instructions, see BUILD-GUIDE.md. For electronics behavior, see FIRMWARE-DOCS.md.

---

## 1. Overview

### What This Guide Covers

This is the definitive shopping list for building a Void dome. Every component is listed with exact specifications, estimated costs, and where to buy it. If it goes into the dome, it is in this guide.

### Three Build Tiers

| Tier | What You Build | Electronics? | Estimated Total Cost |
|---|---|---|---|
| **Dark Dome** | Passive cultivation chamber, no electronics | None | ~$12 |
| **The Void** (base) | Full dome with UV-A, Blue, and UV-C LEDs, mode button, USB-C power | Base electronics | ~$42-57 |
| **Void Core** (advanced) | Smart dome with Pi Zero, sensors, fan, humidifier, camera, app control | Full smart electronics | ~$120-160 |

Costs are estimates based on single-unit purchases from recommended suppliers. Buying in bulk (5+ units) reduces per-unit cost significantly.

### How to Use This Guide

1. Decide which variant you are building (Dark Dome, base Void, or Void Core)
2. Print the 3D parts (Section 2)
3. Order the components for your tier (Sections 3-4)
4. Gather tools (Section 5)
5. Follow BUILD-GUIDE.md for assembly

---

## 2. Printed Parts (From Void Blueprints)

All 3D-printable parts are included in the Void Blueprints package. See BUILD-GUIDE.md for STL files, print settings, and detailed instructions.

| Part | File | Qty | Filament (g) | Est. Cost |
|---|---|---|---|---|
| Dome shell | `void-dome-full.stl` | 1 | ~150g | $4.50 |
| Base housing | `void-base.stl` | 1 | ~200g | $6.00 |
| Substrate platform | `void-platform.stl` | 1 | ~30g | $0.90 |
| Vent caps | `void-vent-cap.stl` | 4 | ~12g (3g each) | $0.36 |
| **Total filament** | | | **~392g** | **~$11.76** |

**Recommended filament:** PETG (smoked/dark tint for dome, black for base). ~$30/kg spool. One spool is sufficient for the complete build with material to spare.

**Smaller printers (<210mm bed):** Use split dome files (`void-dome-split-upper.stl` + `void-dome-split-lower.stl`) instead of `void-dome-full.stl`. Bond halves with CA glue.

---

## 3. Electronics -- Base Void

These components are needed for the base Void (full build). The Dark Dome does not need any of these.

### 3.1 Enclosure Components (Non-Printed)

| Component | Specification | Qty | Est. Cost | Recommended Source | Search Terms / Notes |
|---|---|---|---|---|---|
| Silicone gasket ring | 190mm ID, 1.5mm cross-section, food-grade silicone | 1 | $0.75 | AliExpress | "190mm silicone O-ring 1.5mm" -- buy a 5-pack for spares |
| Silicone rubber feet | 12mm diameter x 3mm tall, adhesive-backed, clear or black | 4 (1 set) | $0.50 | AliExpress / Amazon | "12mm silicone bumper feet adhesive" -- sold in sheets of 20-50 |
| Neodymium magnet | 6mm diameter x 2mm thick, N35 grade, disc | 1 | $0.25 | AliExpress | "6x2mm neodymium magnet" -- buy a 10-pack ($2-3 for 10) |

**Subtotal (enclosure):** ~$1.50

### 3.2 Lighting Components

| Component | Specification | Qty | Est. Cost | Recommended Source | Search Terms / Notes |
|---|---|---|---|---|---|
| UV-A LEDs (395nm) | 5050 SMD, 60-80mW, 120-degree beam, 3.0-3.4V forward | 6 | $3.00 ($0.50 ea) | AliExpress | "5050 UV LED 395nm SMD" -- buy a 100-pack (~$8) for best value; you need 6 |
| Blue LEDs (450nm) | 5050 SMD, 60-80mW, 120-degree beam, 3.0V forward | 6 | $1.50 ($0.25 ea) | AliExpress / LCSC | "5050 blue LED 450nm SMD" -- extremely common part |
| UV-C LED (275nm) | 3535 SMD, 30-40mW radiant output, 120-degree beam | 1 | $4.00 | Digi-Key / Mouser | "275nm UV-C LED 3535" -- use Digi-Key/Mouser for genuine parts (counterfeit risk on AliExpress for UV-C). Seoul Viosys or equivalent. AliExpress ($3-4 ea in 10-packs) is acceptable if you verify with a UV meter. |
| Red indicator LED | 3mm through-hole, standard red, 2.0V forward | 1 | $0.25 | AliExpress / LCSC | "3mm red LED through hole" -- commodity part, any brand |

**Subtotal (lighting):** ~$8.75

**Alternative UV-C LED sources:** If Digi-Key/Mouser pricing is too high for a single unit, AliExpress sellers offer Seoul Viosys-compatible 275nm LEDs in 10-packs for $30-40. Buy extras -- UV-C LEDs are fragile and expensive to replace individually.

### 3.3 Electronics Components

| Component | Specification | Qty | Est. Cost | Recommended Source | Search Terms / Notes |
|---|---|---|---|---|---|
| USB-C receptacle | 16-pin SMD, mid-mount, through-hole legs for stability | 1 | $0.50 | AliExpress / LCSC | "USB-C female connector 16pin SMD" -- very common; verify pinout matches your PCB design |
| USB-C PD sink IC | CH224K, SOT-23-6 package (or IP2721 as alternative) | 1 | $0.50 | LCSC | "CH224K" on LCSC -- $0.15-0.30 each. Configures USB-C for 5V output. Datasheet available from WCH (Nanjing Qinheng). |
| LED driver IC | PT4115, SOT-89 package, constant current | 1 | $0.50 | LCSC | "PT4115" on LCSC -- $0.10-0.20 each. Drives both LED strings at constant 20mA. Alternative: XLSEMI XL4015. |
| 555 timer IC (x2) | NE555 or LMC555 (CMOS preferred for lower power), SOP-8 package | 2 | $0.50 ($0.25 ea) | LCSC | "LMC555 SOP-8" on LCSC -- $0.05-0.10 each. CMOS variant draws less current than bipolar NE555. |
| Reed switch | Normally-open, glass body, ~14mm long, activation distance 5mm | 1 | $0.25 | AliExpress | "glass reed switch normally open" -- buy a 10-pack (~$2). Test each one with a magnet before installing. |
| Tactile push button | 12mm diameter, waterproof with silicone cap, momentary | 1 | $0.50 | AliExpress | "12mm waterproof tactile switch silicone cap" -- ensure it is momentary (not latching) |
| PCB | 2-layer FR-4, 50mm x 30mm | 1 | $1.50 | JLCPCB / PCBWay | Upload Gerber files (when available). JLCPCB: $2 for 5 boards (minimum order). PCBWay similar pricing. |
| Passive components set | 8x resistors (assorted values for LED current limiting and timer configuration), 4x capacitors (100uF electrolytic, 0.1uF ceramic, 1000uF electrolytic for 12h timer, 100uF for UV-C timer), 1x TVS diode (ESD protection), 1x PTC fuse (500mA resettable), 1x Zener diode (5.5V clamp) | 1 set | $1.00 | LCSC | Order with PCB from JLCPCB for combined shipping. Buy assortment kits from AliExpress if ordering separately ("resistor capacitor assortment kit SMD 0805"). |

**Subtotal (electronics):** ~$5.50

**Optional: ATtiny85 microcontroller**

| Component | Specification | Qty | Est. Cost | Recommended Source | Search Terms / Notes |
|---|---|---|---|---|---|
| ATtiny85 | ATTINY85-20PU (DIP-8) or ATTINY85-20SU (SOP-8) | 1 | $0.75 | LCSC / Digi-Key | "ATtiny85" -- DIP-8 for breadboard prototyping, SOP-8 for PCB. Replaces both 555 timers and adds mode memory. See FIRMWARE-DOCS.md Section 3. |
| 8-pin DIP socket | (if using DIP-8 ATtiny85) | 1 | $0.10 | AliExpress | "8 pin DIP IC socket" -- allows removing the ATtiny85 for reprogramming |

### 3.4 Mechanical / Airflow Components

| Component | Specification | Qty | Est. Cost | Recommended Source | Search Terms / Notes |
|---|---|---|---|---|---|
| Micropore tape | 3M Micropore surgical tape, 1" (25mm) width | 1 roll | $0.50 | Amazon / pharmacy | "3M Micropore tape 1 inch" -- one roll provides enough tape for dozens of vent filter replacements. Also available at any pharmacy/drugstore. |
| USB-C cable | 1m (3ft), USB-A to USB-C, black, data+power | 1 | $1.00 | AliExpress / Amazon | "USB A to USB C cable 1m black" -- any standard cable works. Avoid charge-only cables (need power pins). |

**Subtotal (mechanical):** ~$1.50

### 3.5 Base Void -- Complete Bill of Materials

| Category | Subtotal |
|---|---|
| Printed parts (filament) | ~$11.76 |
| Enclosure components | ~$1.50 |
| Lighting | ~$8.75 |
| Electronics | ~$5.50 |
| Mechanical / airflow | ~$1.50 |
| **Total (base Void)** | **~$29.01** |

**Note:** Prices assume single-unit purchases from AliExpress with economy shipping (2-4 weeks). Using Digi-Key/Mouser for all components (faster US shipping) increases electronics cost by approximately $10-15 but guarantees genuine parts and 3-5 day delivery.

**With tools and consumables** (solder, glue, etc.), budget ~$42-57 total for a first build.

---

## 4. Electronics -- Void Core Additions

The Void Core includes ALL base Void components (Section 3) plus the following. Only build these if you are creating a Void Core.

| Component | Specification | Qty | Est. Cost | Recommended Source | Search Terms / Notes |
|---|---|---|---|---|---|
| Raspberry Pi Zero W 2 | Quad-core ARM Cortex-A53, Wi-Fi, BLE, 512MB RAM, CSI camera port | 1 | $15.00 | Raspberry Pi authorized distributors (Pimoroni, Adafruit, SparkFun) | "Raspberry Pi Zero W 2" -- fixed $15 MSRP. Check stock before ordering; supply can be constrained. 8-16 week lead time during shortages. |
| BME280 sensor module | Temperature + humidity + barometric pressure, I2C, breakout board with headers | 1 | $3.00 | AliExpress | "BME280 module I2C" -- $2-3 each. Module includes level shifting and pull-ups. Verify it is BME280 (not BMP280, which lacks humidity). |
| SCD40 CO2 sensor | Sensirion SCD40, I2C, 400-5000 ppm range, photoacoustic | 1 | $18.00 | Digi-Key / Mouser | "SCD40 Sensirion" -- $18 at Digi-Key. This is the most expensive sensor. **Optional** -- can be omitted to reduce cost. Alternative: MH-Z19B NDIR sensor ($5-8 on AliExpress, larger package but adequate accuracy). |
| Piezo humidifier module | 20mm disc, 113 KHz, with driver board | 1 | $1.50 | AliExpress | "20mm ultrasonic mist maker module" or "piezo humidifier disc 113KHz" -- $0.98-1.50 each. Ensure driver board is included. |
| 30mm axial fan | 5V DC, 30x30x10mm, PWM capable (4-pin preferred), <25 dB | 1 | $2.00 | AliExpress | "30mm fan 5V DC" -- if 4-pin PWM is unavailable, a 2-pin 5V fan can be speed-controlled via MOSFET from Pi GPIO. |
| Camera module | 5MP OV5647 or 8MP IMX219, CSI ribbon cable, Pi Zero compatible | 1 | $5.00 | AliExpress / Arducam | "Pi Zero camera module OV5647" -- $5-8 each. Verify ribbon cable is the narrow type for Pi Zero (not full-size Pi). Arducam modules are reliable. |
| WS2812B RGB LEDs | 5050 SMD, addressable (individual IC per LED), single data pin | 8 | $2.00 ($0.25 ea) | AliExpress | "WS2812B 5050 SMD LED" -- buy a strip or 100-pack. You need 8 individual LEDs or a small ring module. Alternative: buy a WS2812B 8-LED ring module ($2-3) pre-assembled. |
| microSD card | 16GB minimum, Class 10 / U1 or better | 1 | $3.00 | Amazon | "16GB microSD Class 10" -- SanDisk or Samsung recommended for reliability. 32GB provides more timelapse storage. |
| Upgraded PCB | 4-layer FR-4, 60mm x 40mm, additional headers for Pi and sensor connections | 1 | $3.00 | JLCPCB | Upload Gerber files (when available). 4-layer adds ~$1 over 2-layer for cleaner routing. |
| Micro-USB to USB-C adapter | Internal adapter for powering the Pi Zero from the Void's USB-C input | 1 | $0.50 | AliExpress | "micro USB to USB-C adapter" -- small inline adapter. Alternative: solder power wires directly to Pi Zero test pads. |
| Micro servo motors (x2) | SG51 or equivalent, 5V, micro size, for motorized vent dampers | 2 | $3.00 ($1.50 ea) | AliExpress | "SG51 micro servo" or "micro servo 5V" -- small enough to fit in the base housing. Alternative: small solenoid valves. |
| Ribbon cables / connectors | CSI ribbon cable (Pi Zero width), I2C Qwiic/Stemma headers, 4-pin JST connectors | 1 set | $2.00 | AliExpress | "Pi Zero camera cable" + "JST 4pin connector set" -- buy assortment packs. |
| Additional passive components | 3.3V voltage regulator (for sensors from 5V rail), additional capacitors, connectors | 1 set | $1.50 | LCSC | Order with JLCPCB PCB for combined shipping. |

### Void Core Additions Subtotal

| Category | Subtotal |
|---|---|
| Pi Zero W 2 | $15.00 |
| Sensors (BME280 + SCD40) | $21.00 |
| Active climate (humidifier + fan + dampers) | $6.50 |
| Camera + storage | $8.00 |
| RGB LEDs (WS2812B x8) | $2.00 |
| PCB + connectors + passives | $7.00 |
| **Void Core additions total** | **~$59.50** |

### Void Core -- Complete Build Cost

| Category | Cost |
|---|---|
| Base Void complete | ~$29.01 |
| Void Core additions | ~$59.50 |
| **Void Core total** | **~$88.51** |

**With tools, consumables, and shipping**, budget ~$120-160 total for a first Void Core build.

**Cost reduction option:** Omit the SCD40 CO2 sensor (-$18) if you do not need precise CO2 monitoring. The fan can be controlled on a simple timer schedule instead. This brings the Void Core additions down to ~$41.50.

---

## 5. Tools Required

### Essential Tools (All Builds)

These tools are needed for any variant (Dark Dome, base Void, or Void Core).

| Tool | Est. Cost | Notes |
|---|---|---|
| 3D printer (220x220mm+ bed) | $150-300 (Ender 3 class) | You likely already have this if you are building from Void Blueprints |
| PETG filament (~400g) | ~$12 | See Section 2 for filament details |
| Flush cutters | $5-10 | For trimming support material and component leads |
| CA (super) glue | $3-5 | For securing the magnet in the dome rim |
| Scissors | -- | For cutting micropore tape |

### Electronics Tools (Base Void and Void Core)

| Tool | Est. Cost | Recommended | Notes |
|---|---|---|---|
| Soldering iron | $25-70 | Pinecil ($25) or TS80P ($70) | Temperature-controlled iron is essential. Pinecil is the best value for beginners. Avoid cheap unregulated irons. |
| Solder | $8-15 | 60/40 tin-lead (0.8mm diameter) or lead-free SAC305 | 60/40 is easier to work with. Lead-free is required in some regions (EU RoHS). |
| Multimeter | $15-30 | Any basic digital multimeter | For testing connections, verifying LED polarity, and checking the reed switch. Essential for troubleshooting. |
| Wire strippers | $5-10 | -- | For preparing wire connections |
| Helping hands / PCB holder | $10-20 | -- | Holds the PCB while soldering. A third-hand tool or PCB vise makes SMD soldering much easier. |
| Heat shrink tubing | $5-8 | Assortment pack (various diameters) | For insulating wire connections and protecting solder joints. Use a lighter or heat gun to shrink. |
| Small Phillips screwdriver | $3-5 | -- | For PCB mounting screws (M3) |
| Isopropyl alcohol (IPA) | $3-5 | 90%+ concentration | For cleaning flux residue after soldering and cleaning the build plate |
| Solder wick or desoldering pump | $3-5 | -- | For fixing solder mistakes. Buy both if new to soldering. |

### Void Core Additional Tools

| Tool | Est. Cost | Notes |
|---|---|---|
| microSD card reader | $5-10 | For flashing Raspberry Pi OS to the microSD card |
| Computer with internet | -- | For downloading Pi OS image and flashing |
| USB micro-B cable | $3-5 | For initial Pi Zero setup (if not using SSH over WiFi) |

### Optional Tools (Post-Processing)

| Tool | Est. Cost | Notes |
|---|---|---|
| Sandpaper (200-1200 grit) | $5-10 | For dome surface smoothing. Progressive wet sanding. |
| Clear coat spray | $8-12 | Krylon UV-resistant clear gloss for improved dome transparency |
| Matte black spray paint | $5-8 | For base exterior finish if desired |
| Smoke tint spray | $8-12 | VHT Nite-Shades for tinting clear PETG domes |

---

## 6. Sourcing Tips

### Supplier Guide

| Supplier | Best For | Shipping (to US) | Pricing | Notes |
|---|---|---|---|---|
| **AliExpress** | LEDs, connectors, passives, gaskets, magnets, fans, modules | 2-4 weeks (economy), 7-15 days (standard) | Cheapest for small quantities | Buy 10-20% extra for defects. Quality varies by seller -- check reviews and order ratings. |
| **LCSC Electronics** | ICs (555 timers, CH224K, PT4115, ATtiny85), SMD passives | Combined with JLCPCB order | Best IC pricing | LCSC is the component sourcing arm of JLCPCB. Order ICs when you order PCBs for combined shipping. |
| **JLCPCB** | PCB fabrication, PCB assembly (SMT) | 5-10 days (standard), 3-5 days (express) | $2-5 for 5 boards | Upload Gerber files, choose specs, order. Can also handle SMT assembly -- they solder components onto your boards. |
| **PCBWay** | PCB fabrication (alternative to JLCPCB) | Similar to JLCPCB | Comparable | Good alternative if JLCPCB is backordered or you want a second quote. |
| **Digi-Key** | UV-C LED (genuine parts), sensors (SCD40), precision components | 3-5 days (US domestic) | Higher than AliExpress | Guaranteed genuine parts. Use for UV-C LED (counterfeit risk on AliExpress) and Sensirion sensors. |
| **Mouser** | Same as Digi-Key (alternative) | 3-5 days (US domestic) | Comparable to Digi-Key | Good alternative to Digi-Key. Same parts catalogs. |
| **Amazon** | Tools, filament, micropore tape, microSD cards, cables | 1-2 days (Prime) | Moderate | Best for tools and consumables. Filament selection is good. |
| **Raspberry Pi authorized distributors** | Pi Zero W 2 | Varies (Pimoroni: 5-10 days UK, Adafruit: 3-5 days US) | Fixed $15 MSRP | Check stock on rpilocator.com before ordering. Multiple authorized resellers. |

### Ordering Strategy

**Single build (1 unit):**
1. Order PCBs from JLCPCB + ICs from LCSC in one shipment
2. Order LEDs, connectors, magnets, gaskets, and modules from AliExpress (allow 2-4 weeks)
3. Order UV-C LED from Digi-Key (domestic shipping, genuine part)
4. Order tools, filament, tape, and cables from Amazon
5. Order Pi Zero W 2 from authorized distributor (Void Core only)

**Multiple builds (5+ units):**
- Buy LED packs in 100-count: UV-A ($8/100), Blue ($5/100)
- Buy reed switches, magnets, and gaskets in 10-20 packs
- Order PCBs in batches of 10 (only slightly more than 5)
- Consider JLCPCB SMT assembly service -- they solder components for you ($10-20 setup + $0.50-1.00 per board)

### Key Warnings

- **UV-C LEDs:** Counterfeit risk on AliExpress. Some sellers label 365nm (UV-A) LEDs as 275nm (UV-C). Genuine UV-C LEDs are invisible to the human eye (275nm is deep UV, not visible purple). If a "UV-C" LED glows visibly purple, it is likely UV-A. Use Digi-Key/Mouser for guaranteed genuine Seoul Viosys or equivalent UV-C parts.
- **BME280 vs BMP280:** Many AliExpress sellers label BMP280 modules as BME280. The BMP280 does NOT measure humidity -- it only measures temperature and pressure. Verify the chip marking says "BME280" (not "BMP280") when the module arrives.
- **Pi Zero W 2 supply:** Raspberry Pi stock fluctuates. During shortages, lead times can stretch to 8-16 weeks. Check availability before committing to a Void Core build. ESP32-S3 is a potential fallback platform ($3-5) but requires different firmware.
- **Component tolerances:** Electrolytic capacitors (used in 555 timer circuits) have +/-20% tolerance. This means your 12-hour timer may actually run 10-14 hours. This is normal for hardware timing. Use the ATtiny85 option for precise timing.

---

## 7. Cost Summary

### Per-Variant Cost Breakdown

#### Dark Dome (~$12)

| Category | Cost |
|---|---|
| Filament (PETG, ~392g) | $11.76 |
| Silicone gasket | $0.75 |
| Rubber feet | $0.50 |
| Micropore tape | $0.50 |
| **Total** | **~$13.51** |

No electronics, no magnet, no cable needed.

#### The Void -- Base Build (~$42-57)

| Category | 1-Unit Cost | 5-Unit Cost (per unit) |
|---|---|---|
| Filament (PETG, ~392g) | $11.76 | $11.76 |
| Enclosure (gasket, feet, magnet) | $1.50 | $1.00 |
| Lighting (LEDs) | $8.75 | $5.00 |
| Electronics (ICs, PCB, passives) | $5.50 | $3.00 |
| Mechanical (tape, cable) | $1.50 | $1.00 |
| **Parts subtotal** | **~$29.01** | **~$21.76** |
| Tools and consumables (first build) | ~$13-28 | -- |
| **Total (first build)** | **~$42-57** | **~$22/unit** |

#### Void Core (~$120-160)

| Category | 1-Unit Cost | 5-Unit Cost (per unit) |
|---|---|---|
| Base Void parts | $29.01 | $21.76 |
| Void Core additions | $59.50 | $48.00 |
| **Parts subtotal** | **~$88.51** | **~$69.76** |
| Tools and consumables (first build) | ~$31-71 | -- |
| **Total (first build)** | **~$120-160** | **~$70/unit** |

### Cost Notes

- **First build** includes one-time tool purchases (soldering iron, multimeter, etc.) that are reused for subsequent builds.
- **AliExpress shipping** is often free for economy (2-4 weeks) but $3-8 for standard (7-15 days). Factor shipping time into your build schedule.
- **5-unit pricing** reflects buying in small bulk packs (100 LEDs, 10 magnets, 10 reed switches). The per-unit savings are significant.
- **Void Core without SCD40** reduces the parts subtotal by ~$18, bringing it to ~$70.50 for a single unit.

---

*Parts Guide version: 1.0*
*Part of the Void Blueprints open-source package.*
