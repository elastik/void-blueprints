// =============================================================================
// The Void -- Dome Shell Module
// =============================================================================
//
// Truncated hemisphere dome with vertical sidewall transition.
// Includes: 4 exhaust vents, 1 magnet pocket, 1 alignment notch, seating lip.
//
// Geometry approach:
//   1. Vertical sidewall (bottom 25mm) -- thick cylinder for seating interface
//   2. Hemisphere section (upper 140mm) -- sphere shell with 2mm wall thickness
//   3. Union sidewall + hemisphere, subtract vents/pockets/notch/apex truncation
//
// The hemisphere sphere radius is calculated so that:
//   - At the sidewall junction (z=25), the sphere cross-section matches the
//     outer diameter (101.5mm radius)
//   - The sphere apex reaches dome_height (165mm)
//
// Source: PRODUCT-SPEC.md Sections 1, 2, 4
// =============================================================================

include <parameters.scad>

// -----------------------------------------------------------------------------
// Derived dome geometry constants
// -----------------------------------------------------------------------------

// Hemisphere sphere radius calculation:
// Sphere centered at z_c with radius R_hemi.
//   Top of sphere:   z_c + R_hemi = dome_height
//   At z = sidewall:  sqrt(R_hemi^2 - (sidewall_h - z_c)^2) = dome_outer_radius
//
// Solving:
//   z_c = dome_height - R_hemi
//   R_hemi^2 - (sidewall_h - dome_height + R_hemi)^2 = dome_outer_radius^2
//   Let D = dome_height - dome_vertical_sidewall_height  (= 140mm)
//   R_hemi = (dome_outer_radius^2 + D^2) / (2 * D)

_D = dome_height - dome_vertical_sidewall_height;  // 140 mm
R_hemi = (dome_outer_radius * dome_outer_radius + _D * _D) / (2 * _D);
// R_hemi ~= 106.794 mm

// Sphere center z-coordinate (from base of dome = z=0)
z_hemi_center = dome_height - R_hemi;
// z_hemi_center ~= 58.206 mm

// Inner hemisphere sphere radius (2mm wall thickness)
R_hemi_inner = R_hemi - dome_wall_thickness;
// R_hemi_inner ~= 104.794 mm

// Inner radius of the sidewall section
// The sidewall transitions from the thick seating interface to the hemisphere.
// At the junction (z=25), the inner hemisphere cross-section radius determines
// the inner wall of the upper dome. For the sidewall, we use the same inner
// radius as the hemisphere at the junction for a smooth transition.
_sidewall_inner_r = sqrt(
    R_hemi_inner * R_hemi_inner -
    (dome_vertical_sidewall_height - z_hemi_center) *
    (dome_vertical_sidewall_height - z_hemi_center)
);
// ~99.4 mm -- gives ~2.1mm wall at sidewall top, matching hemisphere wall

// Height at which to truncate the dome apex for the flat bridging surface
// We cut the sphere at (dome_height - dome_apex_flat)
z_apex_cut = dome_height - dome_apex_flat;  // 155 mm

// Radius of the flat circle at the apex truncation
r_apex_flat = sqrt(
    R_hemi * R_hemi -
    (z_apex_cut - z_hemi_center) * (z_apex_cut - z_hemi_center)
);

// -----------------------------------------------------------------------------
// Seating Lip Module
// From PRODUCT-SPEC.md Section 2 -- Dome-to-Base Interface
// The bottom edge of the dome has a slight inward step that sits into the
// base's seating channel (2mm deep, 2mm inward).
// -----------------------------------------------------------------------------

module seating_lip() {
    // The seating lip is a ring at the very bottom of the dome that steps
    // inward to nest into the base's seating channel.
    // Outer radius: dome_outer_radius (flush with dome wall)
    // Inner radius: dome_outer_radius - dome_seating_lip_inset
    // Height: dome_seating_lip_height (2mm)
    translate([0, 0, -dome_seating_lip_height])
        difference() {
            cylinder(
                h = dome_seating_lip_height,
                r = dome_outer_radius,
                center = false
            );
            translate([0, 0, -eps])
                cylinder(
                    h = dome_seating_lip_height + 2 * eps,
                    r = dome_outer_radius - dome_seating_lip_inset,
                    center = false
                );
        }
}

// -----------------------------------------------------------------------------
// Exhaust Vent Hole Module
// From PRODUCT-SPEC.md Section 4 -- Exhaust Vents
// 4 holes, 12mm diameter, at 60 degrees from apex, evenly spaced (90 deg apart)
// The vents are positioned on the sphere surface and oriented radially outward.
// -----------------------------------------------------------------------------

module exhaust_vent_holes() {
    // The vent angle is measured from the apex (top) of the dome.
    // On our sphere: the apex is at z = dome_height.
    // An angle of 60 degrees from apex means the vent center is at a polar
    // angle of 60 degrees from the top of the sphere.
    //
    // In spherical coordinates (with pole at top):
    //   z_vent = z_hemi_center + R_hemi * cos(exhaust_vent_angle_from_apex)
    //   r_vent = R_hemi * sin(exhaust_vent_angle_from_apex)

    z_vent = z_hemi_center + R_hemi * cos(exhaust_vent_angle_from_apex);
    r_vent = R_hemi * sin(exhaust_vent_angle_from_apex);

    // Angle of the surface normal at the vent location (from vertical)
    // This equals the polar angle from the apex = exhaust_vent_angle_from_apex
    surface_angle = exhaust_vent_angle_from_apex;

