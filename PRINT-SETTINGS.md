# The Void -- Print Settings Guide

Recommended 3D print settings for all Void dome parts. Follow these settings to minimize failed prints and wasted filament.

See [PARTS-MANIFEST.md](PARTS-MANIFEST.md) for the full parts list, export scripts, and print order.

## Material Recommendation

**PETG (recommended)** -- Humidity resistance, slight flex for snap-fits, good layer adhesion on curved surfaces. The dome operates in a high-humidity environment (85-95% RH); PETG handles this without degradation.

**PLA (acceptable for test prints)** -- Cheaper and easier to print, but will soften and degrade in sustained high-humidity conditions. Use for initial fit testing only.

**ABS (not recommended)** -- Excessive warping on large curved surfaces like the dome hemisphere. Do not use.

## General Slicer Settings

| Setting | Value |
|---------|-------|
| Material | PETG |
| Nozzle temperature | 235 C |
| Bed temperature | 70 C |
| First layer height | 0.28mm (for adhesion) |
| Print speed | 50mm/s (curved surfaces) |
| Detect thin walls | Enabled |
| Infill pattern | Gyroid (unless noted) |

## Per-Part Print Settings

### 1. Substrate Platform

| Setting | Value |
|---------|-------|
| **Dimensions** | 140mm diameter x 8mm height |
| **Layer height** | 0.2mm |
| **Infill** | 20% gyroid |
| **Supports** | None |
| **Orientation** | Print flat (bottom surface on bed) |
| **Estimated filament** | ~30g PETG |
| **Estimated time** | ~1.5 hours |

**Notes:** Smallest and fastest part. Print first as a calibration test. Drain slots and drainage ribs should print cleanly without supports.

### 2. Vent Cap Set (4x)

| Setting | Value |
|---------|-------|
| **Dimensions** | 4x 16mm diameter x 4mm height (2x2 grid) |
| **Layer height** | 0.16mm (finer for smooth snap tabs) |
| **Infill** | 100% (small parts, solid fill) |
| **Supports** | None |
| **Orientation** | Print flat, flange side down |
| **Estimated filament** | ~12g PETG total (all 4 caps) |
| **Estimated time** | ~45 minutes |

**Notes:** Fine layer height (0.16mm) is important for smooth snap-fit tabs. These tabs insert into the dome exhaust vent holes and need clean edges for a secure friction fit. Solid infill since the parts are very small.

### 3. Base Housing

| Setting | Value |
|---------|-------|
| **Dimensions** | 203mm diameter x 89mm height |
| **Layer height** | 0.2mm |
| **Infill** | 25% gyroid |
| **Supports** | Yes -- tree supports recommended |
| **Orientation** | Print upright (open-top facing up) |
| **Estimated filament** | ~200g PETG |
| **Estimated time** | ~12 hours |

**Notes:** Supports are needed for the USB-C cutout and button hole overhangs in the base walls. Use tree supports (available in Cura, OrcaSlicer, PrusaSlicer 2.7+) to minimize interior contact marks. The seating channel at the top rim should print cleanly as a downward-facing overhang is avoided in the upright orientation.

### 4. Dome Full (one-piece option)

| Setting | Value |
|---------|-------|
| **Dimensions** | 203mm diameter x 165mm height |
| **Layer height** | 0.2mm |
| **Infill** | 15% gyroid |
| **Supports** | None (hemisphere self-supports above 45 degrees) |
| **Orientation** | Print base-down (open end on bed) |
| **Estimated filament** | ~150g PETG |
| **Estimated time** | ~14 hours |

**Notes:** Requires a printer with 220mm+ build plate height (250mm recommended). The hemisphere geometry naturally self-supports -- no overhang exceeds 45 degrees until near the apex, which has a 10mm flat bridging zone. Print with the open end (seating lip) on the build plate for maximum stability.

### 5. Dome Upper (split option)

| Setting | Value |
|---------|-------|
| **Dimensions** | ~203mm diameter x ~95mm height |
| **Layer height** | 0.2mm |
| **Infill** | 15% gyroid |
| **Supports** | None |
| **Orientation** | Print cut-face down |
| **Estimated filament** | ~90g PETG |
| **Estimated time** | ~8 hours |

**Notes:** The flat cut face provides a stable base for printing. Fits on a standard 220x220mm bed. The alignment step ring on the cut face interfaces with the dome lower half.

### 6. Dome Lower (split option)

| Setting | Value |
|---------|-------|
| **Dimensions** | ~203mm diameter x ~70mm height |
| **Layer height** | 0.2mm |
| **Infill** | 15% gyroid |
| **Supports** | None |
| **Orientation** | Print base-down (seating lip on bed) |
| **Estimated filament** | ~60g PETG |
| **Estimated time** | ~5 hours |

**Notes:** The shorter half of the split dome. Print with the seating lip (open end) on the bed for stability. The alignment step ring at the top interfaces with the dome upper half.

## Split vs Full Dome Decision Guide

| Criterion | Full Dome | Split Dome |
|-----------|-----------|------------|
| **Build volume required** | 220 x 220 x 250mm+ | 220 x 220 x 220mm (standard) |
| **Structural strength** | Stronger (no joint) | Requires glue joint |
| **Print count** | 1 print | 2 prints |
| **Total filament** | ~150g | ~150g (90 + 60) |
| **Total time** | ~14 hours | ~13 hours (8 + 5) |
| **Assembly** | None | Glue with medium CA + accelerator on alignment step ring |

**Recommendation:**
- If your printer has 220x220x250mm+ build volume, print the **full dome** for maximum strength (no glue joint).
- If your printer is 220x220x220mm (standard), use the **split dome** option. Apply medium CA (cyanoacrylate) glue with accelerator spray on the 1mm alignment step ring for a strong, invisible bond.

## Total Materials Estimate

### Option A: Full Dome Build

| Part | Filament |
|------|----------|
| Substrate Platform | ~30g |
| Vent Cap Set (4x) | ~12g |
| Base Housing | ~200g |
| Dome Full | ~150g |
| **Total** | **~392g PETG** |

### Option B: Split Dome Build

| Part | Filament |
|------|----------|
| Substrate Platform | ~30g |
| Vent Cap Set (4x) | ~12g |
| Base Housing | ~200g |
| Dome Upper | ~90g |
| Dome Lower | ~60g |
| **Total** | **~392g PETG** |

**Total filament:** ~380-440g PETG (one 1kg spool is sufficient with margin for test prints)

**Total print time:** ~30-40 hours unattended (varies by printer speed, infill density, and slicer settings)

## Additional Supplies

| Item | Purpose |
|------|---------|
| Medium CA glue + accelerator | Split dome joint (if using split option) |
| Isopropyl alcohol (IPA) | Build plate cleaning for PETG adhesion |
| Glue stick or PEI sheet | Bed adhesion for PETG |
| Sandpaper (220-400 grit) | Optional: smooth any support contact marks on base housing |

---
*Generated from Phase 12 Plan 01 -- Print Settings Guide*
*Last updated: 2026-02-22*
