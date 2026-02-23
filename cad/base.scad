// =============================================================================
// The Void -- Base Housing Module
// =============================================================================
//
// Cylindrical base unit housing electronics, airflow plenum, and platform.
// Includes: dome seating channel, gasket groove, 8 intake vents,
//           USB-C / button / LED connector cutouts, platform support ledge,
//           and all Void Core internal component mounts.
//
// Geometry approach:
//   1. Outer cylinder wall (203mm OD, 2.5mm wall, 89mm tall)
//   2. Solid floor disc at z=0 (2.5mm thick)
//   3. Platform support ledge (internal ring at z=45mm)
//   4. Internal mounts: Pi Zero standoffs, fan mount, BME280 shelf, servo posts
//   Minus:
//   - Inner cavity (hollow out the cylinder)
//   - Dome seating channel (annular groove in top rim)
//   - Gasket groove (inside seating channel)
//   - 8 intake vents (rectangular slots around perimeter)
//   - USB-C, button, and LED connector cutouts
//   - Humidifier reservoir well (in floor)
//   - Fan airflow opening (through floor)
//   - Cable routing channels (grooves in floor)
//
// Source: PRODUCT-SPEC.md Sections 1, 3, 4, 5, 8, 10
// =============================================================================

include <parameters.scad>

// -----------------------------------------------------------------------------
// Derived base geometry constants
// -----------------------------------------------------------------------------

base_outer_radius = base_outer_diameter / 2;  // 101.5 mm
base_inner_radius = base_outer_radius - base_wall_thickness;  // 99.0 mm

// Platform support ledge
// The 140mm diameter platform sits on this ring. Ledge outer radius = platform
// edge radius (70mm), inner radius = 67mm, giving a 3mm wide support ring.
platform_ledge_z = 45;          // mm -- height where substrate platform rests
platform_ledge_thickness = 2;   // mm -- vertical thickness of the ledge
platform_ledge_outer_r = platform_diameter / 2;  // 70 mm (matches platform edge)
platform_ledge_inner_r = platform_ledge_outer_r - 3;  // 67 mm (3mm wide ledge)

// Intake vent positioning
intake_vent_z_center = base_wall_thickness + intake_vent_height / 2 + 5;
// ~10mm from base bottom (above 2.5mm floor + 5mm gap)

// Connector cutout positioning
connector_z_center = 15;  // mm from base bottom

// Dome seating channel position
// The channel is cut into the top rim of the base wall.
// It accommodates the dome's seating lip (2mm inset, 2mm tall).
// Channel sits on the inner portion of the wall at the top edge.

// -----------------------------------------------------------------------------
// Void Core internal component layout positions
// From PRODUCT-SPEC.md Section 8 -- Void Core Smart Electronics
// All positions are XY offsets from base center, z from floor top (2.5mm)
// -----------------------------------------------------------------------------

// Pi Zero W 2: near USB-C side (0 deg) for short cable routing
pi_mount_x = 35;
pi_mount_y = -25;
pi_standoff_height = 5;      // mm -- clearance from floor for airflow under board
pi_standoff_od = 5;           // mm -- standoff outer diameter
pi_hole_id = 2.5;             // mm -- M2.5 screw hole inner diameter
pi_hole_spacing_x = 23;      // mm -- hole-to-hole X distance
pi_hole_spacing_y = 58;      // mm -- hole-to-hole Y distance

// Fan mount: centered for even upward airflow through platform
fan_mount_x = 0;
fan_mount_y = 0;
fan_screw_spacing = 24;       // mm -- standard 30mm fan screw hole spacing
fan_screw_id = 3.0;           // mm -- M3 screw hole diameter
fan_standoff_od = 6;          // mm -- fan standoff outer diameter
fan_standoff_height = 3;      // mm -- slight elevation for intake clearance

// BME280 sensor: near wall for airflow exposure, elevated for accurate readings
bme280_mount_x = 0;
bme280_mount_y = 75;
bme280_mount_z = 20;          // mm -- elevation above floor
bme280_shelf_thickness = 1.5; // mm -- shelf plate thickness
bme280_lip_height = 2;        // mm -- retention lip to hold board edge

