// =============================================================================
// The Void -- Split Dome Modules (Upper & Lower Halves)
// =============================================================================
//
// Splits the full dome shell into two halves for printing on 220x220mm beds.
// Split plane: z = dome_vertical_sidewall_height (25mm) -- at the
// sidewall/hemisphere junction.
//
// Lower half: vertical sidewall with seating lip, magnet pocket, alignment
//             notch, plus an alignment step ring on the top edge.
// Upper half: truncated hemisphere with exhaust vents and apex flat, plus a
//             matching groove on the bottom edge for the alignment step.
//
// Both halves fit within 203mm diameter (the dome's outer diameter), which
// is compatible with 220x220mm print beds.
//
// Usage: use <dome_split.scad> from other files, or render directly.
// =============================================================================

include <parameters.scad>
use <dome.scad>

// -----------------------------------------------------------------------------
// Split Parameters
// -----------------------------------------------------------------------------

// Split plane height -- at the top of the vertical sidewall
split_height = dome_vertical_sidewall_height;  // 25 mm

// Alignment step dimensions -- interlocking ring at the split junction
split_step_height = 1.0;  // mm -- height of the step ring
split_step_width  = 1.0;  // mm -- radial width of the step ring

// Glue clearance -- slight gap to allow adhesive between mating surfaces
split_tolerance = 0.1;  // mm

// Bounding radius for intersection cuts (slightly larger than dome)
_split_bound_r = dome_outer_radius + 5;

// -----------------------------------------------------------------------------
// dome_lower() -- Lower half of the split dome
// =============================================================================
// Contains: vertical sidewall, seating lip, magnet pocket, alignment notch.
// The alignment step ring protrudes from the top edge, providing a ledge
// that the upper half sits on for precise alignment during gluing.
//
// Print orientation: lip-down (stable, no supports needed).
// -----------------------------------------------------------------------------

module dome_lower() {
    union() {
        // Main geometry: dome_shell() intersected with a bounding cylinder
        // from below the seating lip up to the split height.
        // The seating lip extends to z = -dome_seating_lip_height, so we
        // start the bounding volume there.
        intersection() {
            dome_shell();
            translate([0, 0, -dome_seating_lip_height - eps])
                cylinder(
                    h = split_height + dome_seating_lip_height + eps + eps,
                    r = _split_bound_r,
                    center = false
                );
        }

        // Alignment step ring on top edge.
        // This is a thin ring that sits on top of the lower half's wall,
        // stepping inward to create a ledge the upper half nests onto.
        // Outer edge aligns with dome inner wall at the split height;
        // it steps inward by split_step_width.
        //
        // The step ring sits at the inner surface of the dome wall.
        // Outer radius of step = _sidewall_inner_r (inner wall of sidewall)
        //   so it doesn't protrude past the outer dome surface.
        // Inner radius of step = _sidewall_inner_r - split_step_width
        //
        // We need to recalculate _sidewall_inner_r here since we used
        // use<dome.scad> (variables from dome.scad aren't imported).
        // Actually, we included parameters.scad, so we can derive it.

        // Recalculate derived dome geometry (same as dome.scad)
        _D_split = dome_height - dome_vertical_sidewall_height;  // 140 mm
        _R_hemi = (dome_outer_radius * dome_outer_radius + _D_split * _D_split) / (2 * _D_split);
        _z_hemi_center = dome_height - _R_hemi;
        _R_hemi_inner = _R_hemi - dome_wall_thickness;
        _step_outer_r = sqrt(
            _R_hemi_inner * _R_hemi_inner -
            (dome_vertical_sidewall_height - _z_hemi_center) *
            (dome_vertical_sidewall_height - _z_hemi_center)
        );

        translate([0, 0, split_height])
            difference() {
                cylinder(
                    h = split_step_height,
                    r = _step_outer_r,
                    center = false
                );
                translate([0, 0, -eps])
                    cylinder(
                        h = split_step_height + 2 * eps,
                        r = _step_outer_r - split_step_width,
                        center = false
                    );
            }
    }
}

// -----------------------------------------------------------------------------
// dome_upper() -- Upper half of the split dome
// =============================================================================
// Contains: hemisphere section, exhaust vents, apex flat.
// The bottom edge has a groove that matches the lower half's alignment step,
// providing a precise mating surface for gluing.
//
// Print orientation: apex-up (stable hemisphere base, no supports needed).
// -----------------------------------------------------------------------------

module dome_upper() {
    // Recalculate derived dome geometry
    _D_upper = dome_height - dome_vertical_sidewall_height;
    _R_hemi_u = (dome_outer_radius * dome_outer_radius + _D_upper * _D_upper) / (2 * _D_upper);
    _z_hemi_center_u = dome_height - _R_hemi_u;
    _R_hemi_inner_u = _R_hemi_u - dome_wall_thickness;
    _step_outer_r_u = sqrt(
        _R_hemi_inner_u * _R_hemi_inner_u -
        (dome_vertical_sidewall_height - _z_hemi_center_u) *
        (dome_vertical_sidewall_height - _z_hemi_center_u)
    );

    difference() {
        // Main geometry: dome_shell() intersected with a bounding cylinder
        // from the split height up past the dome apex.
        intersection() {
            dome_shell();
            translate([0, 0, split_height])
                cylinder(
                    h = dome_height - split_height + eps,
                    r = _split_bound_r,
                    center = false
                );
        }

        // Groove for alignment step -- a ring-shaped channel cut into the
        // bottom edge of the upper half. Slightly oversized (by split_tolerance)
        // to allow the lower half's step to nest in with room for adhesive.
        translate([0, 0, split_height - eps])
            difference() {
                cylinder(
                    h = split_step_height + split_tolerance + eps,
                    r = _step_outer_r_u + split_tolerance,
                    center = false
                );
                translate([0, 0, -eps])
                    cylinder(
                        h = split_step_height + split_tolerance + 3 * eps,
                        r = _step_outer_r_u - split_step_width - split_tolerance,
                        center = false
                    );
            }
    }
}

// =============================================================================
// Preview: render both halves side by side
// =============================================================================
translate([-(dome_outer_radius + 10), 0, 0]) dome_lower();
translate([(dome_outer_radius + 10), 0, 0])  dome_upper();
