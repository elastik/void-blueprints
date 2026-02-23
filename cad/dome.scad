// =============================================================================
// The Void — Cloche Dome Shell Module
// =============================================================================
// Golden ratio cloche: straight wall + semicircular arch cap.
// Shell created by rotate_extrude of 2D profile, then subtracted features.
//
// Public API:  void_dome()
// Private:     _profile(), exhaust_vent_holes(), alignment_notch()
// =============================================================================

include <parameters.scad>

// === PRIVATE: 2D cloche profile ===
// Generates a 2D cross-section for rotate_extrude():
//   - Vertical rectangle (straight wall portion)
//   - Quarter-circle (arch cap, seamless tangent transition)
module _profile(radius, sh, cr) {
    // Straight wall portion
    square([radius, sh]);
    // Quarter-circle arch cap (seamless transition)
    translate([0, sh])
        intersection() {
            square([radius, cr]);
            circle(r = cr);
        }
}

// === EXHAUST VENT HOLES ===
// 4 vents at 90° intervals on the straight wall portion.
// Positioned at 75% of straight_height (~123mm) for hot/moist air exhaust.
module exhaust_vent_holes() {
    vent_z = straight_height * 0.75;
    for (angle = [0, 90, 180, 270]) {
        rotate([0, 0, angle])
            translate([R, 0, vent_z])
                rotate([0, 90, 0])
                    cylinder(h = wall + 2*epsilon, r = vent_hole_diameter/2, center = true);
    }
}

// === ALIGNMENT NOTCH ===
// Small notch at 0° (positive X axis) on the dome bottom edge.
// Provides orientation reference during assembly.
module alignment_notch() {
    notch_w = 5;
    notch_d = 3;
    notch_h = 4;
    translate([R - wall/2, -notch_w/2, -1])
        cube([notch_d, notch_w, notch_h]);
}

// === PUBLIC: Complete dome shell ===
// Hollow cloche shell with vent holes and alignment notch.
// Uses rotate_extrude() of 2D profile for outer and inner surfaces.
module void_dome() {
    difference() {
        // Outer shell
        rotate_extrude()
            _profile(R, straight_height, R);
        // Inner cavity (wall thickness inset)
        rotate_extrude()
            _profile(R - wall, straight_height, R - wall);
        // Clean bottom edge — remove any z<0 artifacts
        translate([0, 0, -1])
            cylinder(h = 1.1, r = R + 1);
        // Exhaust vent holes
        exhaust_vent_holes();
        // Alignment notch
        alignment_notch();
    }
}

// === Standalone preview ===
void_dome();