// Humidifier reservoir: opposite from Pi Zero to keep water away from electronics
humidifier_x = -35;
humidifier_y = 0;
humidifier_weep_hole_d = 1;   // mm -- overflow prevention drain

// Servo mount: near wall, oriented toward exhaust vent actuation path
servo_mount_x = -70;
servo_mount_y = 40;
servo_screw_spacing = 28;     // mm -- SG90/MG90S mounting hole distance
servo_screw_id = 2.0;         // mm -- M2 screw hole diameter
servo_standoff_od = 5;        // mm -- servo standoff outer diameter
servo_standoff_height = 5;    // mm -- servo standoff height

// Cable channel dimensions
// Note: depth reduced from spec's 3mm to 2mm to preserve 0.5mm of floor
// (floor is only 2.5mm thick; a full 3mm groove would puncture through)
cable_channel_width = 3;      // mm
cable_channel_depth = 2;      // mm

// =============================================================================
// Intake Vent Cutouts
// From PRODUCT-SPEC.md Section 4 -- Intake Vents
// 8 rectangular slots equally spaced (45 deg apart) around the base perimeter.
// =============================================================================

module intake_vent_cutouts() {
    for (i = [0 : intake_vent_count - 1]) {
        angle = i * (360 / intake_vent_count);  // 0, 45, 90, ...
        rotate([0, 0, angle])
            translate([base_outer_radius, 0, intake_vent_z_center])
                // Rectangular cutout oriented radially, extending through the wall
                cube(
                    [base_wall_thickness * 3,  // radial depth -- through wall with margin
                     intake_vent_width,
                     intake_vent_height],
                    center = true
                );
    }
}

// =============================================================================
// Connector Cutout Modules
// From PRODUCT-SPEC.md Section 10 -- Physical Connectors & Controls
// USB-C at 0 deg, button at ~20 deg, LED at ~35 deg -- all on one side.
// =============================================================================

/**
 * USB-C port cutout (9mm x 3.5mm rectangular)
 * Positioned at 0 degrees (rear of base), ~15mm from bottom.
 */
module usb_cutout() {
    rotate([0, 0, 0])
        translate([base_outer_radius, 0, connector_z_center])
            cube(
                [base_wall_thickness * 3,
                 usb_cutout_width,
                 usb_cutout_height],
                center = true
            );
}

/**
 * Mode button cutout (12mm diameter circular)
 * Positioned at 20 degrees from USB-C, same height.
 */
module button_cutout() {
    rotate([0, 0, 20])
        translate([base_outer_radius, 0, connector_z_center])
            rotate([0, 90, 0])
                cylinder(
                    h = base_wall_thickness * 3,
                    d = button_cutout_diameter,
                    center = true
                );
}

/**
 * LED indicator cutout (3mm diameter circular)
 * Positioned at 35 degrees from USB-C, same height.
 */
module led_cutout() {
    rotate([0, 0, 35])
        translate([base_outer_radius, 0, connector_z_center])
            rotate([0, 90, 0])
                cylinder(
                    h = base_wall_thickness * 3,
                    d = led_indicator_diameter,
                    center = true
                );
}

// =============================================================================
// Dome Seating Channel
// From PRODUCT-SPEC.md Section 2 -- Dome-to-Base Interface
// Annular groove in the top rim of the base for the dome's seating lip.
// The dome lip (2mm inset, 2mm tall) drops into this channel.
// =============================================================================

module dome_seating_channel() {
    // The channel is a ring cut down from the top surface of the base.
    // Positioned on the inner portion of the wall top edge.
    // Outer radius of channel: base_outer_radius (flush with outer wall)
    // Inner radius of channel: base_outer_radius - dome_seating_channel_width
    // Depth: dome_seating_channel_depth cut down from z = base_height

    translate([0, 0, base_height - dome_seating_channel_depth])
        difference() {
            cylinder(
                h = dome_seating_channel_depth + eps,
                r = base_outer_radius + eps,
                center = false
            );
            translate([0, 0, -eps])
                cylinder(
                    h = dome_seating_channel_depth + 3 * eps,
                    r = base_outer_radius - dome_seating_channel_width,
                    center = false
                );
        }
}

