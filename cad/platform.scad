// =============================================================================
// The Void — Substrate Platform Module (Golden Ratio Cloche)
// =============================================================================
// Shallow disc that sits inside the base housing, supporting the mushroom
// substrate block above the electronics cavity.
//
// Features:
//   - 140mm diameter flat disc (3mm thick)
//   - 6mm rim wall around perimeter (retains substrate)
//   - 8 drainage ribs on underside at 45-deg spacing (elevates substrate)
//   - 6 drain slots through floor at 60-deg spacing (moisture drainage)
//   - Ribs and slots offset to avoid overlap
//
// Public API:  substrate_platform()
// Private:     _drainage_ribs(), _drain_slots()
// =============================================================================

include <parameters.scad>

// === LOCAL CONSTANTS ===
platform_r = platform_diameter / 2;   // 70mm
platform_thickness = 3;               // mm — disc thickness
rim_height = platform_rim_height;     // 6mm — from parameters.scad
rim_width = 2;                        // mm — rim wall thickness

// Drainage ribs (additive, on underside)
rib_count = 8;                        // 8 ribs at 45-deg spacing
rib_height = 2;                       // mm — rib height below disc
rib_width = 2;                        // mm — rib radial width
rib_inner_r = 5;                      // mm — start radius (clear of center)
rib_outer_r = platform_r - rim_width; // mm — stop before rim

// Drain slots (subtractive, through floor)
slot_count = 6;                       // 6 slots at 60-deg spacing
slot_width = 3;                       // mm — slot width
slot_length_frac = 0.80;             // slots extend to 80% of radius
slot_outer_r = platform_r * slot_length_frac;  // ~56mm
slot_inner_r = 5;                     // mm — start radius

// === PRIVATE: 8 radial drainage ribs ===
// Ribs on underside of disc elevate the platform above the base floor,
// creating airflow channels for moisture drainage.
module _drainage_ribs() {
    for (angle = [0 : 360/rib_count : 359]) {
        rotate([0, 0, angle])
            translate([rib_inner_r, -rib_width/2, 0])
                cube([rib_outer_r - rib_inner_r, rib_width, rib_height]);
    }
}

// === PRIVATE: 6 radial drain slots ===
// Slots cut through the disc floor for water drainage.
// Offset from ribs by design (60-deg vs 45-deg spacing).
module _drain_slots() {
    for (angle = [0 : 360/slot_count : 359]) {
        rotate([0, 0, angle])
            translate([slot_inner_r, -slot_width/2, -epsilon])
                cube([slot_outer_r - slot_inner_r, slot_width, platform_thickness + 2*epsilon]);
    }
}

// === PUBLIC: Complete substrate platform ===
// Flat disc with rim wall, underside drainage ribs, and through-floor drain slots.
module substrate_platform() {
    difference() {
        union() {
            // Main disc
            cylinder(h = platform_thickness, r = platform_r);

            // Rim wall around perimeter
            difference() {
                cylinder(h = platform_thickness + rim_height, r = platform_r);
                translate([0, 0, -epsilon])
                    cylinder(h = platform_thickness + rim_height + 2*epsilon, r = platform_r - rim_width);
            }

            // Drainage ribs on underside
            translate([0, 0, -rib_height])
                _drainage_ribs();
        }

        // Drain slots through floor
        _drain_slots();
    }
}

// === Standalone preview ===
substrate_platform();
