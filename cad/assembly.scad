// =============================================================================
// The Void -- Full Assembly Visualization
// =============================================================================
//
// Combines all parts in their assembled positions for visual verification.
// Color-coded with transparent dome to see internal components.
//
// Z-positioning:
//   Base:     z = 0       (sits on ground plane)
//   Platform: z = 45      (on internal support ledge)
//   Dome:     z = 89      (base_height, sits on seating channel)
//   Vent caps: on dome exhaust vent holes (60 deg from apex)
//
// Toggle show_full_dome to switch between full and split dome views.
//
// NOTE: This file is for visualization only -- never export as STL.
// Use the individual export files in cad/export/ for STL generation.
//
// Source: PRODUCT-SPEC.md, BUILD-GUIDE.md
// =============================================================================

include <parameters.scad>
use <dome.scad>
use <base.scad>
use <platform.scad>
use <vent_cap.scad>
use <dome_split.scad>

// -----------------------------------------------------------------------------
// Assembly toggle
// -----------------------------------------------------------------------------

// Set to true for full dome, false for split dome halves
show_full_dome = true;

// -----------------------------------------------------------------------------
// Vent cap positioning (derived from dome geometry)
// Same calculations as dome.scad exhaust_vent_holes()
// -----------------------------------------------------------------------------

// Hemisphere sphere radius and center
_D_asm = dome_height - dome_vertical_sidewall_height;  // 140 mm
_R_hemi_asm = (dome_outer_radius * dome_outer_radius + _D_asm * _D_asm) / (2 * _D_asm);
// _R_hemi_asm ~= 106.794 mm

_z_hemi_center_asm = dome_height - _R_hemi_asm;
// _z_hemi_center_asm ~= 58.206 mm

// Vent position on dome surface (polar angle 60 deg from apex)
_z_vent = _z_hemi_center_asm + _R_hemi_asm * cos(exhaust_vent_angle_from_apex);
_r_vent = _R_hemi_asm * sin(exhaust_vent_angle_from_apex);
_surface_angle = exhaust_vent_angle_from_apex;  // 60 deg from vertical

// =============================================================================
// assembly() -- Full assembly visualization
// =============================================================================

module assembly() {
    // ----- Base at origin -----
    color("DimGray")
        base_housing();

    // ----- Platform on internal ledge -----
    color("Gray")
        translate([0, 0, 45])
            platform();

    // ----- Dome on top of base -----
    if (show_full_dome) {
        color("DarkSlateGray", 0.7)
            translate([0, 0, base_height])
                dome_shell();
    } else {
        // Split dome -- lower half in position, upper half in position
        color("DarkSlateGray", 0.7)
            translate([0, 0, base_height])
                dome_lower();
        color("SlateGray", 0.7)
            translate([0, 0, base_height])
                dome_upper();
    }

    // ----- Vent caps in exhaust holes -----
    // 4 vent caps positioned on the dome surface at the exhaust vent locations.
    // Each cap is translated to the vent hole position on the dome (which is
    // itself translated up by base_height), then rotated to match the surface
    // normal at that point.
    color("LightSlateGray")
        for (i = [0 : exhaust_vent_count - 1]) {
            rotate([0, 0, i * (360 / exhaust_vent_count)])
                translate([0, 0, base_height])  // dome base offset
                    translate([_r_vent, 0, _z_vent])  // vent position on dome
                        rotate([0, _surface_angle, 0])  // align with surface normal
                            rotate([180, 0, 0])  // flip so insert points inward into dome
                                vent_cap();
        }
}

// =============================================================================
// Render assembly
// =============================================================================
assembly();
