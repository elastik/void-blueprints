# The Void -- Open-Source Build Guide

> Complete build documentation for community builders printing their own Void mushroom cultivation dome.
> This guide covers everything from STL file preparation through final assembly and testing.
> For electronic component sourcing, see PARTS-GUIDE.md. For firmware details, see FIRMWARE-DOCS.md.

---

## 1. Introduction & Overview

### What You're Building

**The Void** is a UV-lit mushroom cultivation dome -- a sealed growing chamber that doubles as a living art piece. It houses a pre-inoculated substrate block inside a smoked dome on a matte black base, illuminated by UV-A and blue LEDs. USB-C powered. No moving parts.

The completed dome measures **8.0" (203mm) diameter x 10.0" (254mm) total height** and sits on any desk, shelf, or nightstand.

### What's Included in Void Blueprints

Void Blueprints is the free, open-source package that includes:

- **STL files** for all printable parts (dome, base, platform, vent caps)
- **Pre-configured 3MF files** with optimized print settings for PrusaSlicer and Cura
- **STEP files** for community modifications and remixes
- **This build guide** covering print settings, tools, and step-by-step assembly

### What You'll Need to Buy Separately

The 3D-printed parts are only the enclosure. You will also need:

- **Electronics** -- LEDs, driver ICs, reed switch, button, USB-C connector, PCB, and passive components (~$30-45 sourced from AliExpress). See PARTS-GUIDE.md for a complete sourcing guide.
- **Hardware** -- silicone gasket, rubber feet, neodymium magnet, micropore tape (~$3-5)
- **Filament** -- PETG recommended (~$11-12 for all parts)

### Estimated Build Time

| Phase | Time |
|---|---|
| 3D printing (all parts) | 23-32 hours |
| Post-processing (optional) | 1-2 hours |
| Electronics assembly | 1-2 hours |
| Final assembly | 1-2 hours |
| **Total** | **~26-38 hours** (mostly unattended printing) |

### Estimated Total Cost

| Category | Cost |
|---|---|
| PETG filament (~380g) | ~$11.50 |
| Electronics and components | ~$30-45 |
| **Total (complete base Void)** | **~$40-55** |

### Build Variants

This guide covers three build options:

| Variant | Description | Electronics? |
|---|---|---|
| **The Void** (full build) | Complete cultivation dome with UV-A, blue, and UV-C LEDs, mode button, and USB-C power | Yes -- full electronics |
| **Dark Dome** (no electronics) | Same physical shell, no lighting or electronics. Ideal for bioluminescent species or budget builds | No electronics |
| **Void Core** (advanced) | Smart dome with Raspberry Pi, sensors, active humidity, and fan. See separate Void Core build guide | Advanced electronics |

This guide covers **The Void** (full build) and notes where the **Dark Dome** diverges. The Void Core is documented separately.

---

## 2. STL File Inventory

All files are available in the Void Blueprints repository. Download the complete package or individual files as needed.

### Printable Parts

| File | Description | Qty | Filament (g) | Print Time (est.) | Notes |
|---|---|---|---|---|---|
| `void-dome-full.stl` | Complete dome shell, 203mm diameter x 165mm tall, 2mm wall | 1 | ~150g | 12-16 hours | Single piece; fits 220x220mm beds |
| `void-dome-split-upper.stl` | Upper dome half (hemisphere section) | 1 | ~90g | 7-10 hours | For printers with <210mm bed width |
| `void-dome-split-lower.stl` | Lower dome half (vertical sidewall section) | 1 | ~60g | 5-6 hours | Pairs with upper split; glue together |
| `void-base.stl` | Complete base housing, 203mm diameter x 89mm tall | 1 | ~200g | 10-14 hours | Includes electronics bay, platform supports, vent slots |
| `void-platform.stl` | Substrate platform, 140mm diameter, perforated with drain slots | 1 | ~30g | 1-2 hours | Sits inside base; holds substrate block |
| `void-vent-cap.stl` | Snap-in exhaust vent cover for dome | 4 | ~3g each | 15-20 min each | Print all 4; holds micropore tape filter |

**Total filament for full build:** ~380g PETG

### Additional File Formats

| File | Format | Purpose |
|---|---|---|
| `void-dome-full.3mf` | 3MF | Dome with pre-configured print settings for PrusaSlicer and Cura (PETG on Ender 3 / Prusa i3) |
| `void-base.3mf` | 3MF | Base with pre-configured print settings |
| `void-assembly.step` | STEP | Full assembly CAD file for community modifications and remixes |