// =============================================================================
// Gasket Groove
// From PRODUCT-SPEC.md Section 2 -- Silicone gasket ring in base channel
// Smaller groove within the floor of the seating channel for the gasket.
// =============================================================================

module gasket_groove() {
    // The gasket groove sits inside the seating channel floor.
    // It is a narrower, shallower ring cut further down.
    // Position: centered within the seating channel width
    gasket_r_outer = base_outer_radius - (dome_seating_channel_width - gasket_groove_width) / 2;
    gasket_r_inner = gasket_r_outer - gasket_groove_width;

    translate([0, 0, base_height - dome_seating_channel_depth - gasket_groove_depth])
        difference() {
            cylinder(
                h = gasket_groove_depth + eps,
                r = gasket_r_outer,
                center = false
            );
            translate([0, 0, -eps])
                cylinder(
                    h = gasket_groove_depth + 3 * eps,
                    r = gasket_r_inner,
                    center = false
                );
        }
}

// =============================================================================
// Pi Zero W 2 Mount
// From PRODUCT-SPEC.md Section 8 -- Void Core Smart Electronics
// 4 standoff posts matching Pi Zero hole pattern (23mm x 58mm).
// Standoffs raise the board 5mm above the floor for under-board airflow.
// =============================================================================

module pi_mount() {
    // 4 standoff posts arranged in a rectangle centered at (pi_mount_x, pi_mount_y)
    for (dx = [-1, 1])
        for (dy = [-1, 1])
            translate([
                pi_mount_x + dx * pi_hole_spacing_x / 2,
                pi_mount_y + dy * pi_hole_spacing_y / 2,
                base_wall_thickness
            ])
                difference() {
                    cylinder(
                        h = pi_standoff_height,
                        d = pi_standoff_od,
                        center = false
                    );
                    translate([0, 0, -eps])
                        cylinder(
                            h = pi_standoff_height + 2 * eps,
                            d = pi_hole_id,
                            center = false
                        );
                }
}

// =============================================================================
// Fan Mount (30mm)
// From PRODUCT-SPEC.md Section 4 -- Void Core Active Airflow
// Central circular opening in floor for upward airflow, with 4 M3 screw
// standoffs matching the 30mm fan mounting pattern.
// =============================================================================

module fan_mount_posts() {
    // 4 standoff posts at corners of fan screw pattern
    for (dx = [-1, 1])
        for (dy = [-1, 1])
            translate([
                fan_mount_x + dx * fan_screw_spacing / 2,
                fan_mount_y + dy * fan_screw_spacing / 2,
                base_wall_thickness
            ])
                difference() {
                    cylinder(
                        h = fan_standoff_height,
                        d = fan_standoff_od,
                        center = false
                    );
                    translate([0, 0, -eps])
                        cylinder(
                            h = fan_standoff_height + 2 * eps,
                            d = fan_screw_id,
                            center = false
                        );
                }
}

/**
 * Fan airflow opening -- subtracted from the base floor.
 * 30mm diameter hole centered at (fan_mount_x, fan_mount_y).
 */
module fan_opening() {
    translate([fan_mount_x, fan_mount_y, -eps])
        cylinder(
            h = base_wall_thickness + 2 * eps,
            d = fan_diameter,
            center = false
        );
}

// =============================================================================
// BME280 Sensor Mount
// From PRODUCT-SPEC.md Section 8 -- BME280 sensor
// Small L-bracket shelf near the wall, elevated ~20mm for airflow exposure.
// A retention lip on the outer edge holds the board in place.
// =============================================================================

module sensor_mount() {
    translate([bme280_mount_x, bme280_mount_y, base_wall_thickness + bme280_mount_z]) {
        // Shelf plate (flat surface the board sits on)
        translate([0, 0, 0])
            cube(
                [bme280_width + 2 * fdm_tolerance,
                 bme280_length + 2 * fdm_tolerance,
                 bme280_shelf_thickness],
                center = true
            );

        // Retention lip on the outer (wall-facing) edge
        translate([0, (bme280_length + fdm_tolerance) / 2, bme280_shelf_thickness / 2 + bme280_lip_height / 2])
            cube(
                [bme280_width + 2 * fdm_tolerance,
                 1.5,  // lip thickness
                 bme280_lip_height + bme280_shelf_thickness],
                center = true
            );

        // Support column from floor to shelf
        translate([0, 0, -(bme280_mount_z) / 2])
            cube(
                [bme280_width / 2,
                 bme280_length / 2,
                 bme280_mount_z],
                center = true
            );
    }
}

