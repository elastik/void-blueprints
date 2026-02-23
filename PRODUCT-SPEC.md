# The Void -- Product Design Specification

> Technical specification for The Void cultivation dome and its variants.
> All design targets derived from SPECIES-REQUIREMENTS.md universal design envelope.
> This document is the engineering reference for prototyping, 3D printing, and injection molding.

---

## 1. Design Overview

### Product Identity

**The Void** is a UV-lit mushroom cultivation dome -- a sealed growing chamber that doubles as a living art piece. It houses a pre-inoculated substrate block (Void Pack) inside a smoked dome on a matte black base, illuminated by UV-A and blue LEDs. USB-C powered. No moving parts in the base model.

### Design Philosophy

1. **Functional cultivation chamber first.** Every aesthetic choice must serve or not compromise growing conditions.
2. **Living art piece.** The dome sits on a desk, shelf, or nightstand. It must look intentional, not like lab equipment.
3. **UV aesthetic defines the brand.** The purple glow under UV-A light IS the product experience.
4. **Simplicity scales down, intelligence scales up.** The base Void is dead simple (LEDs + vents). Complexity lives in Void Core.

### Variant Matrix

| Variant | Description | MSRP | Key Differences |
|---|---|---|---|
| **The Void** | Base cultivation dome. Smoked dome, matte black base, UV-A + blue LEDs, passive airflow, UV-C sterilization, USB-C power. Physical button for mode cycling. | $79 | No microcontroller (or ATtiny). No sensors. No fan. No humidifier. No camera. |
| **Void Core** | Smart dome upgrade. Adds Pi Zero W 2, BME280 sensor, piezo humidifier, PWM fan, camera module, Wi-Fi, app control. | $299 | Active humidity control. Active airflow. Programmable light modes. Timelapse camera. App integration. |
| **Dark Dome** | No-LED variant for bioluminescent species (Panellus stipticus). Same physical shell, no lighting electronics. | $49 | No LEDs. No UV-A, no blue, no UV-C. Passive airflow only. Opaque or clear dome option. |

### Overall Dimensions

**Validated dimensions: 8.0" (203mm) diameter x 10.0" (254mm) total height.**

Validation against species requirements:

| Constraint | Requirement | 8" x 10" Fit | Notes |
|---|---|---|---|
| Substrate block width | Custom 1-2 lb block, ~4.5-5" diameter | 1.5-1.75" clearance on each side | Adequate for lateral fruiting (oysters) |
| Lion's Mane fruiting body | Up to 4-8" diameter | Single fruit body fits; very large specimens may contact dome wall | Acceptable -- large fruit bodies are the success case |
| Oyster cluster spread | 4-6" lateral spread | Fits with clearance; multiple clusters may crowd | Position block so clusters grow upward |
| Reishi antler height | Antlers grow upward, typically 4-8" tall | ~5-6" vertical clearance above substrate surface | Adequate for typical antler growth |
| Shiitake cap diameter | 2-4" individual caps | Fits easily | No concerns |
| Panellus stipticus | Small fruiting bodies, caps up to 3cm | Fits easily | No concerns |
| Airflow volume | ~400 cubic inches chamber volume for passive FAE calculations | Sufficient for convective flow if vents are properly sized | See Section 4 |

**Dimension breakdown:**

| Component | Dimension | Notes |
|---|---|---|
| Total height | 10.0" (254mm) | Dome + base assembled |
| Total diameter | 8.0" (203mm) | Widest point at dome-base junction |
| Dome height | 6.5" (165mm) | From base top to dome apex |
| Base height | 3.5" (89mm) | Houses electronics, substrate platform, and airflow plenum |
| Dome inner diameter | 7.5" (190mm) | Wall thickness reduces usable interior |
| Substrate platform diameter | 5.5" (140mm) | Centered in base; sized for 1-2 lb Void Pack |
| Vertical clearance above substrate | ~5.5-6.0" (140-152mm) | From top of substrate block to dome interior apex |

### Chamber Volume

- Dome interior volume (hemisphere approximation): ~110 cubic inches (~1.8 liters)
- Effective growing chamber (above substrate): ~90-100 cubic inches (~1.5-1.6 liters)
- This small volume is both a feature (humidity retention) and a challenge (CO2 accumulation)

---

## 2. Dome Shell

### Geometry