The `.3mf` files include recommended layer height, infill, support settings, and PETG material profiles pre-configured for Ender 3 and Prusa i3 printers. If you use one of these printers, the 3MF files are the easiest way to get started -- just open in your slicer and print.

---

## 3. Recommended Print Settings

### Printer Compatibility

**Minimum bed size: 220 x 220mm.** The dome is 203mm in diameter and must fit flat on the bed with margin.

The Void Blueprints are designed for mainstream FDM printers. Reference printers:

| Printer | Build Volume | Compatible? |
|---|---|---|
| Ender 3 / Ender 3 V2 | 220 x 220 x 250mm | Yes -- 8.5mm margin on each side |
| Prusa i3 MK3S+ / MK4 | 250 x 210 x 210mm | Yes |
| Prusa Mini (180 x 180mm) | 180 x 180 x 180mm | No (dome too large) -- use split files |
| Any printer with 220mm+ bed | Varies | Yes, if bed is at least 220mm in both X and Y |

**Smaller printers:** If your bed is under 210mm, use the split dome files (`void-dome-split-upper.stl` and `void-dome-split-lower.stl`). Print both halves and bond them with CA (super) glue or solvent welding along the split seam.

### Per-Part Print Settings

#### Dome Shell (`void-dome-full.stl`)

| Setting | Value | Notes |
|---|---|---|
| **Material** | PETG (smoked/dark tint preferred) | Humidity-resistant; semi-translucent for UV glow |
| **Layer height** | 0.2mm standard; 0.12mm for improved clarity | Finer layers reduce visible layer lines on dome |
| **Infill** | N/A -- dome is solid walls | 2mm wall thickness = 5 perimeters at 0.4mm nozzle |
| **Perimeters** | 5 (to achieve 2.0mm wall thickness) | 100% perimeters; no infill needed for thin-wall dome |
| **Print speed** | 50mm/s | Slower = better surface quality on curved surfaces |
| **Print orientation** | Open side down, apex up | Hemisphere prints cleanly from flat rim upward |
| **Supports** | Minimal -- apex only | Most of the dome stays within 45-degree overhang limit. Only the very top (~10-15mm near apex) may need light support. The apex has a 10mm flat to enable clean bridging. |
| **Bed temperature** | 70-80C | PETG requires heated bed for adhesion |
| **Nozzle temperature** | 230-245C | Adjust per your PETG brand; start at 235C |
| **Bed adhesion** | Glue stick or PEI sheet recommended | PETG sticks aggressively to bare glass and PEI; glue stick helps with release |

#### Base Housing (`void-base.stl`)

| Setting | Value | Notes |
|---|---|---|
| **Material** | PETG (primary) or PLA+ (acceptable) | PETG preferred for humidity resistance; PLA+ is easier to print but degrades in humid environments over time |
| **Layer height** | 0.2mm | Standard quality is fine for the base |
| **Infill** | 15% | Provides adequate rigidity without wasting filament |
| **Perimeters** | 4 (to achieve ~1.6mm minimum wall) | Base wall spec is 2.5mm; 4 perimeters at 0.4mm gives 1.6mm walls + infill fill |
| **Print speed** | 50mm/s | Standard speed |
| **Print orientation** | Bottom down (flat base on bed) | Excellent bed adhesion; internal features print upward |
| **Supports** | None | Base geometry is designed to print support-free |
| **Bed temperature** | 70-80C (PETG) / 60C (PLA+) | Adjust for your material |
| **Nozzle temperature** | 230-245C (PETG) / 200-215C (PLA+) | Adjust per brand |

#### Substrate Platform (`void-platform.stl`)

| Setting | Value | Notes |
|---|---|---|
| **Material** | PETG | Same material as base for consistency |
| **Layer height** | 0.2mm | Standard quality |
| **Infill** | 15% | Adequate for a platform |
| **Print speed** | 50mm/s | Standard |
| **Print orientation** | Flat side down | Simple flat part; no orientation concerns |
| **Supports** | None | Designed to print without supports |
| **Bed temperature** | 70-80C | Standard PETG |
| **Nozzle temperature** | 230-245C | Standard PETG |

#### Vent Caps (`void-vent-cap.stl` x4)

| Setting | Value | Notes |
|---|---|---|
| **Material** | PETG | Match dome material |
| **Layer height** | 0.2mm | Standard |
| **Infill** | 100% | Small parts; solid fill for strength |
| **Print speed** | 40mm/s | Slower for small detail |
| **Print orientation** | Flat side down | Print with the snap-fit tab facing up |
| **Supports** | None | Designed for support-free printing |
| **Bed temperature** | 70-80C | Standard PETG |
| **Nozzle temperature** | 230-245C | Standard PETG |

