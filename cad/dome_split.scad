// =============================================================================
// The Void — Split Dome Modules for 3D Printing
// =============================================================================
// The 265.7mm cloche exceeds standard 220mm print beds.
// Split at the wall-arch junction (z=164.2mm) into two printable sections:
//   - dome_lower(): straight wall cylinder (0-164.2mm)
//   - dome_upper(): hemisphere arch cap (164.2-265.7mm, 101.5mm tall)
//
// Intersection-based splitting guarantees geometric match with void_dome().
// 1mm alignment step ring at split plane for glue-up registration.
//
// Public API:  dome_lower(), dome_upper()
// =============================================================================

include <parameters.scad>
use <dome.scad>

// === DERIVED GEOMETRY ===
// Recalculated locally because use<> imports modules only, not variables.
_R             = D / 2;                              // 101.5mm
_arch_height   = _R;                                 // 101.5mm
_straight_height = _arch_height * phi;               // 164.2mm
_dome_height   = _straight_height + _arch_height;    // 265.7mm

// === SPLIT PARAMETERS ===
split_z     = _straight_height;   // 164.2mm — wall-arch junction
step_h      = 1;                  // mm — alignment step height
step_w      = 1;                  // mm — alignment step radial width
step_tol    = 0.1;               // mm — glue gap tolerance

// Step ring geometry (at inner wall surface, hidden when assembled)
step_inner_r = _R - wall;                // inner dome surface
step_outer_r = _R - wall + step_w;       // step extends 1mm into wall

// === DOME LOWER ===
// Straight wall cylinder from z=0 to z=164.2mm.
// Includes step ring protrusion extending above the split plane.
// Prints standing upright (164.2mm + 1mm step = 165.2mm, fits 220mm bed).
module dome_lower() {
    // Intersection: everything from void_dome() below split_z + step_h
    intersection() {
        void_dome();
        translate([0, 0, -1])
            cylinder(h = split_z + step_h + 1, r = _R + 10);
    }
    // Step ring protrusion (added on top of the intersected shell)
    difference() {
        translate([0, 0, split_z])
            cylinder(h = step_h, r = step_outer_r);
        translate([0, 0, split_z - epsilon])
            cylinder(h = step_h + 2*epsilon, r = step_inner_r);
    }
}

// === DOME UPPER ===
// Hemisphere arch cap from z=164.2mm to z=265.7mm (101.5mm tall).
// Includes step recess matching the lower section's protrusion.
// Prints upside-down (101.5mm tall, fits 220mm bed easily).
module dome_upper() {
    difference() {
        // Intersection: everything from void_dome() above split_z
        intersection() {
            void_dome();
            translate([0, 0, split_z])
                cylinder(h = _dome_height - split_z + 1, r = _R + 10);
        }
        // Step recess (matching lower section protrusion + tolerance)
        translate([0, 0, split_z - epsilon])
            difference() {
                cylinder(h = step_h + step_tol + epsilon, r = step_outer_r + step_tol);
                cylinder(h = step_h + step_tol + 2*epsilon, r = step_inner_r - step_tol);
            }
    }
}

// === Standalone preview ===
// Side-by-side split sections for visual inspection
translate([-_R - 10, 0, 0]) dome_lower();
translate([ _R + 10, 0, 0]) dome_upper();