**Truncated hemisphere with vertical sidewall transition.** The dome is not a pure hemisphere -- it features a short vertical sidewall (approximately 1.0" / 25mm) at the base that transitions into a hemispherical curve. This geometry provides:

1. Maximum interior volume at the widest point where mushroom clusters grow laterally
2. Clean visual silhouette -- more "dome" than "ball"
3. A defined seating lip for the dome-to-base interface
4. Better airflow -- vertical walls at the base allow vents to channel air upward along the dome interior

### Material Options

| Material | Method | Pros | Cons | Recommended For |
|---|---|---|---|---|
| **Smoked polycarbonate** | Injection molding | Excellent impact resistance, natural UV blocking, high clarity with smoke tint, premium feel | Higher mold cost | Production Void (Kickstarter fulfillment) |
| **Smoked PETG** | 3D printing (FDM/SLA) | Printable, good humidity resistance, tintable, adequate clarity | Layer lines (FDM), less impact-resistant than PC | Void Blueprints (community prints), prototyping |
| **Smoked acrylic (PMMA)** | Laser cut + thermoform, or injection mold | Excellent optical clarity, good UV blocking, lightweight | Brittle, scratches easily | Budget production option |

**Primary specification: Smoked polycarbonate for production units.**

### Wall Thickness

| Parameter | Value | Rationale |
|---|---|---|
| Dome wall thickness | 2.0mm (0.079") | Structural integrity + light diffusion. Thin enough for UV-A glow transmission, thick enough to resist accidental drops. |
| Smoke tint level | 50-60% visible light transmission (VLT) | Dark enough to create dramatic UV glow contrast, light enough to see mushrooms growing inside under ambient room light. |
| UV-C opacity | 100% blocked below 300nm | Polycarbonate naturally blocks UV-C. This is the primary safety barrier -- the dome IS the UV-C enclosure. |
| UV-A transmission | 30-50% at 395nm | Allows UV-A glow to be visible from outside the dome. Polycarbonate transmits adequately at 395nm. |

### Finish

- **Exterior:** Smooth, high-gloss smoked tint. The dome should look like smoked glass.
- **Interior:** Smooth. No texture that could trap moisture or contaminants.
- **Anti-fog consideration:** Interior condensation is expected at 85-90% RH. A hydrophilic anti-fog coating (or design that promotes sheeting rather than droplets) prevents obscured viewing. Evaluate anti-fog coatings rated for high-humidity environments during prototyping.

### Dome-to-Base Interface

**Friction-fit with alignment notch.**

- The dome seats into a recessed channel (2mm deep) machined/molded into the base top surface
- A single alignment notch ensures consistent dome orientation (important for vent alignment)
- Friction fit is snug enough to maintain seal but loose enough for easy one-hand removal
- No locking mechanism -- the dome lifts straight off for substrate block swaps
- A silicone gasket ring (1.5mm) in the base channel creates a humidity seal while allowing easy removal

**Magnetic reed switch integration:** A small magnet (6mm x 2mm neodymium disc) is embedded in the dome's seating lip. A corresponding reed switch in the base detects dome presence for the UV-C safety interlock (see Section 7). The dome must be fully seated for UV-C to activate.

---

## 3. Base Unit

### Dimensions

| Parameter | Value | Notes |
|---|---|---|
| Outer diameter | 8.0" (203mm) | Matches dome diameter for flush fit |
| Height | 3.5" (89mm) | Houses substrate platform + electronics + airflow plenum |
| Base footprint | 8.0" diameter circle | Flat bottom for desk stability |
| Weight (empty, base only) | ~350-450g target | Heavy enough for stability, light enough for shipping |

### Material

**Matte black ABS (injection molded) or PETG (3D printed).**

- ABS for production: excellent finish, paintable, dimensionally stable
- PETG for Void Blueprints: printable, humidity-resistant, adequate strength
- Finish: matte black, soft-touch texture on exterior surfaces
- Interior surfaces: smooth for easy cleaning

### Internal Layout (Top to Bottom)

```
    +----- Dome seating channel (top rim) -----+
    |                                           |
    |  [Substrate platform - raised 0.5"]       |
    |  [  5.5" diameter, with drain slots  ]    |
    |                                           |
    |--- LED ring (UV-A + Blue) mounted here ---|
    |                                           |
    |  [Airflow plenum - 1.0" height]           |
    |  [  Intake vents around perimeter    ]    |
    |                                           |
    |--- Electronics shelf ----------------------|
    |  [LED driver / UV-C control / button]     |
    |  [USB-C port at rear]                     |
    |                                           |
    +-- Base bottom (flat, with rubber feet) ----+
```

### Substrate Platform

| Parameter | Value | Notes |
|---|---|---|
| Platform diameter | 5.5" (140mm) | Centered; sized for custom 1-2 lb Void Pack blocks |
| Platform depth (recessed) | 0.5" (13mm) | Shallow well to center the block and catch drainage |
| Surface | Perforated / slotted | 4-6 drain slots for excess moisture to drain into airflow plenum below |
| Rim height | 0.25" (6mm) raised lip | Prevents block from sliding during dome removal |

### Cable Routing

- USB-C port location: rear-center of base, recessed 3mm into the housing
- Internal cable routing: flat flex cable from USB-C port to electronics shelf
- Cable exit: downward-facing port so cable routes down to desk surface cleanly
- Strain relief: molded into the port recess

### Stability

- Four silicone rubber feet (12mm diameter, 3mm tall) on base bottom
- Total assembled weight target: 600-800g (dome + base, no substrate)
- Center of gravity is low (electronics and base mass are below midpoint)
- Stable on typical desk surfaces; no risk of tipping from dome removal

---

## 4. Airflow System (Fresh Air Exchange)

### Design Challenge

CO2 management is the #1 engineering challenge for the dome. From SPECIES-REQUIREMENTS.md:

- Lion's Mane (flagship): requires < 800 ppm CO2, 5-8 air exchanges/hour
- Blue/Pink Oyster: requires < 800-1000 ppm CO2, 4-6 exchanges/hour
- Chamber volume is only ~1.5-1.6 liters of effective growing space
- A respiring substrate block in this small volume accumulates CO2 rapidly
- The dome must exchange air passively (no fan in base Void) while maintaining 85-90% RH

### Approach: Passive Convective Airflow

The base Void uses **passive convective (chimney effect) airflow** -- warm, CO2-rich, humid air rises and exits through upper dome vents, while cool fresh air enters through lower base intake vents.

**Why passive works:** The substrate block generates metabolic heat (0.5-2 degrees F above ambient), creating a temperature differential that drives natural convection. The dome's vertical profile (10" tall) provides sufficient chimney height for meaningful convective flow.

### Vent Design

#### Intake Vents (Base)

| Parameter | Value | Notes |
|---|---|---|
| Location | Lower perimeter of base unit, evenly spaced | 360-degree intake for omnidirectional fresh air |
| Quantity | 8 slots | Evenly distributed around circumference |
| Individual slot size | 15mm wide x 5mm tall (0.6" x 0.2") | Small enough for contamination barrier, large enough for airflow |
| Total intake area | ~600 mm2 (~0.93 in2) | Sized for target exchange rate (see calculations below) |
| Filter | Micropore tape (3M Micropore or equivalent) | Blocks contaminant spores (>0.3 um) while allowing air passage |
| Adjustable | No (base Void) / Yes (Void Core -- motorized damper) | Base Void has fixed vents; simplicity over tunability |

#### Exhaust Vents (Dome Upper)

| Parameter | Value | Notes |
|---|---|---|
| Location | Upper third of dome, near apex | Warm CO2-rich air naturally rises here |
| Quantity | 4 vent holes | Evenly spaced around dome circumference, ~60 degrees from apex |
| Individual hole diameter | 12mm (0.47") | Sized for exhaust flow rate |
| Total exhaust area | ~452 mm2 (~0.70 in2) | Slightly less than intake -- creates slight positive pressure tendency |
| Filter | Micropore tape (replaceable) | User-accessible for replacement; contaminant barrier |
| Cover design | Recessed ring with snap-in filter disc | Clean exterior appearance; easy filter swap |

#### Airflow Rate Calculation

Target: 4-6 air exchanges per hour (satisfies all species except antler reishi).

- Chamber volume: ~1.6 liters
- At 4 exchanges/hour: 6.4 liters/hour = 107 ml/min = 1.78 ml/sec
- At 6 exchanges/hour: 9.6 liters/hour = 160 ml/min = 2.67 ml/sec

Natural convection through the vent openings at a 1-2 degree F temperature differential and 10" chimney height produces estimated flow rates of 2-5 ml/sec through the specified vent areas. This falls within the target range.

**Uncertainty note:** These are engineering estimates based on simplified chimney effect calculations. Actual airflow depends on ambient conditions (room air currents, temperature, barometric pressure), vent geometry, and micropore tape resistance. Prototype testing with CO2 monitoring is essential to validate vent sizing and may require iteration.

### Airflow Path

```
CROSS-SECTION VIEW (not to scale):

              Exhaust vents (x4)
                 \   |   /
          +-------[V][V]--------+
         /    Dome (smoked PC)    \
        /                          \
       |   ~~~~~~~~~~~~~~~~~~~~~~~~ |   <- Humid air layer
       |                            |
       |    +------------------+    |
       |    | Mushroom fruiting|    |
       |    |    bodies grow   |    |
       |    |     upward       |    |
       |    +------------------+    |
       |    |  Void Pack block |    |
       |    | (substrate 4.5") |    |
       |    +--------+---------+    |
       |             |drain slots   |
       +====[LED RING (UV-A+Blue)]===+  <- Dome/base junction
       |                            |
       |   [Airflow plenum 1.0"]    |
       |                            |
  -->[V]  Intake      Intake   [V]<--   <- Base intake vents (x8)
       |   vents       vents        |      Fresh air enters
       |                            |
       |  [Electronics: LED driver] |
       |  [UV-C ctrl] [Button]      |
       |        [USB-C port]        |
       +----(rubber feet)x4---------+
       ================================   <- Desk surface
```

**Flow path:** Fresh air enters through base intake vents -> passes through airflow plenum beneath substrate platform -> rises through drain slots in platform -> passes over/around substrate block and fruiting bodies -> warm CO2-rich air rises to dome apex -> exits through upper dome exhaust vents.

### Void Core Upgrade: Active Airflow

| Parameter | Value | Notes |
|---|---|---|
| Fan type | 30mm axial fan (5V DC) | Mounted in base airflow plenum |
| Fan speed | PWM controlled, 0-5000 RPM | App-adjustable; auto-mode based on CO2 sensor reading |
| Noise level | < 25 dB at typical operating speed | Near-silent operation |
| Air exchange rate | 4-12 exchanges/hour (adjustable) | Higher rates available for CO2-sensitive species |
| CO2 sensor | SCD30 or SCD40 (Sensirion) via BME280 combo | Triggers fan speed increase when CO2 > 600 ppm |

### Reishi Antler Mode

For reishi antler form cultivation (requires > 2000 ppm CO2), users should cover or tape over 6 of 8 base intake vents and 3 of 4 dome exhaust vents. This reduces air exchange to ~1 exchange/hour, allowing CO2 to accumulate.

- **Base Void:** Manual vent covering with included silicone plugs (4 plugs included with Reishi Void Pack)
- **Void Core:** App-controlled motorized dampers on intake and exhaust vents

---

## 5. Humidity Management

### Design Target

**85-90% RH** inside the dome during active fruiting. This satisfies all target species:

| Species | Required RH | 85-90% Target | Status |
|---|---|---|---|
| Lion's Mane | 85-95% | Within range | OK |
| Blue Oyster | 85-95% | Within range | OK |
| Pink Oyster | 85-95% (min 70%) | Within range | OK |
| Shiitake | 85-95% early, 60-80% late | Within range for early; naturally drops as vents exchange air in late stage | OK |
| Reishi | 80-90% | Within range | OK |
| Panellus stipticus | 85-95% | Within range | OK |

### Base Void: Passive Humidity (No Moving Parts)

The base Void maintains humidity through three mechanisms:

1. **Substrate moisture:** The Void Pack substrate block is hydrated to 60-65% moisture content. As the mycelium respires, it releases moisture vapor into the chamber. A 1-2 lb block contains approximately 300-600 ml of water, providing sustained humidity for the full grow cycle (2-4 weeks for most species).

2. **Sealed dome retention:** The smoked polycarbonate dome with silicone gasket creates a near-sealed environment. Humidity loss occurs only through the sized vents, which are restricted by micropore tape. This natural retention keeps RH high.

3. **Vent sizing balance:** The vents are sized to allow adequate FAE (4-6 exchanges/hour) while losing minimal humidity. Micropore tape on vents acts as a partial humidity barrier -- air passes through but water vapor transport is reduced. The vent areas specified in Section 4 were designed to balance CO2 removal against humidity retention.

**Expected behavior:** In a typical indoor environment (68-75 degrees F, 40-60% ambient RH), the dome interior should stabilize at 80-92% RH with a fresh Void Pack. As the substrate dries over the grow cycle, RH gradually decreases. For multi-flush grows, users soak the substrate block between flushes to rehydrate.

**Condensation management:** At 85-90% RH, condensation will form on the dome interior, especially in the upper dome where warm moist air meets the cooler dome surface. This is normal and expected. The dome geometry (curved interior) encourages condensation droplets to run down the walls and return to the base rather than dripping directly onto fruiting bodies. The anti-fog coating (Section 2) promotes sheeting over beading for better visibility.

### Void Core: Active Humidity Control

| Parameter | Value | Notes |
|---|---|---|
| Humidifier type | Piezoelectric ultrasonic mist disc (20mm, 113 KHz) | Low-power, fine mist, no heat |
| Reservoir | 100 ml integrated reservoir in base | Refill via pour port on base exterior; lasts ~3-5 days at normal operation |
| Mist output | 20-40 ml/hour (adjustable via PWM) | Triggered by BME280 humidity reading |
| Control logic | Maintain setpoint +/- 2% RH | Default 88% RH; user-adjustable via app (80-95% range) |
| Fill indicator | LED color change or app notification when reservoir low | Prevents dry-run damage to piezo disc |

### Humidity Monitoring (Void Core Only)

The BME280 sensor (temperature + humidity + barometric pressure) provides real-time RH data to the Pi Zero W 2. The control loop:

1. Read humidity every 30 seconds
2. If RH < (setpoint - 2%), activate mist disc at duty cycle proportional to deficit
3. If RH > (setpoint + 2%), pause mist disc; optionally increase fan speed briefly to vent excess
4. Log data for timelapse correlation and grow analytics in the Void app

---

## 6. Access & Maintenance

### Dome Removal: Lift-Off Design

The dome **lifts straight up and off** the base. No hinge, no twist-lock, no bayonet mount.

**Rationale:**
- Simplest possible mechanism (no moving parts, no wear points)
- One-hand operation: grip dome at widest point, lift straight up
- Full 360-degree access to the interior -- no hinge blocking one side
- Easy to clean -- dome is completely separable
- Easiest manufacturing (no hinge hardware, no alignment mechanisms)
- Compatible with UV-C safety interlock (magnetic reed switch detects dome presence)

### Substrate Block Replacement Workflow

**Standard grow cycle (base Void):**

1. Receive Void Pack (pre-colonized substrate block in sealed bag)
2. Remove Void Pack from bag
3. Lift dome off base
4. Place Void Pack on substrate platform (centered in recessed well)
5. Place dome back on base (align notch)
6. Press button to select light mode (UV-A glow, blue fruiting light, or both)
7. Wait 7-21 days (species dependent) -- mushrooms fruit
8. Lift dome to harvest mushrooms
9. Replace dome; continue for additional flushes (soak block between flushes)
10. When spent, remove old block
11. (Optional) Press and hold button for UV-C sterilization cycle (15 minutes, dome must be seated)
12. Place new Void Pack; repeat from step 5

**Between-grow cleaning:**

1. Remove spent substrate block; discard or compost
2. Lift dome off base
3. Wipe dome interior with damp cloth (mild soap if needed)
4. Wipe substrate platform and base interior
5. Replace micropore tape on vents if contaminated or clogged (every 2-3 grow cycles)
6. (Optional) Run UV-C sterilization cycle with dome seated and chamber empty
7. Place new Void Pack

### Micropore Tape Replacement

- Intake vent filters: accessed from base exterior; peel old tape, apply new strip
- Exhaust vent filters: accessed from dome exterior; snap-out filter disc, replace tape, snap back in
- Replacement tape included in Void Pack packaging (enough for one grow cycle)
- Also available separately or in bulk from standard suppliers (3M Micropore surgical tape)

### Maintenance Schedule

| Task | Frequency | Difficulty |
|---|---|---|
| Harvest mushrooms | Every 7-21 days during fruiting | Easy -- lift dome, cut/twist fruit bodies |
| Soak substrate block (between flushes) | Every 10-14 days | Easy -- remove block, soak in water 12-24 hours, return |
| Replace Void Pack | Every 1-3 months (species dependent) | Easy -- swap blocks |
| Wipe dome interior | Between grows | Easy -- damp cloth |
| Replace micropore tape on vents | Every 2-3 grows | Easy -- peel and stick |
| UV-C sterilization cycle | Between grows (recommended) | Easy -- press and hold button, wait 15 min |
| Refill humidifier reservoir (Void Core) | Every 3-5 days | Easy -- pour water into fill port |

### Dark Dome Variant Notes

The Dark Dome follows the same physical design as The Void with these differences:

- **No LED ring:** The base has no UV-A, blue, or UV-C LEDs. The LED ring position is left empty (cost savings).
- **No electronics:** No LED driver, no button, no USB-C port. The Dark Dome is a purely passive growing chamber.
- **No UV-C sterilization:** Users clean the Dark Dome manually between grows (wipe down with dilute hydrogen peroxide or isopropyl alcohol).
- **Dome tint option:** May be offered in clear (untinted) polycarbonate for maximum bioluminescence visibility, or standard smoked tint. Evaluate during prototyping which shows bioluminescent glow better.
- **All passive systems identical:** Dome shell, base unit, substrate platform, airflow vents, humidity management -- all same as base Void.
- **Lower price ($49)** reflects removal of all electronic components.

---

## Cross-Section Diagram -- Full Assembly

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
                  |  || BODIES  ||  |        (Lion's Mane tendrils, oyster shelves, etc.)
                  |  +===========+  |
                  |  |  VOID     |  |     <- Void Pack substrate block
                  |  |  PACK     |  |        (~4.5" W x 3" H, 1-2 lbs)
                  |  |  BLOCK    |  |
                  |  +-----+-----+  |
                  |  | platform  |  |     <- Substrate platform (5.5" dia, perforated)
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

Legend:
  ExV  = Exhaust vent (dome, upper)       InV = Intake vent (base, lower)
  ^    = UV-C LED (points upward through platform drain slots into chamber)
  LED RING = UV-A + Blue LEDs at dome/base junction, pointing up into dome
  ~~~ = Humid air / mist zone
```

**Key dimensions in cross-section:**
- Overall: 8.0" wide x 10.0" tall
- Dome: 6.5" tall (including 1.0" vertical sidewall)
- Base: 3.5" tall
- Substrate clearance above block: ~5.5-6.0" to dome apex
- LED ring position: at dome/base junction, angled upward at ~30 degrees into dome interior
- UV-C LED position: in electronics bay, pointing upward through platform drain slots

---

## 7. Lighting System

The dome uses three distinct lighting subsystems serving different purposes. The base Void includes all three; the Dark Dome includes none.

### 7.1 UV-A Aesthetic Lighting (395nm)

The brand-defining purple glow. Runs continuously during the 12-hour light cycle.

| Parameter | Specification | Notes |
|---|---|---|
| **Wavelength** | 395nm | Strong visible purple/violet; cost-effective; good UV-A transmission through smoked PC dome |
| **LED type** | 5050 SMD UV-A LEDs | Standard package, widely available, easy to solder |
| **Quantity** | 6 LEDs in ring configuration | Evenly spaced around LED ring at dome/base junction |
| **Power per LED** | 60-80 mW each at 20mA | Low-power; ample for 8" dome illumination |
| **Total UV-A power** | ~0.4-0.5W | Minimal power draw |
| **Beam angle** | 120 degrees | Wide coverage; LEDs angled 30 degrees upward into dome |
| **Voltage** | 3.0-3.4V forward (driven from 5V with resistor) | Standard UV-A LED specs |
| **Placement** | LED ring at dome/base junction, pointing upward | Uplighting creates dramatic shadows on mushroom forms |
| **Operation** | 12h on / 12h off (timer circuit) | Matches fruiting light cycle |

**Dark Dome:** No UV-A LEDs. Position left empty on PCB (or Dark Dome uses simplified PCB without LED pads).

### 7.2 Blue Fruiting Light (450nm)

Provides the primary photomorphogenic stimulus that triggers pinning and fruiting in all target species.

| Parameter | Specification | Notes |
|---|---|---|
| **Wavelength** | 450nm (royal blue) | Peak of mushroom blue-light photoreceptor response (430-470nm) |
| **LED type** | 5050 SMD blue LEDs | Same package as UV-A for unified ring design |
| **Quantity** | 6 LEDs interleaved with UV-A in ring | Alternating UV-A / Blue around the ring (12 LEDs total in ring) |
| **Power per LED** | 60-80 mW each at 20mA | Sufficient for 500+ lux at substrate surface in small dome |
| **Total blue power** | ~0.4-0.5W | Low power; high efficacy in small chamber |
| **Estimated lux at substrate** | 500-800 lux | Satisfies all species minimum (200-2000 lux range); see SPECIES-REQUIREMENTS.md |
| **Operation** | 12h on / 12h off (same timer as UV-A) | Combined on single timer circuit |

**Species light coverage at 500-800 lux:**

| Species | Required Lux | 500-800 Provided | Status |
|---|---|---|---|
| Lion's Mane | 200-500 | Above minimum | OK (at upper end of range) |
| Blue Oyster | 500-1000 | Within range | OK |
| Pink Oyster | 500-1000 | Within range | OK |
| Shiitake | 500-2000 | At low end | Adequate for basic fruiting |
| Reishi | 750-1500 | At low end | Adequate for basic fruiting |

**Note:** Shiitake and Reishi have higher light requirements. The base Void provides adequate (not optimal) light for these species. The Void Core could boost light intensity through PWM control and supplemental LEDs.

### 7.3 UV-C Sterilization (275nm)

Germicidal sterilization between grows. ONLY activates when dome is sealed and user deliberately triggers the cycle.

| Parameter | Specification | Notes |
|---|---|---|
| **Wavelength** | 275nm | Best commercial UV-C LED availability; excellent germicidal effectiveness |
| **LED type** | 3535 SMD UV-C LED (Seoul Viosys or equivalent) | Standard UV-C LED package |
| **Quantity** | 1 LED | Single LED sufficient for small dome volume |
| **Electrical input** | 1.0-1.5W | Typical UV-C LED power consumption |
| **UV-C output** | 30-40mW radiant power | 2-4% wall-plug efficiency (typical for UV-C LEDs) |
| **Beam angle** | 120 degrees | Wide angle for maximum surface coverage |
| **Placement** | Electronics bay, pointing upward through substrate platform drain slots | Illuminates dome interior from below |
| **Target dose** | 100 mJ/cm2 | Achieves 99% kill of Trichoderma (primary mushroom contaminant) |
| **Cycle time** | 15 minutes (auto-shutoff) | 0.1 mW/cm2 x 900s = 90 mJ/cm2; meets target with margin for geometry |
| **Extended cycle** | 30 minutes (optional, Void Core app selection) | ~180 mJ/cm2 for more resistant contaminants (Aspergillus spp.) |
| **Lifetime** | ~9,000 hours | Far exceeds usage (15 min per grow cycle = decades of service) |

### 7.4 UV-C Safety Interlock System

UV-C radiation at the dome's target dose (90-180 mJ/cm2) is 15-30x the ACGIH 8-hour exposure limit for humans. The safety interlock is not optional -- it is a critical safety system.

| Safety Feature | Implementation | Failure Mode |
|---|---|---|
| **Magnetic dome-presence sensor** | 6mm neodymium disc magnet in dome lip + reed switch in base | UV-C cannot activate if dome is removed or not fully seated. Reed switch is normally-open; only closes when magnet is within 5mm. |
| **Hardware interlock (not software)** | Reed switch is wired in series with UV-C LED power line | Even if microcontroller fails or is absent (base Void), UV-C physically cannot receive power without dome present. Pure hardware safety. |
| **Deliberate activation only** | Press-and-hold button for 3 seconds to start UV-C cycle | Prevents accidental activation. Button tap cycles light modes; only sustained press starts sterilization. |
| **Hardware timer auto-shutoff** | NE555 or similar timer IC limits UV-C to 15 minutes maximum | Even without microcontroller, UV-C automatically stops. No software dependency. |
| **Red LED indicator** | Dedicated red LED on base exterior, visible from all sides | Lit during entire UV-C cycle. Users know not to remove dome. |
| **UV-C opaque dome** | Polycarbonate dome blocks 100% of UV-C below 300nm | Dome material IS the primary radiation enclosure. Standard PC blocks UV-C inherently. |
| **Warning label** | Permanent label on base: "CAUTION: UV-C germicidal light. Do not operate without dome in place." | Required for consumer product safety compliance. |
| **Void Core: app confirmation** | Smart version requires tap-to-confirm in app before UV-C starts | Additional software layer on top of hardware interlock. Not a replacement. |

**Key design principle:** All UV-C safety mechanisms are hardware-based. The base Void has no microcontroller, so safety cannot depend on software. The magnetic interlock + hardware timer ensure UV-C is safe even if every other component fails.

### 7.5 Light Modes

**Base Void (physical button cycles through modes):**

| Mode | UV-A (395nm) | Blue (450nm) | UV-C (275nm) | Trigger |
|---|---|---|---|---|
| 1. Void Glow | ON | ON | OFF | Button tap (default) |
| 2. UV Only | ON | OFF | OFF | Button tap |
| 3. Blue Only | OFF | ON | OFF | Button tap |
| 4. Off | OFF | OFF | OFF | Button tap |
| 5. Sterilize | OFF | OFF | ON (15 min) | Button hold 3 sec (dome must be seated) |

Mode cycling: tap button to advance 1 -> 2 -> 3 -> 4 -> 1. The 12h timer applies to modes 1-3 (auto-off after 12h, auto-on after 12h dark). Mode 5 (sterilize) is independent of the cycle timer.

**Void Core (app-controlled, all of the above plus):**

| Mode | Description | LEDs Used |
|---|---|---|
| Deep Space | Slow UV-A pulse with deep blue undertone | UV-A + Blue (PWM dimming) |
| Bioluminescence | Minimal light, enhances natural glow for Panellus | Blue at 5% duty cycle |
| Aurora | Slow color sweep across UV-A intensity levels | UV-A (PWM sweep) |
| Blacklight | Maximum UV-A intensity | UV-A at 100% |
| Music Sync | Beat-reactive UV-A + Blue flashing | UV-A + Blue (microphone input) |
| Custom | User-defined intensity and timing per channel | All channels, app-configured |

### 7.6 RGB LED System (Void Core Only)

| Parameter | Specification | Notes |
|---|---|---|
| **LED type** | WS2812B (addressable RGB, 5050 package) | Individual color control per LED; single data line |
| **Quantity** | 8 LEDs in secondary ring | Separate from UV-A/Blue ring; mounted slightly lower in base |
| **Power per LED** | 60mA max (full white) | Typical draw at accent brightness: 20-30mA each |
| **Total RGB power** | 0.5-1.5W (depending on mode) | Full white all-on = 2.4W max; typical accent modes much lower |
| **Data protocol** | Single-wire NZR (WS2812B native) | One GPIO pin from Pi Zero W 2 |
| **Purpose** | Color accent modes (Aurora, Music Sync, etc.), status indication | Adds color variety beyond UV-A purple |

**Not included in base Void.** RGB is a Void Core feature only. Base Void's $79 MSRP requires minimal component cost.

---

## 8. Control Electronics

### 8.1 Base Void: Minimal Electronics

The base Void uses no microcontroller (or optionally an ATtiny85 for mode memory). The design philosophy: **fewer components = lower cost, higher reliability, lower failure rate.**

| Component | Purpose | Notes |
|---|---|---|
| **USB-C PD sink IC** | Negotiate 5V from any USB-C source | CH224K or IP2721; tiny SOT-23 package; ensures 5V delivery from USB-C |
| **LED driver (constant current)** | Drive UV-A + Blue LED ring | PT4115 or similar; single IC drives 12 LEDs in 2 strings of 6 |
| **555 timer IC (x2)** | (1) 12h on/off light cycle, (2) 15-min UV-C auto-shutoff | NE555 or LMC555 (CMOS for lower power). Hardware timing, no software dependency. |
| **Momentary push button** | Mode cycling + UV-C activation (3-sec hold) | Waterproof silicone-cap tactile switch; mounted on base exterior |
| **Reed switch** | UV-C safety interlock (dome presence detection) | Normally-open; closes when dome magnet is within 5mm |
| **Red indicator LED** | UV-C cycle active indicator | Standard 3mm red LED + resistor |
| **UV-C LED** | Sterilization | Seoul Viosys 275nm, 3535 package |
| **Decoupling capacitors** | Power filtering | Standard 100uF + 0.1uF ceramic |
| **Resistors** | LED current limiting, timer configuration | Standard 1/4W through-hole or 0805 SMD |

**Optional: ATtiny85 microcontroller** ($0.50-1.00 in volume). Adds mode memory (remembers last selected mode after power cycle) and enables button hold detection for UV-C. If the 555 timer + discrete logic approach is too cumbersome for button-hold detection, the ATtiny85 replaces both 555 timers and the discrete logic with a single 8-pin IC. Total firmware: ~500 bytes.

**Total component count (base Void): 15-25 components.** This is a deliberately simple circuit. The entire electronics assembly can fit on a single 2-layer PCB, 50mm x 30mm.

### 8.2 Void Core: Smart Electronics

The Void Core adds intelligence, sensors, and connectivity on top of the base Void electronics.

| Component | Purpose | Specification |
|---|---|---|
| **Raspberry Pi Zero W 2** | Main controller | Quad-core ARM, Wi-Fi, Bluetooth, 512MB RAM, USB OTG, CSI camera port |
| **BME280 sensor** | Temperature + humidity + barometric pressure | I2C interface; +/- 1 degree C, +/- 3% RH accuracy |
| **SCD40 CO2 sensor** | CO2 concentration monitoring | I2C; range 400-5000 ppm; +/- 50 ppm accuracy. Optional add-on for advanced growers. |
| **Piezoelectric humidifier disc** | Active mist generation | 20mm, 113 KHz; 5V DC; ~1.5W when active |
| **30mm axial fan** | Active airflow (FAE) | 5V DC, PWM speed control, <25 dB at typical speed |
| **Camera module** | Timelapse photography | Pi Zero camera module (5MP or 8MP); ribbon cable to CSI port |
| **WS2812B RGB ring** | Color accent lighting | 8 addressable LEDs; single data pin |
| **microSD card** | OS + timelapse storage | 16GB minimum; Raspberry Pi OS Lite |
| **USB-C hub/splitter** | Power distribution to Pi + base electronics | Internal USB-C to micro-USB adapter for Pi power |
| **Motorized damper (x2)** | Adjustable intake/exhaust vent aperture | Small servo or solenoid; app-controlled vent sizing |

**Communication:** Wi-Fi (2.4 GHz) to the Void app (web-based dashboard). BLE for initial setup/pairing.

**Software (out of scope for this spec):** The Void Core runs a Python-based control daemon on Raspberry Pi OS Lite. Firmware design is a separate specification document.

### 8.3 Wiring Architecture Description

**Base Void:**
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

**Void Core (adds to above):**
```
5V rail
    |
    +---> [Pi Zero W 2] ---> I2C bus ---> [BME280] + [SCD40]
    |         |
    |         +---> CSI ---> [Camera module]
    |         |
    |         +---> GPIO ---> [WS2812B data]
    |         |
    |         +---> PWM ---> [Fan speed control]
    |         |
    |         +---> GPIO ---> [Humidifier on/off]
    |         |
    |         +---> GPIO ---> [Motorized dampers]
    |         |
    |         +---> WiFi ---> [Void app]
    |
    +---> [Piezo humidifier driver] ---> [Humidifier disc]
    |
    +---> [Fan] (5V, PWM from Pi)
```

---

## 9. Power Architecture

### 9.1 USB-C Power Input

| Parameter | Specification | Notes |
|---|---|---|
| **Connector** | USB Type-C receptacle | Rear-center of base |
| **Negotiated voltage** | 5V (USB 2.0 default) | Base Void needs only 5V/500mA minimum |
| **PD negotiation** | CH224K sink IC (base Void: 5V only) | Simple, no PD negotiation needed for base -- just 5V default |
| **Void Core PD** | 5V/3A (15W) via USB-C PD | Pi Zero + sensors + fan + humidifier need more current |
| **Cable** | USB-C to USB-A or USB-C to USB-C (user-supplied) | Standard cables; any USB charger 5V/1A+ works for base Void |

### 9.2 Power Budget -- Base Void

| Component | Voltage | Current (typ) | Current (max) | Power (typ) | Power (max) |
|---|---|---|---|---|---|
| UV-A LEDs (6x 395nm) | 3.2V via 5V | 120mA | 150mA | 0.40W | 0.50W |
| Blue LEDs (6x 450nm) | 3.0V via 5V | 120mA | 150mA | 0.36W | 0.45W |
| LED driver IC | 5V | 10mA | 15mA | 0.05W | 0.08W |
| 555 timer ICs (x2) | 5V | 2mA | 4mA | 0.01W | 0.02W |
| UV-C LED (when active) | 6.5V via 5V boost | 250mA | 350mA | 1.25W | 1.75W |
| Red indicator LED | 5V | 10mA | 15mA | 0.05W | 0.08W |
| USB-C PD sink IC | 5V | 1mA | 2mA | 0.01W | 0.01W |
| Button + reed switch | -- | negligible | negligible | -- | -- |
| **TOTAL (normal grow)** | | **~253mA** | **~321mA** | **~0.83W** | **~1.05W** |
| **TOTAL (UV-C active)** | | **~263mA** | **~371mA** | **~1.32W** | **~1.85W** |

**Base Void power draw: 0.8-1.1W during normal growing (lights on). Well under the 5W target.** Even with UV-C active, total is under 2W. This is comfortably within USB 2.0's 500mA/2.5W limit.

**Note:** UV-A and UV-C are never on simultaneously. UV-C only runs between grows when the dome is sealed and lights are off. So the real peak is UV-C + red indicator = ~1.3W, not UV-A + Blue + UV-C combined.

### 9.3 Power Budget -- Void Core

| Component | Voltage | Current (typ) | Current (max) | Power (typ) | Power (max) |
|---|---|---|---|---|---|
| All base Void components | 5V | 253mA | 321mA | 0.83W | 1.05W |
| Raspberry Pi Zero W 2 | 5V | 300mA | 500mA | 1.50W | 2.50W |
| BME280 sensor | 3.3V (from Pi) | 1mA | 2mA | 0.003W | 0.01W |
| SCD40 CO2 sensor (optional) | 3.3V (from Pi) | 15mA | 20mA | 0.05W | 0.07W |
| Piezo humidifier | 5V | 300mA | 400mA | 1.50W | 2.00W |
| 30mm fan | 5V | 80mA | 150mA | 0.40W | 0.75W |
| WS2812B RGB ring (8x) | 5V | 160mA | 480mA | 0.80W | 2.40W |
| Camera module | 3.3V (from Pi) | 50mA | 100mA | 0.17W | 0.33W |
| Motorized dampers (x2) | 5V | 50mA | 150mA | 0.25W | 0.75W |
| **TOTAL (normal grow)** | | **~1,209mA** | | **~5.5W** | |
| **TOTAL (all active)** | | | **~2,123mA** | | **~9.9W** |

**Void Core typical power: ~5.5W. Peak (all systems active): ~10W.** Requires USB-C PD at 5V/3A (15W) for headroom. Standard USB 2.0 is insufficient for Void Core.

### 9.4 Power Protection

| Protection | Implementation | Notes |
|---|---|---|
| **Overcurrent** | Resettable PTC fuse (500mA for base Void; 2A for Void Core) | Protects against short circuits. Self-resetting after fault clears. |
| **Reverse polarity** | Not applicable (USB-C connector is keyed) | USB-C physical connector prevents reverse insertion |
| **ESD protection** | TVS diode on USB-C VBUS line | Standard ESD protection for consumer electronics |
| **Overvoltage** | Zener clamp at 5.5V on VBUS rail | Protects against non-compliant chargers delivering >5V |

### 9.5 Power States

| State | Components Active | Power Draw | Duration |
|---|---|---|---|
| **Off** | None (USB disconnected or mode 4) | 0W | -- |
| **Standby** | 555 timer only (during 12h dark period) | <0.01W | 12 hours |
| **Growing (lights on)** | UV-A + Blue LEDs + timer | ~0.8-1.1W | 12 hours |
| **Sterilizing** | UV-C LED + red indicator + timer | ~1.3W | 15 minutes |
| **Void Core idle** | Pi Zero + sensors (lights in dark period) | ~1.6W | 12 hours |
| **Void Core growing** | Pi + sensors + LEDs + fan + occasional mist | ~5.5W | 12 hours |
| **Void Core peak** | All systems active simultaneously | ~10W | Brief bursts |

---

## 10. Connector & Interface

### 10.1 Physical Connectors

| Connector | Location | Purpose | Variant |
|---|---|---|---|
| **USB-C receptacle** | Rear-center of base, recessed 3mm | Power input (+ data for Void Core) | Void, Void Core |
| **None (Dark Dome)** | -- | Dark Dome has no electrical connections | Dark Dome |

The USB-C port serves dual purpose on Void Core:
- **Power:** 5V/3A via USB-C PD
- **Data:** USB 2.0 data lines connect to Pi Zero W 2 for firmware updates, SSH access, and direct file transfer (timelapse images)

### 10.2 Physical Controls -- Base Void

| Control | Type | Location | Function |
|---|---|---|---|
| **Mode button** | Waterproof silicone-cap tactile switch, 12mm diameter | Base exterior, front-center, easily reachable | Tap: cycle light modes (1->2->3->4->1). Hold 3 sec: start UV-C sterilization cycle. |

Single button design rationale:
- One button is all the base Void needs. Fewer controls = less confusion = lower cost.
- Mode memory (if ATtiny85 is used): dome remembers last mode after power cycle.
- No touch sensor -- tactile button provides positive feedback and is more reliable in high-humidity environments.

### 10.3 Visual Indicators -- Base Void

| Indicator | Type | Location | Meaning |
|---|---|---|---|
| **Red LED** | 3mm through-hole LED | Base exterior, front, next to mode button | ON = UV-C sterilization cycle active. Do NOT remove dome. OFF = safe. |

No other indicators on base Void. Light mode is indicated by the dome glow itself (purple = UV-A, blue = Blue, purple+blue = Void Glow, dark = off).

### 10.4 Void Core Interfaces

| Interface | Type | Purpose |
|---|---|---|
| **Wi-Fi (2.4 GHz)** | Pi Zero W 2 built-in | App communication, cloud sync, firmware OTA updates |
| **Bluetooth Low Energy** | Pi Zero W 2 built-in | Initial setup/pairing, proximity-based features |
| **USB 2.0 data** | Via USB-C connector | SSH, file transfer, firmware flash (development/advanced users) |
| **CSI camera port** | Ribbon cable (internal) | Pi Camera Module connection |
| **I2C bus** | Internal (3.3V) | BME280, SCD40 sensors |

**No additional physical buttons or ports on Void Core.** All control is via the Void app or USB. The base Void's mode button still functions as a fallback (cycle modes locally if Wi-Fi is unavailable).

### 10.5 Dark Dome Interface

The Dark Dome has **no electronic interfaces whatsoever.** No USB port. No button. No LEDs. No indicators. It is a purely passive cultivation chamber -- a dome on a base with vents.

This extreme simplicity enables:
- $49 MSRP (no electronics cost)
- Zero failure modes (nothing electronic to break)
- Ideal for bioluminescent species where any light competes with the natural glow
- The product IS the absence of technology -- just the organism and darkness

---

## Appendix: Variant Comparison Matrix

| Feature | The Void ($79) | Void Core ($299) | Dark Dome ($49) |
|---|---|---|---|
| Dome shell (smoked PC) | Yes | Yes | Yes (or clear option) |
| Matte black base | Yes | Yes | Yes |
| Passive airflow vents | Yes | Yes (+ motorized dampers) | Yes |
| Substrate platform | Yes | Yes | Yes |
| UV-A LEDs (395nm) | 6x | 6x | No |
| Blue fruiting LEDs (450nm) | 6x | 6x | No |
| UV-C sterilization LED | 1x | 1x | No |
| RGB LEDs (WS2812B) | No | 8x | No |
| Safety interlock (magnetic) | Yes | Yes | N/A |
| Mode button | Yes (1 button) | Yes (1 button fallback) | No |
| USB-C power | Yes (5V/1A) | Yes (5V/3A PD) | No |
| 12h light timer | Yes (555 hardware) | Yes (software) | No |
| UV-C auto-shutoff timer | Yes (555 hardware) | Yes (software + hardware) | No |
| Red UV-C indicator LED | Yes | Yes | No |
| Pi Zero W 2 | No | Yes | No |
| BME280 sensor | No | Yes | No |
| CO2 sensor (SCD40) | No | Optional | No |
| Piezo humidifier | No | Yes (100ml reservoir) | No |
| PWM fan (30mm) | No | Yes | No |
| Camera module | No | Yes (5-8MP) | No |
| Wi-Fi / BLE | No | Yes | No |
| App control | No | Yes (Void app) | No |
| Programmable light modes | No | Yes (Deep Space, Aurora, etc.) | No |
| Timelapse | No | Yes | No |
| Estimated power draw | 0.8-1.1W | 5.5W typical | 0W |
| Moving parts | 0 | 3 (fan, humidifier, dampers) | 0 |
| PCB components | 15-25 | 50+ | 0 |
