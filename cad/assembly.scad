// =============================================================================
// The Void — Full Assembly Visualization (Golden Ratio Cloche)
// =============================================================================
// VISUALIZATION ONLY — do not export as STL. Use cad/export/ for individual parts.
//
// Color-coded assembly showing all components in correct relative positions.
// Toggle between full dome and split dome views.
//
// Color scheme:
//   DimGray        — Base housing
//   Gray           — Substrate platform
//   DarkSlateGray  — Dome (70% opacity)
//   LightSlateGray — Vent caps
//
// Public API:  void_assembly(split = false)
// =============================================================================

include <parameters.scad>
use <dome.scad>
use <dome_split.scad>
use <base.scad>
use <platform.scad>
use <vent_cap.scad>

// === VENT CAP PLACEMENT ===
// Positions 4 vent caps at the exhaust vent hole locations on the dome wall.
// Vent holes are at 75% of straight_height, at 90-deg intervals (matching dome.scad).
// Caps oriented flange outward, insert facing inward through wall.
module _place_vent_caps() {
    vent_z = straight_height * 0.75;

    for (angle = [0, 90, 180, 270]) {
        rotate([0, 0, angle])
            translate([R, 0, vent_z])
                rotate([0, 90, 0])      // Rotate cap to face radially outward
                    vent_cap();
    }
}

// === PUBLIC: Full cloche assembly ===
// Renders all components in correct positions with color coding.
// split=true shows dome_lower() + dome_upper() instead of void_dome().
module void_assembly(split = false) {
    // Base at origin
    color("DimGray")
        void_base();

    // Platform inside base (elevated above floor)
    color("Gray")
        translate([0, 0, platform_z])
            substrate_platform();

    // Dome on top of base
    if (split) {
        color("DarkSlateGray", 0.7)
            translate([0, 0, base_h]) {
                dome_lower();
                dome_upper();
            }
    } else {
        color("DarkSlateGray", 0.7)
            translate([0, 0, base_h])
                void_dome();
    }

    // Vent caps on dome wall
    color("LightSlateGray")
        translate([0, 0, base_h])
            _place_vent_caps();
}

// === Standalone preview ===
// Full assembly (default)
void_assembly();

// Uncomment for split dome view:
// void_assembly(split = true);