// =============================================================================
// Humidifier Reservoir Well
// From PRODUCT-SPEC.md Section 5 -- Void Core Active Humidity
// Cylindrical reservoir for the piezoelectric humidifier disc.
// The well is formed by a raised cylindrical wall on the floor, creating a
// 25mm deep contained reservoir. A 1mm weep hole prevents overflow.
// =============================================================================

/**
 * Humidifier well wall (additive) -- cylindrical wall rising from the floor.
 * Added to the positive geometry in base_housing().
 */
module humidifier_well_wall() {
    well_wall_thickness = 2;  // mm -- wall thickness of the reservoir cylinder
    translate([humidifier_x, humidifier_y, base_wall_thickness])
        difference() {
            cylinder(
                h = humidifier_reservoir_depth,
                d = humidifier_reservoir_diameter + 2 * fdm_tolerance + 2 * well_wall_thickness,
                center = false
            );
            translate([0, 0, -eps])
                cylinder(
                    h = humidifier_reservoir_depth + 2 * eps,
                    d = humidifier_reservoir_diameter + 2 * fdm_tolerance,
                    center = false
                );
        }
}

/**
 * Humidifier weep hole (subtractive) -- 1mm drain through the base wall.
 * Prevents reservoir overflow by draining to the exterior.
 */
module humidifier_weep_hole() {
    // Horizontal 1mm hole from the bottom of the well toward the nearest wall.
    // Humidifier is at negative X, so drain extends in the negative X direction
    // through the base wall to the exterior.
    translate([humidifier_x, humidifier_y, base_wall_thickness + humidifier_weep_hole_d])
        rotate([0, -90, 0])
            cylinder(
                h = base_outer_radius - abs(humidifier_x) + eps,
                d = humidifier_weep_hole_d,
                center = false
            );
}

// =============================================================================
// Servo Mount
// From PRODUCT-SPEC.md Section 8 -- Motorized damper
// 2 standoff posts matching SG90/MG90S screw pattern for vent actuation.
// =============================================================================

module servo_mount() {
    // 2 standoff posts along the servo length axis
    for (dy = [-1, 1])
        translate([
            servo_mount_x,
            servo_mount_y + dy * servo_screw_spacing / 2,
            base_wall_thickness
        ])
            difference() {
                cylinder(
                    h = servo_standoff_height,
                    d = servo_standoff_od,
                    center = false
                );
                translate([0, 0, -eps])
                    cylinder(
                        h = servo_standoff_height + 2 * eps,
                        d = servo_screw_id,
                        center = false
                    );
            }
}

// =============================================================================
// Cable Routing Channels
// From PRODUCT-SPEC.md Section 8 -- Wiring & Cable Management
// 3mm x 3mm grooves in the base floor connecting components.
// Routes: USB-C -> Pi Zero, Pi Zero -> fan, Pi Zero -> BME280,
//         Pi Zero -> humidifier
// =============================================================================

module cable_channels() {
    // Channels are grooves cut into the top surface of the floor.
    // Floor top is at z = base_wall_thickness (2.5mm).
    // Channels cut from z = (base_wall_thickness - cable_channel_depth) to z = base_wall_thickness.
    // Using cubes centered at the midpoint of the channel depth.
    channel_z_mid = base_wall_thickness - cable_channel_depth / 2;

    // Route 1: USB-C port (at wall, 0 deg) -> Pi Zero mount
    // Runs from inner wall at 0 deg to pi_mount position
    usb_inner_x = base_inner_radius - 5;  // just inside the wall
    translate([0, 0, channel_z_mid])
        hull() {
            translate([usb_inner_x, 0, 0])
                cube([cable_channel_width, cable_channel_width, cable_channel_depth + eps], center = true);
            translate([pi_mount_x, pi_mount_y, 0])
                cube([cable_channel_width, cable_channel_width, cable_channel_depth + eps], center = true);
        }