    for (i = [0 : exhaust_vent_count - 1]) {
        angle = i * (360 / exhaust_vent_count);  // 0, 90, 180, 270
        rotate([0, 0, angle])
            translate([r_vent, 0, z_vent])
                // Rotate the cylinder to point radially outward through the
                // dome wall, perpendicular to the sphere surface
                rotate([0, surface_angle, 0])
                    cylinder(
                        h = dome_wall_thickness * 4,  // long enough to cut through wall
                        d = exhaust_vent_diameter,
                        center = true
                    );
    }
}

// -----------------------------------------------------------------------------
// Magnet Pocket Module
// From PRODUCT-SPEC.md Section 2 -- Magnetic reed switch integration
// 6.5mm diameter x 2.5mm deep pocket in the seating lip area.
// Positioned on the outer wall of the dome, near the bottom rim.
// -----------------------------------------------------------------------------

module magnet_pocket() {
    // Position the magnet pocket in the seating lip area at the bottom of
    // the dome. It is a cylindrical pocket cut into the outer wall.
    // Place it at a specific angular position (0 degrees = opposite from
    // alignment notch for separation).
    pocket_z = dome_seating_lip_height / 2;  // centered vertically in lip area
    translate([dome_outer_radius - magnet_pocket_depth / 2, 0, pocket_z])
        rotate([0, 90, 0])
            cylinder(
                h = magnet_pocket_depth + eps,
                d = magnet_pocket_diameter,
                center = true
            );
}

// -----------------------------------------------------------------------------
// Alignment Notch Module
// From PRODUCT-SPEC.md Section 2 -- Dome-to-Base Interface
// Single rectangular notch in the seating lip for consistent dome orientation.
// -----------------------------------------------------------------------------

module alignment_notch() {
    // A rectangular cutout in the bottom rim of the dome.
    // Width = alignment_notch_width (5mm), depth = alignment_notch_depth (3mm)
    // Height extends through the seating lip.
    // Position at 180 degrees from the magnet pocket.
    rotate([0, 0, 180])  // Opposite side from magnet pocket
        translate([
            dome_outer_radius - alignment_notch_depth / 2,
            0,
            -dome_seating_lip_height - eps
        ])
            cube(
                [alignment_notch_depth + eps,
                 alignment_notch_width,
                 dome_seating_lip_height + 5],  // cut through lip + into sidewall base
                center = true
            );
}

// -----------------------------------------------------------------------------
// Main Dome Shell Module
// =============================================================================
// Combines all dome geometry:
//   1. Vertical sidewall cylinder (bottom 25mm)
//   2. Hemisphere section (sphere shell, upper portion)
//   3. Seating lip (bottom inward step)
//   Minus:
//   - Apex truncation (10mm flat for bridging)
//   - 4 exhaust vent holes
//   - 1 magnet pocket
//   - 1 alignment notch
//   - Inner void (hollowing out the dome)
// =============================================================================

module dome_shell() {
    difference() {
        // === Positive geometry (outer shell + seating lip) ===
        union() {
            // 1. Vertical sidewall section (z = 0 to z = sidewall_height)
            // Thick-walled cylinder for the seating interface area
            cylinder(
                h = dome_vertical_sidewall_height,
                r = dome_outer_radius,
                center = false
            );

            // 2. Hemisphere section (sphere, clipped to sit above sidewall)
            // Use intersection to keep only the portion above the sidewall
            // and below the apex truncation
            intersection() {
                // The full outer sphere
                translate([0, 0, z_hemi_center])
                    sphere(r = R_hemi);

                // Clip to region above the sidewall top and below apex cut
                translate([0, 0, dome_vertical_sidewall_height])
                    cylinder(
                        h = z_apex_cut - dome_vertical_sidewall_height + eps,
                        r = R_hemi + eps,  // wider than sphere to not clip sides
                        center = false
                    );
            }

            // 3. Flat cap at the truncated apex (solid disc for bridging)
            translate([0, 0, z_apex_cut - dome_wall_thickness])
                cylinder(
                    h = dome_wall_thickness,
                    r = r_apex_flat,
                    center = false
                );

            // 4. Seating lip (extends below z=0)
            seating_lip();
        }

        // === Negative geometry (subtract inner volume and features) ===

        // Inner void -- hollow out the sidewall section
        translate([0, 0, -dome_seating_lip_height - eps])
            cylinder(
                h = dome_vertical_sidewall_height + dome_seating_lip_height + 2 * eps,
                r = _sidewall_inner_r,
                center = false
            );

        // Inner void -- hollow out the hemisphere section
        // Use intersection to keep only the inner sphere above the sidewall
        intersection() {
            translate([0, 0, z_hemi_center])
                sphere(r = R_hemi_inner);

            // Clip to region above sidewall and below apex (inner surface)
            translate([0, 0, dome_vertical_sidewall_height - eps])
                cylinder(
                    h = z_apex_cut - dome_vertical_sidewall_height + 2 * eps,
                    r = R_hemi + eps,
                    center = false
                );
        }

        // Exhaust vent holes (4x, radially oriented through dome wall)
        exhaust_vent_holes();

        // Magnet pocket (6.5mm x 2.5mm, in seating lip area)
        magnet_pocket();

        // Alignment notch (rectangular cutout in bottom rim)
        alignment_notch();
    }
}

// =============================================================================
// Render when called directly
// =============================================================================
dome_shell();