Print all 4 vent caps in a single batch to save time.

### Material Recommendations Summary

| Material | Recommended For | Why |
|---|---|---|
| **PETG (primary)** | All parts | Excellent humidity resistance (critical for 85-90% RH environment), semi-translucent for dome, moderate temperature resistance (80C), low warping |
| **PLA+** | Base housing only | Easier to print, better surface finish, but degrades in high humidity over time. Acceptable for the base since it is outside the humid chamber. NOT recommended for the dome. |
| **ABS** | Base housing (experienced printers) | High temp resistance, acetone-smoothable, but requires enclosure and produces toxic fumes during printing |
| **ASA** | Base housing or dome | UV-resistant alternative to ABS; similar properties but less widely available |
| **Clear PETG** | Dome (Dark Dome variant) | Semi-translucent for bioluminescent species viewing |

---

## 4. Tools & Materials Checklist

### Required Tools & Materials

You will need these to complete the build:

1. **3D printer** -- Ender 3 class or better, 220x220mm minimum bed
2. **PETG filament** -- approximately 400g total (smoked/dark tint for dome, black for base)
3. **Soldering iron + solder** -- for PCB and LED assembly
4. **Wire strippers** -- for preparing wire connections
5. **Flush cutters** -- for trimming leads and removing support material
6. **Small Phillips screwdriver** -- for PCB and component mounting
7. **Small flathead screwdriver** -- for prying and adjusting
8. **CA (super) glue** -- for securing the neodymium magnet in the dome rim pocket
9. **3M Micropore tape** -- for vent filters (blocks contaminant spores while allowing airflow)
10. **USB-C cable** -- standard USB-C to USB-A or USB-C to USB-C
11. **5V USB power adapter** -- any phone charger rated 5V/1A or higher

### Optional Tools & Materials (Post-Processing)

These improve the finished appearance but are not required for a functional build:

1. **Sandpaper** -- 200, 400, 800, and 1200 grit (progressive wet sanding for dome smoothing)
2. **Clear coat spray** -- Krylon UV-resistant clear gloss (2-3 light coats on dome for improved transparency)
3. **Matte black spray paint** -- primer + matte black for base exterior finish
4. **Smoke tint spray** -- VHT Nite-Shades or similar (if using clear PETG and you want a smoked dome look)

---

## 5. Pre-Print Checklist

Complete these steps before starting your first print:

1. **Verify bed size** -- confirm your printer bed is at least 220 x 220mm. The dome is 203mm in diameter and needs 8.5mm clearance on each side. If your bed is smaller than 210mm, use the split dome files instead.

2. **Level your bed** -- a level bed is critical for the large dome footprint. Run your printer's bed leveling routine. For manual tramming, check all four corners and the center.

3. **Load PETG filament** -- if you have not printed PETG before, review your printer's PETG temperature profile. PETG typically prints at 230-245C nozzle and 70-80C bed. It is more stringy than PLA but more durable.

4. **Run a test print** -- before committing to a 12-16 hour dome print, run a small test piece (a 50mm cube or calibration print) in PETG to verify bed adhesion and temperature settings on your specific printer.

5. **Clean the build plate** -- wipe with isopropyl alcohol. For PETG, apply a thin layer of glue stick to prevent the print from bonding too aggressively to glass or PEI surfaces.

6. **Verify PETG temperature profile** -- every PETG brand prints slightly differently. Start with 235C nozzle / 75C bed and adjust. If you see stringing, reduce nozzle temp by 5C. If you see poor layer adhesion, increase by 5C.

7. **Check filament quantity** -- ensure you have at least 400g of PETG available. Running out mid-print on the dome is not recoverable. Weigh your spool if unsure.

8. **Clear print schedule** -- the dome alone takes 12-16 hours. Plan to start the print when you can monitor the first few layers and let it run overnight or through the day.

---

## 6. Assembly Overview

### Assembly Flow

Follow this order for the smoothest build experience:

```
Print all parts
      |
      v
Post-process (optional: sand dome, paint base)
      |
      v
Install electronics in base (PCB, LEDs, USB-C, button, reed switch)
      |
      v
Install silicone gasket in base rim
      |
      v
Apply micropore tape to all vents
      |
      v
Install neodymium magnet in dome rim
      |
      v
Test electronics (power on, verify all light modes)
      |
      v
Seat dome on base
      |
      v
Done -- place a Void Pack and grow
```

### Estimated Assembly Time

- **Electronics assembly (Steps 1-12):** 1-2 hours (most time spent soldering)
- **Dome preparation (Steps 13-16):** 15-30 minutes
- **Final assembly and testing (Steps 17-22):** 30-45 minutes
- **Total:** 2-4 hours (excluding print time and post-processing)

