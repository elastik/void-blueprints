// =============================================================================
// The Void -- Vent Cap Module (Snap-In Exhaust Vent Cover)
// =============================================================================
//
// A small plug that snaps into the 12mm exhaust vent holes in the dome.
// Provides airflow control -- caps can be removed to increase ventilation
// or left in place to maintain humidity.
//
// Geometry:
//   1. Outer flange -- 16mm disc that sits flush against the dome exterior
//   2. Insert cylinder -- 11.8mm (12mm - tolerance) that slides into the hole
//   3. Snap tabs -- 2 opposing flexible tabs for friction retention
//   4. Mesh holder groove -- internal channel for future filter mesh insert
//
// Printing: print flange-down, no supports needed. Snap tabs print vertically
// and flex outward. Use vent_cap_set() to print all 4 at once.
//
// Source: PRODUCT-SPEC.md Section 4, BUILD-GUIDE.md Section 2
// =============================================================================

include <parameters.scad>

// -----------------------------------------------------------------------------
// Vent Cap Derived Parameters
// -----------------------------------------------------------------------------

// Insert diameter with FDM clearance for smooth insertion
_vc_insert_r = (vent_cap_inner_diameter - fdm_tolerance * 2) / 2;  // (12 - 0.4)/2 = 5.8 mm

// Outer flange radius
_vc_flange_r = vent_cap_outer_diameter / 2;  // 8.0 mm

// Flange thickness
_vc_flange_h = 1.5;  // mm

// Snap tab dimensions
_vc_snap_protrusion = vent_cap_snap_thickness;  // 1.0 mm -- radial protrusion
_vc_snap_length     = 2.0;  // mm -- axial length of each tab
_vc_snap_width      = 2.5;  // mm -- circumferential width of each tab
_vc_snap_taper      = 0.8;  // mm -- taper at leading edge for easy insertion

// Snap tab position: near the end of the insert cylinder
_vc_snap_z_offset = _vc_flange_h + vent_cap_depth - _vc_snap_length - 0.5;

// Mesh holder groove (internal channel for future filter)
_vc_groove_depth = 0.5;  // mm -- groove depth into insert wall
_vc_groove_width = 1.0;  // mm -- groove axial width
_vc_groove_z     = _vc_flange_h + vent_cap_depth / 2 - _vc_groove_width / 2;

// -----------------------------------------------------------------------------
// vent_cap() -- Single vent cap
// =============================================================================
// Complete snap-in vent cap with flange, insert cylinder, snap tabs, and
// internal mesh holder groove.
// -----------------------------------------------------------------------------

module vent_cap() {
    union() {
        // 1. Outer flange disc
        // Sits flush against the dome exterior surface, prevents over-insertion.
        // Slightly domed profile using a very shallow cone for aesthetics.
        cylinder(
            h = _vc_flange_h,
            r1 = _vc_flange_r,
            r2 = _vc_flange_r,
            center = false
        );

        // 2. Insert cylinder
        // The main body that slides into the exhaust vent hole.
        translate([0, 0, _vc_flange_h])
            difference() {
                cylinder(
                    h = vent_cap_depth,
                    r = _vc_insert_r,
                    center = false
                );

                // Mesh holder groove -- internal ring channel
                // For future filter mesh or screen insert
                translate([0, 0, vent_cap_depth / 2 - _vc_groove_width / 2])
                    difference() {
                        cylinder(
                            h = _vc_groove_width,
                            r = _vc_insert_r + eps,
                            center = false
                        );
                        translate([0, 0, -eps])
                            cylinder(
                                h = _vc_groove_width + 2 * eps,
                                r = _vc_insert_r - _vc_groove_depth,
                                center = false
                            );
                    }
            }

        // 3. Snap tabs (2 opposing)
        // Flexible tabs that deflect inward during insertion, then spring
        // outward to catch the inner dome wall surface. Each tab is a
        // tapered bump on the insert cylinder surface.
        for (angle = [0, 180]) {
            rotate([0, 0, angle])
                translate([0, 0, _vc_snap_z_offset])
                    _snap_tab();
        }
    }
}

// -----------------------------------------------------------------------------
// _snap_tab() -- Single snap tab (internal helper)
// =============================================================================
// A tapered bump on the insert cylinder surface. Uses hull() between a thin
// leading edge and the full protrusion to create a ramp for easy insertion.
// Oriented along +X axis; caller rotates to final position.
// -----------------------------------------------------------------------------

module _snap_tab() {
    // The tab is built using hull() between two shapes:
    //   - A thin leading edge (bottom) for the insertion ramp
    //   - The full protrusion (top) that catches behind the dome wall

    hull() {
        // Leading edge (thin ramp at bottom of tab)
        translate([_vc_insert_r, 0, 0])
            cube([eps, _vc_snap_width, _vc_snap_taper], center = true);

        // Full protrusion (catches behind dome wall)
        translate([_vc_insert_r + _vc_snap_protrusion / 2, 0, _vc_snap_length / 2 + _vc_snap_taper / 2])
            cube([_vc_snap_protrusion, _vc_snap_width, _vc_snap_length - _vc_snap_taper], center = true);
    }
}

// -----------------------------------------------------------------------------
// vent_cap_set() -- Batch of 4 vent caps for printing
// =============================================================================
// Arranges 4 vent caps in a 2x2 grid with 25mm spacing for batch printing.
// Total footprint: ~41mm x 41mm -- fits easily on any print bed.
// -----------------------------------------------------------------------------

module vent_cap_set() {
    spacing = 25;  // mm between cap centers
    for (i = [0:3]) {
        col = i % 2;
        row = floor(i / 2);
        translate([col * spacing, row * spacing, 0])
            vent_cap();
    }
}

// =============================================================================
// Render: 4-cap batch layout for direct printing
// =============================================================================
vent_cap_set();
