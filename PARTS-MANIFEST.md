# The Void -- Parts Manifest

All printable parts for The Void mushroom cultivation dome. Each part has a dedicated export script in `cad/export/` that renders at $fn=128 for high-quality STL output.

## Export Workflow

1. Open the export script in OpenSCAD
2. Render (F6)
3. Export as STL (F7)
4. Save with the output filename listed below

## Parts Table

| # | Part Name | Export Script | Output STL | Source Module | Approx. Dimensions | Qty |
|---|-----------|--------------|------------|---------------|---------------------|-----|
| 1 | Substrate Platform | `cad/export/export_platform.scad` | `void-platform.stl` | `platform()` from `cad/platform.scad` | 140mm dia x 8mm H | 1 |
| 2 | Vent Cap Set | `cad/export/export_vent_cap.scad` | `void-vent-cap.stl` | `vent_cap_set()` from `cad/vent_cap.scad` | 4x 16mm dia x 4mm H (2x2 grid) | 1 set (4 caps) |
| 3 | Base Housing | `cad/export/export_base.scad` | `void-base.stl` | `base_housing()` from `cad/base.scad` | 203mm dia x 89mm H | 1 |
| 4 | Dome Full | `cad/export/export_dome_full.scad` | `void-dome-full.stl` | `dome_shell()` from `cad/dome.scad` | 203mm dia x 165mm H | 1* |
| 5 | Dome Upper | `cad/export/export_dome_upper.scad` | `void-dome-upper.stl` | `dome_upper()` from `cad/dome_split.scad` | 203mm dia x ~95mm H | 1* |
| 6 | Dome Lower | `cad/export/export_dome_lower.scad` | `void-dome-lower.stl` | `dome_lower()` from `cad/dome_split.scad` | 203mm dia x ~70mm H | 1* |

*\* Choose EITHER Dome Full (part 4) OR Dome Upper + Dome Lower (parts 5+6) -- not both. See decision guide below.*

## Export Script Verification

All 6 export scripts have been verified against the following criteria:

- [x] Includes `parameters.scad` for shared constants
- [x] Uses correct source module via `use<>` (not `include<>`)
- [x] Overrides `$fn = 128` for high-quality export
- [x] Calls exactly one module (no assembly rendering)

Cross-referenced against `cad/assembly.scad` -- all printable parts are covered.

## Recommended Print Order

Print in this order to validate fit progressively, starting with the smallest and fastest part:

| Order | Part | Reason |
|-------|------|--------|
| 1 | Substrate Platform | Smallest, fastest print (~1.5 hrs). Good test of printer calibration and bed adhesion. |
| 2 | Vent Cap Set | Small parts with snap-fit tabs. Tests fine detail resolution and tolerance. |
| 3 | Base Housing | Largest base component. Print before dome to verify seating channel dimensions. |
| 4 | Dome (full or split) | Print last -- relies on base seating channel fit verification from step 3. |

## Full vs Split Dome Decision

| Option | Parts | Pros | Cons |
|--------|-------|------|------|
| **Full Dome** | Part 4 only | Stronger (no glue joint), single print | Requires 220x220x250mm+ build volume |
| **Split Dome** | Parts 5 + 6 | Fits standard 220x220x220mm printers | Requires CA glue at alignment step ring |

Choose based on your printer's build volume. The split dome uses a 1mm alignment step at the inner wall radius for precise re-assembly.

## Source Parameters

Key dimensions from `cad/parameters.scad`:

- Total diameter: 203mm (8.0")
- Total height: 254mm (10.0") assembled
- Dome height: 165mm (6.5")
- Base height: 89mm (3.5")
- Platform diameter: 140mm (5.5")
- Dome wall thickness: 2.0mm
- Base wall thickness: 2.5mm
- Vent cap outer diameter: 16mm
- Exhaust vent count: 4
- Hemisphere radius: 106.794mm (derived)

---
*Generated from Phase 12 Plan 01 -- Export Verification*
*Last updated: 2026-02-22*