### Cross-Section Reference Diagram

Refer to this diagram throughout assembly. It shows the internal layout and how all components fit together.

```
                          ___
                        /     \           <- Dome apex
                      /  (ExV)  \         <- Exhaust vent (x4 around this zone)
                    /             \
                   /               \
                  |   ~~~HUMID~~~   |     <- High-humidity growing zone (85-90% RH)
                  |                 |
                  |  +===========+  |
                  |  ||  FRUIT  ||  |     <- Mushroom fruiting bodies
                  |  || BODIES  ||  |
                  |  +===========+  |
                  |  |  VOID     |  |     <- Void Pack substrate block
                  |  |  PACK     |  |        (~4.5" W x 3" H, 1-2 lbs)
                  |  |  BLOCK    |  |
                  |  +-----+-----+  |
                  |  | platform  |  |     <- Substrate platform (5.5" / 140mm dia)
    Dome -------> |  +--+--+--+--+  |
    seated in --> ====[LED RING]====== <-- UV-A (395nm) + Blue (450nm) LEDs
    base channel  |     (Magnet^)   |     <- Magnet in dome lip / Reed switch in base
                  |                 |
               -->[InV]  PLENUM [InV]<--  <- Intake vents (x8) with micropore tape
                  |    (airflow)    |        Fresh air enters here
                  |  +-----------+  |
                  |  | ELECTR.   |  |     <- LED driver, UV-C LED (points up),
                  |  | [UV-C ^]  |  |        mode button, USB-C connector
                  |  | [BTN][USB]|  |
                  +--+-----------+--+
                    (  rubber feet  )     <- 4x silicone feet
               ========================     Desk surface
```

**Key dimensions:**
- Overall: 8.0" (203mm) wide x 10.0" (254mm) tall
- Dome: 6.5" (165mm) tall (including 1.0" / 25mm vertical sidewall)
- Base: 3.5" (89mm) tall
- Substrate platform: 5.5" (140mm) diameter, 0.5" (13mm) deep well
- Substrate clearance above block: ~5.5-6.0" (140-152mm) to dome apex
- LED ring position: at dome/base junction, angled 30 degrees upward
- UV-C LED position: in electronics bay, pointing upward through platform drain slots

---

## 7. Base Assembly (Steps 1-12)

### Step 1: Inspect Printed Base

**What:** Check the printed base housing for quality issues before assembly.

**How:** Examine the base for warping (set it on a flat surface -- it should sit flat without rocking). Look for stringing inside the electronics bay and around vent slots. Remove any loose stringing with flush cutters. Check that all 8 intake vent slots (15mm x 5mm each) are clear and open. Verify the dome seating channel (2mm deep groove around the top rim) is clean and even.

**Check:** Base sits flat on a table. All 8 intake vents are open. Electronics bay is clean and accessible. Dome seating channel has no blobs or stringing.

### Step 2: Install Rubber Feet

**What:** Attach four silicone rubber feet to the bottom of the base for desk stability.