    // Route 2: Pi Zero -> Fan (center)
    translate([0, 0, channel_z_mid])
        hull() {
            translate([pi_mount_x, pi_mount_y, 0])
                cube([cable_channel_width, cable_channel_width, cable_channel_depth + eps], center = true);
            translate([fan_mount_x, fan_mount_y, 0])
                cube([cable_channel_width, cable_channel_width, cable_channel_depth + eps], center = true);
        }

    // Route 3: Pi Zero -> BME280 sensor
    translate([0, 0, channel_z_mid])
        hull() {
            translate([pi_mount_x, pi_mount_y, 0])
                cube([cable_channel_width, cable_channel_width, cable_channel_depth + eps], center = true);
            translate([bme280_mount_x, bme280_mount_y, 0])
                cube([cable_channel_width, cable_channel_width, cable_channel_depth + eps], center = true);
        }

    // Route 4: Pi Zero -> Humidifier
    translate([0, 0, channel_z_mid])
        hull() {
            translate([pi_mount_x, pi_mount_y, 0])
                cube([cable_channel_width, cable_channel_width, cable_channel_depth + eps], center = true);
            translate([humidifier_x, humidifier_y, 0])
                cube([cable_channel_width, cable_channel_width, cable_channel_depth + eps], center = true);
        }
}

// =============================================================================
// Base Internals Assembly (additive components)
// From PRODUCT-SPEC.md Section 8 -- Void Core Smart Electronics
// Union of all internal mount posts and shelves (positive geometry).
// =============================================================================

module base_internals() {
    pi_mount();
    fan_mount_posts();
    sensor_mount();
    servo_mount();
    humidifier_well_wall();
}

// =============================================================================
// Main Base Housing Module
// =============================================================================
// Combines all base geometry:
//   Positive: outer wall, floor, platform ledge, internal mount posts
//   Negative: inner cavity, seating channel, gasket groove, vents, connectors,
//             humidifier well, fan opening, cable channels
// =============================================================================

module base_housing() {
    // Internal features (ledge, mount posts, humidifier well) must be added
    // AFTER the cavity subtraction so they aren't consumed by the hollow-out.
    // Structure: union( difference(outer_shell, cavity+cutouts), internal_features )

    union() {
        difference() {
            // === Outer shell (solid cylinder) ===
            cylinder(
                h = base_height,
                r = base_outer_radius,
                center = false
            );

            // === Negative geometry ===

            // Inner cavity (hollow out the cylinder, preserving floor)
            translate([0, 0, base_wall_thickness])
                cylinder(
                    h = base_height - base_wall_thickness + eps,
                    r = base_inner_radius,
                    center = false
                );

            // Dome seating channel (annular groove in top rim)
            dome_seating_channel();

            // Gasket groove (inside seating channel floor)
            gasket_groove();

            // 8 intake vents (rectangular slots around perimeter)
            intake_vent_cutouts();

            // USB-C port cutout
            usb_cutout();

            // Mode button cutout
            button_cutout();

            // LED indicator cutout
            led_cutout();

            // Humidifier weep hole (subtractive -- drain through wall)
            humidifier_weep_hole();

            // Fan airflow opening (subtractive -- through floor)
            fan_opening();

            // Cable routing channels (subtractive -- grooves in floor)
            cable_channels();
        }

        // === Internal features (added after cavity so they survive) ===

        // Platform support ledge (internal ring at z=45mm)
        // Narrow ring (r=67 to r=70mm) that supports the 140mm substrate platform.
        translate([0, 0, platform_ledge_z])
            difference() {
                cylinder(
                    h = platform_ledge_thickness,
                    r = platform_ledge_outer_r,
                    center = false
                );
                translate([0, 0, -eps])
                    cylinder(
                        h = platform_ledge_thickness + 2 * eps,
                        r = platform_ledge_inner_r,
                        center = false
                    );
            }

        // Internal Void Core component mounts (additive)
        base_internals();
    }
}

// =============================================================================
// Render when called directly
// =============================================================================
base_housing();
