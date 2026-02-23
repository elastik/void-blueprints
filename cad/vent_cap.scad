// =============================================================================
// The Void — Snap-In Vent Cap
// =============================================================================
// Removable caps for the 4 exhaust vent holes on the cloche dome wall.
// Snap-fit design: tapered tabs for tool-free insertion/removal.
//
// Features:
//   - Outer flange (16mm) covers vent hole from outside
//   - Insert cylinder (11.8mm) fits inside vent hole
//   - 2 opposing snap tabs with hull()-based taper for smooth insertion
//   - Internal mesh holder groove for optional filter media
//
// Public API:  vent_cap(), vent_cap_batch()
// =============================================================================

include <parameters.scad>

// === CAP DIMENSIONS ===
flange_r  = vent_cap_flange / 2;       // 8mm — outer flange radius
flange_h  = 1.5;                        // mm — flange thickness
insert_r  = vent_cap_insert / 2;        // 5.9mm — insert radius (12 - 2*0.1)
insert_h  = wall - 0.5;                 // 2.0mm — insert length (wall minus clearance)

// === SNAP TAB DIMENSIONS ===
tab_protrusion = 0.8;                   // mm — max outward protrusion
tab_leading    = 0.4;                   // mm — thin leading edge for taper
tab_width      = 2.5;                   // mm — tab width (circumferential)
tab_height     = 1.2;                   // mm — tab height (axial)

// === MESH GROOVE ===
groove_depth = 0.5;                     // mm — groove into insert wall
groove_width = 0.5;                     // mm — groove axial width

// === SINGLE VENT CAP ===
// Oriented flange-down for printing (flange on build plate).
module vent_cap() {
    // --- Outer flange ---
    cylinder(h = flange_h, r = flange_r);

    // --- Insert cylinder with mesh groove ---
    translate([0, 0, flange_h])
        difference() {
            cylinder(h = insert_h, r = insert_r);
            // Mesh holder groove at insert midpoint
            translate([0, 0, (insert_h - groove_width) / 2])
                difference() {
                    cylinder(h = groove_width, r = insert_r + epsilon);
                    cylinder(h = groove_width, r = insert_r - groove_depth);
                }
        }

    // --- Snap tabs (2, opposing at 0 and 180 degrees) ---
    for (a = [0, 180]) {
        rotate([0, 0, a])
            translate([0, 0, flange_h + insert_h * 0.6])
                _snap_tab();
    }
}

// === PRIVATE: Single snap tab ===
// Tapered ramp using hull() between thin leading edge and full protrusion.
// Leading edge is thinner for easy insertion; full protrusion locks in place.
module _snap_tab() {
    hull() {
        // Leading edge (thin) — at top of tab
        translate([insert_r + tab_leading/2, 0, tab_height])
            cube([tab_leading, tab_width, epsilon], center = true);
        // Full protrusion (thick) — at bottom of tab
        translate([insert_r + tab_protrusion/2, 0, 0])
            cube([tab_protrusion, tab_width, epsilon], center = true);
    }
}

// === BATCH LAYOUT ===
// 2x2 grid with 25mm spacing for printing all 4 caps at once.
// Caps oriented flange-down on print bed.
module vent_cap_batch() {
    spacing = 25;
    for (x = [0, 1])
        for (y = [0, 1])
            translate([x * spacing - spacing/2, y * spacing - spacing/2, 0])
                vent_cap();
}

// === Standalone preview ===
// Single cap preview
vent_cap();
// Batch layout for printing (uncomment to preview)
// translate([0, 60, 0]) vent_cap_batch();