**How:** Clean the base bottom with isopropyl alcohol. Peel the adhesive backing from each 12mm x 3mm silicone foot. Place one foot near each edge of the base bottom, spaced evenly around the circumference (roughly at 12, 3, 6, and 9 o'clock positions). Press firmly for 10 seconds each.

**Check:** All four feet are firmly attached. Base sits level and does not wobble on a flat surface.

### Step 3: Install Substrate Platform

**What:** Place the substrate platform in the base.

**How:** Orient the platform with the perforated (drain slot) side facing up. Lower it into the recessed well inside the base. It should sit level on the molded supports inside the base, approximately 0.5" (13mm) above the airflow plenum.

**Check:** Platform sits level in the base. Drain slots are visible and unobstructed. Platform does not rock or tilt.

### Step 4: Install PCB in Electronics Bay

**What:** Mount the assembled PCB in the electronics bay at the bottom of the base.

**How:** The electronics bay is the lower compartment of the base, beneath the airflow plenum. Position the PCB (50mm x 30mm, 2-layer) so the USB-C connector aligns with the rectangular cutout (9mm x 3.5mm) at the rear-center of the base. Secure the PCB with M3 screws into the printed screw bosses (3.2mm holes), or friction-fit it against the printed retention features. Ensure the PCB sits flat and is not stressed or bent.

**Check:** PCB is seated flat in the electronics bay. USB-C port aligns with the rear cutout. PCB does not shift when you press on it.

### Step 5: Solder LED Ring

**What:** Build the LED ring with 12 LEDs (6 UV-A + 6 Blue) in alternating configuration.

**How:** The LED ring PCB holds 12 5050 SMD LEDs in a circular arrangement. Alternate UV-A (395nm) and Blue (450nm) LEDs around the ring: UV-A, Blue, UV-A, Blue, and so on. All LEDs should be angled approximately 30 degrees upward (toward the dome interior when assembled). Solder each LED observing correct polarity -- the cathode marking on the LED must match the PCB pad marking. Each LED draws 20mA at 3.0-3.4V forward voltage. The 6 UV-A and 6 Blue LEDs are wired as two strings of 6, driven by the PT4115 constant-current LED driver IC on the PCB.

**Check:** All 12 LEDs are soldered with correct polarity. No solder bridges between pads. Visual inspection: all LEDs seated flat and evenly spaced.

### Step 6: Mount LED Ring

**What:** Install the LED ring at the dome/base junction.

**How:** Position the LED ring PCB on the mounting posts at the top of the base housing, just inside the dome seating channel. The LEDs should point upward at approximately 30 degrees into the dome interior. Secure with M3 screws into the printed posts, or use hot glue if your print does not have clean screw holes. Connect the LED ring wires to the main PCB below (two connections: UV-A string and Blue string).

**Check:** LED ring is firmly mounted. LEDs point upward into the dome area. Wires routed cleanly to the electronics bay below.

### Step 7: Install UV-C LED

**What:** Install the single UV-C sterilization LED pointing upward through the platform drain slots.

**How:** The UV-C LED (275nm, 3535 SMD package) mounts on the main PCB or a small daughter board in the electronics bay. It must point directly upward through the drain slots in the substrate platform so its 120-degree beam covers the dome interior. The UV-C LED operates at 6.5V (via a boost converter from 5V) and draws 250-350mA when active. It is wired through the reed switch (safety interlock) so it can only receive power when the dome magnet closes the reed switch.

**Check:** UV-C LED is mounted pointing straight up. When you look down through the substrate platform drain slots, you can see the UV-C LED below.

### Step 8: Install Reed Switch

**What:** Position the reed switch for the UV-C safety interlock.

**How:** The reed switch (normally-open, glass body) must be positioned in the base near the dome seating rim, within 5mm of where the dome's embedded magnet will sit when the dome is seated. Secure the reed switch with hot glue in the channel or slot designed for it in the base top rim area. The reed switch is wired in series with the UV-C LED power line -- this is a hardware interlock, not software. When the dome magnet is within 5mm, the reed switch closes and completes the UV-C power circuit.

**Check:** Reed switch is firmly positioned near the dome seating rim. Reed switch leads are connected to the UV-C power circuit on the PCB.

### Step 9: Install Mode Button

**What:** Install the button for cycling light modes and activating UV-C.

**How:** Insert the 12mm waterproof tactile switch into the circular cutout on the front of the base. The button should sit flush with or slightly proud of the base exterior. Connect the button leads to the mode logic circuit on the PCB. The button has two functions: tap to cycle light modes (Void Glow, UV Only, Blue Only, Off) and press-and-hold for 3 seconds to start a UV-C sterilization cycle.

**Check:** Button clicks cleanly when pressed. Button is accessible from the outside of the base. Button wires connected to PCB.

### Step 10: Install USB-C Connector

**What:** Mount the USB-C power input connector.

**How:** The USB-C receptacle sits in the rectangular cutout (9mm x 3.5mm) at the rear-center of the base, recessed 3mm into the housing. If the USB-C connector is on the main PCB, it should already be aligned from Step 4. If it is a separate connector, mount it in the cutout and wire it to the PCB. The USB-C PD sink IC (CH224K or IP2721) on the PCB negotiates 5V from any USB-C source.

**Check:** USB-C port is accessible from the rear of the base. A USB-C cable plugs in and seats fully. Port is recessed and protected.

### Step 11: Wire Connections

**What:** Complete all internal wiring between components.

**How:** Refer to the wiring diagram below and connect all remaining wires. Use the PCB's solder pads or screw terminals as appropriate.

```
USB-C port
    |
    v
[USB-C PD Sink IC] --> 5V rail
    |
    +---> [LED Driver] ---> UV-A LED string (6x series)
    |         |
    |         +-----------> Blue LED string (6x series)
    |
    +---> [555 Timer #1] ---> 12h cycle control (enables/disables LED driver)
    |
    +---> [Button] ---> [Mode logic] ---> LED driver enable/channel select
    |                        |
    |                        +---> [3-sec hold detect] ---> UV-C trigger
    |
    +---> [Reed switch] ---> [555 Timer #2] ---> UV-C LED
    |                                             (interlock in series)
    |
    +---> [Red indicator LED] (parallels UV-C power)
```

Key wiring notes:
- The reed switch is wired **in series** with the UV-C LED power. This is a hardware safety interlock -- UV-C physically cannot receive power without the dome magnet closing the reed switch.
- The red indicator LED is wired in parallel with the UV-C power line. It lights whenever UV-C is active.
- Two NE555 timer ICs handle: (1) 12-hour on/off light cycle, and (2) 15-minute UV-C auto-shutoff.
- All components operate from a single 5V rail supplied through the USB-C connector.

**Check:** Trace every wire visually. Verify the reed switch is in series with UV-C (not bypassed). Verify the red LED is connected. Verify button connections. No loose or floating wires.

### Step 12: Install Red Indicator LED

**What:** Mount the UV-C active indicator LED next to the mode button.

**How:** Install the 3mm red through-hole LED in the small hole next to the button cutout on the base front. The LED should be visible from outside the base. It is wired in parallel with the UV-C LED power -- it lights whenever a UV-C sterilization cycle is running, warning users not to remove the dome.

**Check:** Red LED is visible from outside the base. When UV-C activates, this LED will light up.

---

## 8. Dome Preparation (Steps 13-16)

### Step 13: Inspect Printed Dome

**What:** Check the dome print quality before proceeding.

**How:** Examine the dome for good layer adhesion -- run your fingernail across the layers; they should not separate or feel like they are peeling. Check overall dome roundness by rolling it gently on a flat surface. Verify all 4 exhaust vent holes (12mm diameter each) near the apex are clean and open. Check the dome seating rim at the bottom -- it should be flat and even, with the magnet pocket (6.5mm diameter x 2.5mm deep) clearly visible.

**Check:** Layers are well-bonded. Dome is reasonably round (no major warping). All 4 exhaust vents are open. Seating rim is flat. Magnet pocket is present and clean.

### Step 14: (Optional) Post-Process Dome

**What:** Sand and finish the dome for improved appearance and transparency.

**How:** This step is optional but significantly improves the dome's appearance.

1. **Wet sand** the dome exterior starting with 200-grit sandpaper, working progressively through 400, 800, and 1200 grit. Wet sanding reduces dust and produces a smoother finish. Sand in circular motions, applying even pressure.
2. **Dry thoroughly** after sanding.
3. **Apply clear coat** -- spray 2-3 light coats of Krylon UV-resistant clear gloss, allowing 15 minutes between coats. Hold the can 10-12 inches from the surface. Multiple thin coats are better than one thick coat.
4. **Test UV glow** -- before clear coating, place a UV-A LED inside the dome in a dark room to verify the UV glow effect through the printed walls. This confirms your PETG transmits enough light. Do this test BEFORE post-processing, so you can adjust if needed.

**Check:** Dome surface is smoother than raw print. Clear coat is even without drips or pooling. UV glow is visible through dome walls.

### Step 15: Install Neodymium Magnet

**What:** Press-fit the dome magnet into the rim pocket for the UV-C safety interlock.

**How:** Apply a small drop of CA (super) glue inside the magnet pocket (6.5mm diameter x 2.5mm deep) in the dome's seating rim. Press a 6mm x 2mm neodymium disc magnet (N35 grade) into the pocket. The magnet should sit flush with or slightly below the rim surface. Hold in place for 30 seconds while the glue sets.

**Important:** Before gluing, test that the magnet activates the reed switch in the base. Hold the magnet near the reed switch location -- you should hear a faint click or be able to verify closure with a multimeter. If the magnet does not activate the reed switch from the dome rim pocket position, the reed switch may need to be repositioned closer (within 5mm).

**Check:** Magnet is firmly glued in the pocket. Magnet does not protrude above the rim surface. Magnet activates the reed switch when the dome is seated on the base.

### Step 16: Apply Micropore Tape to Exhaust Vents

**What:** Install contamination barrier filters on the dome's exhaust vents.

**How:** Cut 4 small squares of 3M Micropore tape, each large enough to fully cover a 12mm exhaust vent hole. Apply one piece over each of the 4 exhaust vents on the dome exterior. If your dome has snap-in vent cap holders, apply the tape to the vent cap disc, then snap it into position. The micropore tape blocks contaminant spores (particles > 0.3 micrometers) while allowing humid air to pass through.

**Check:** All 4 exhaust vents are covered with micropore tape. Tape is smooth and fully adhered -- no gaps or lifted edges.

---

## 9. Final Assembly & Testing (Steps 17-22)

### Step 17: Apply Micropore Tape to Base Intake Vents

**What:** Install contamination barrier filters on the base's intake vents.

**How:** Cut 8 small strips of 3M Micropore tape, each large enough to cover one intake vent slot (15mm x 5mm). Apply one strip over each of the 8 intake vent slots around the base perimeter. Press firmly to ensure full adhesion.

**Check:** All 8 intake vents are covered with micropore tape. No gaps or loose edges.

### Step 18: Install Silicone Gasket

**What:** Press-fit the silicone gasket ring into the base seating channel.

**How:** The base top rim has a 2.0mm wide x 1.5mm deep groove (the dome seating channel). Press the silicone gasket ring (190mm ID, 1.5mm cross-section, food-grade silicone) into this groove. Work it in evenly around the full circumference. The gasket creates a humidity seal between the dome and base while still allowing easy dome removal.

**Check:** Gasket is fully seated in the groove all the way around. Gasket does not pop out when you press on it. Gasket surface is slightly proud of the rim (this is correct -- it compresses when the dome is seated).

### Step 19: Seat Dome on Base

**What:** Place the dome onto the base for the first time.

**How:** Align the dome's orientation notch with the corresponding notch on the base rim. This single alignment notch ensures the dome always seats in the same orientation (important for vent alignment and magnet/reed switch positioning). Lower the dome straight down onto the base. Press down firmly until the gasket compresses and the dome sits flush in the seating channel.

**Check:** Dome sits evenly on the base with no gaps visible around the rim. Dome does not wobble. You can feel the gasket providing a slight seal. The dome lifts straight off with gentle upward force -- no sticking or binding.

### Step 20: Connect Power

**What:** Power up the Void for the first time.

**How:** Plug a USB-C cable into the port on the rear of the base. Connect the other end to any 5V USB power adapter rated 1A or higher (any standard phone charger will work). The base Void draws only 0.8-1.1W during normal operation -- well under the USB 2.0 500mA/2.5W limit.

**Check:** USB-C cable seats fully in the port. Power adapter is connected and turned on.

### Step 21: Test Light Modes

**What:** Verify all light modes work correctly.

**How:** Tap the mode button to cycle through the four light modes:

| Mode | Button Press | UV-A (purple) | Blue | What You See |
|---|---|---|---|---|
| 1. Void Glow | Tap (default) | ON | ON | Purple + blue glow inside dome |
| 2. UV Only | Tap | ON | OFF | Purple-only glow |
| 3. Blue Only | Tap | OFF | ON | Blue-only light |
| 4. Off | Tap | OFF | OFF | No light |

Cycle through all four modes. In a darkened room, verify the UV-A purple glow is visible through the dome walls. The 12-hour timer circuit will automatically cycle the lights (12h on, 12h off) during normal use.

**Check:** All four modes cycle correctly with button taps. LEDs illuminate inside the dome. UV-A glow is visible through the dome wall. Modes cycle in order: 1, 2, 3, 4, 1.

### UV-C SAFETY WARNING

```
===========================================================================
  WARNING: UV-C RADIATION HAZARD

  The UV-C LED (275nm) emits germicidal ultraviolet radiation that is
  harmful to eyes and skin. The dose delivered inside the dome (90-180
  mJ/cm2) is 15-30x the ACGIH 8-hour exposure limit for humans.

  - NEVER look directly at the UV-C LED when powered.
  - ALWAYS ensure the dome is fully seated during sterilization cycles.
  - The hardware interlock (reed switch + magnet) prevents UV-C from
    activating without the dome in place, but YOU MUST verify this
    works correctly in Step 22 before regular use.
  - A red indicator LED on the base lights during the entire UV-C
    cycle. If the red LED is on, do NOT remove the dome.
  - If the safety interlock fails (UV-C activates with dome removed),
    IMMEDIATELY disconnect USB power and do not use until repaired.
===========================================================================
```

### Step 22: Test UV-C Safety Interlock

**What:** Verify the UV-C sterilization system and safety interlock function correctly. This is the most important test in the entire build.

**How:**

1. **Ensure the dome is seated on the base** (from Step 19).
2. **Press and hold the mode button for 3 seconds.** The red indicator LED on the base should light up, indicating a UV-C sterilization cycle has started. The UV-C LED inside the base is now active (you will not see its light -- 275nm is invisible to the human eye, and the dome blocks UV-C anyway).
3. **Verify the red LED stays on.** The 15-minute cycle timer (NE555) will automatically shut off UV-C after 15 minutes.
4. **TEST THE INTERLOCK: While the red LED is on (UV-C active), carefully lift the dome off the base.** The UV-C LED should **immediately** stop, and the red indicator LED should turn off. This confirms the hardware interlock (reed switch) is working -- removing the dome breaks the magnet-reed switch connection and cuts power to the UV-C LED.
5. **Replace the dome.** The UV-C cycle should NOT automatically restart (it requires a new 3-second button hold to start a new cycle).

**If the interlock fails** (UV-C continues after dome removal, or the red LED stays on with the dome removed): **STOP. Disconnect USB power immediately.** Check the reed switch position (must be within 5mm of the dome magnet when seated), verify the reed switch is wired in series (not bypassed), and check the magnet orientation. Do not use UV-C until the interlock is verified working.

**Check:** UV-C activates with 3-second button hold (red LED lights). UV-C stops immediately when dome is removed (red LED turns off). UV-C does not restart when dome is replaced (requires new button hold). This confirms the hardware safety interlock is functional.

---

## 10. Troubleshooting

### Common Issues and Fixes

| Problem | Likely Cause | Fix |
|---|---|---|
| **Dome doesn't seat properly on base** | Print tolerance too tight, or gasket not seated correctly | Sand the dome rim lightly with 200-grit sandpaper to add clearance (0.3-0.5mm needed). Verify gasket is fully seated in the groove and not bunched up. |
| **LEDs don't light up** | Incorrect LED polarity, cold solder joint, or bad connection to driver | Check LED polarity on every LED -- cathode mark must match PCB pad. Reflow any solder joints that look dull or cold. Verify the LED driver IC is receiving 5V. Test with a multimeter: 3.0-3.4V across each LED when powered. |
| **UV-C doesn't activate (red LED stays off)** | Reed switch not detecting dome magnet, or magnet too far from reed switch | Verify magnet is installed in dome rim pocket. Check reed switch position -- must be within 5mm of magnet when dome is seated. Test reed switch with multimeter: should show continuity when magnet is held close. Check that reed switch is wired in series with UV-C power. |
| **Dome fogs excessively (can't see inside)** | Micropore tape blocking too much airflow, or vents are covered | Verify all 4 exhaust vents and 8 intake vents have micropore tape applied (not solid tape or stickers). Micropore tape is semi-permeable -- if condensation is extreme, try using a single layer of tape instead of doubled-up tape. Some condensation is normal at 85-90% humidity. |
| **Button doesn't cycle modes** | Bad button connection, or button not making contact | Verify button wires are connected to the correct PCB pads. Test the button with a multimeter for continuity when pressed. If the button feels mushy, ensure it is fully seated in the 12mm cutout. |
| **Dome too dark for UV glow to show** | PETG filament too opaque, or too many perimeters | Try a different PETG brand with higher translucency. Print with 4 perimeters instead of 5 (1.6mm wall instead of 2.0mm -- slightly thinner but more translucent). Alternatively, use clear PETG and apply smoke tint spray (VHT Nite-Shades) for controllable tint level. |
| **UV-C activates without dome seated** | Reed switch stuck closed, or wiring bypasses interlock | **SAFETY ISSUE -- disconnect power immediately.** Check that the reed switch is normally-open type. Verify no metallic objects near the reed switch are holding it closed. Verify wiring: reed switch must be in series with UV-C power, not bypassed. Replace reed switch if stuck. |
| **Base warped (doesn't sit flat)** | Print bed not level, or part cooled unevenly | Reprint with a properly leveled bed. Use a heated bed at 70-80C for PETG. Ensure the print area is draft-free during printing. If minor warping, place the base on a flat surface and heat the bottom with a heat gun to gently flatten. |
| **Dome layers separating / delaminating** | Print temperature too low, or PETG moisture absorption | Increase nozzle temperature by 5-10C. Dry your PETG filament (4 hours at 65C in a food dehydrator or filament dryer). PETG absorbs moisture from the air, which causes poor layer adhesion and popping/bubbling during printing. |

### When to Reprint

- **Dome:** Reprint if layers are visibly separating, if the dome is significantly out of round (noticeable wobble when seated), or if the magnet pocket is damaged.
- **Base:** Reprint if warping prevents the base from sitting flat, if vent slots are clogged and cannot be cleared, or if screw bosses are cracked.
- **Platform:** Reprint if drain slots are clogged or the platform does not sit level in the base.
- **Vent caps:** Reprint if the snap-fit is too loose or too tight. Adjust scale by +/- 2% in your slicer to fine-tune the fit.

### Getting Help

- File issues and ask questions in the Void Blueprints repository
- Join the community discussion for build tips and troubleshooting help
- Share your completed build -- every printed Void is a contribution to the community

---

*Build Guide version: 1.0*
*Part of the Void Blueprints open-source package.*
