// =============================================================================
// The Void — Base Housing Module (Golden Ratio Cloche)
// =============================================================================
// Slim 38.8mm (R/phi^2) base housing all Void Core electronics.
// Adapted from Phase 10's 89mm base to fit golden-ratio-derived height.
//
// Component layout: water (-X) separated from electronics (+X)
// to prevent moisture damage.
//
// Public API:  void_base()
// Helpers:     base_shell(), base_interior(), component_mounts(),
//              wall_cutouts(), cable_channels(), dome_seating()
// Easter egg:  _golden_spiral(), _curved_branch(), _mycelium_branches(),
//              _phi_symbol(), _easter_egg_pattern()
// =============================================================================

include <parameters.scad>

// === LOCAL CONSTANTS ===
// Internal clearance: base_h - base_floor = ~35.8mm
_inner_r = R - wall;                      // 99mm — interior radius
_internal_clearance = base_h - base_floor; // ~35.8mm available height

// Component positions (same XY layout as Phase 10, adapted Z)
// Water (-X), electronics (+X)
_pi_x = 35;
_pi_y = -25;
_fan_x = 0;
_fan_y = 0;
_sensor_x = 0;
_sensor_y = 75;
_humidifier_x = -35;
_humidifier_y = 0;
_servo_x = -70;
_servo_y = 40;

// Standoff dimensions
_standoff_od = 5;          // mm — outer diameter
_pi_hole_d = 2.5;         // M2.5
_fan_hole_d = 3;           // M3
_servo_hole_d = 2;         // M2

// === BASE SHELL ===
// Outer form from cloche_preview: cylinder + bottom chamfer ring
module base_shell() {
    // Main cylinder (above chamfer)
    translate([0, 0, base_chamfer])
        cylinder(h = base_h - base_chamfer, r = r_outer);
    // Bottom chamfer ring
    cylinder(h = base_chamfer, r1 = r_outer - base_chamfer, r2 = r_outer);
}

// === BASE INTERIOR ===
// Hollow cavity starting at floor height
module base_interior() {
    translate([0, 0, base_floor])
        cylinder(h = base_h + epsilon, r = _inner_r);
}

// === DOME SEATING ===
// Annular groove at top of base for dome bottom edge to sit in.
// Depth: 2mm into top wall, width: wall + 0.2mm tolerance
module dome_seating() {
    seat_depth = 2;
    seat_width = wall + fdm_tolerance;
    // Groove at top of base wall
    translate([0, 0, base_h - seat_depth])
        difference() {
            cylinder(h = seat_depth + epsilon, r = R + fdm_tolerance/2);
            cylinder(h = seat_depth + epsilon, r = R - seat_width + fdm_tolerance/2);
        }
}

// === COMPONENT MOUNTS ===
// All internal additive features: standoffs, walls, shelves
module component_mounts() {
    // --- Pi Zero W 2 mount (+X side) ---
    // 4 standoffs at 23x58mm pattern, M2.5 holes, 5mm height from floor
    _pi_standoffs();

    // --- Fan mount (center) ---
    // 4 standoffs at 24mm spacing, M3, 3mm height
    _fan_standoffs();

    // --- BME280 sensor shelf (+X, near wall) ---
    // 10mm elevated shelf with retention lip
    _sensor_shelf();

    // --- Humidifier well (-X side) ---
    // 40mm diameter raised wall, 22mm deep
    _humidifier_well();

    // --- Servo mount (-Y side) ---
    // 2 posts at 28mm spacing, M2 holes, 5mm height
    _servo_standoffs();
}

// --- Pi Zero standoffs ---
// 23mm x 58mm hole pattern (Pi Zero W 2 mounting holes)
module _pi_standoffs() {
    standoff_h = 5;
    dx = 23 / 2;
    dy = 58 / 2;
    for (ox = [-dx, dx], oy = [-dy, dy]) {
        translate([_pi_x + ox, _pi_y + oy, base_floor])
            difference() {
                cylinder(h = standoff_h, r = _standoff_od / 2);
                translate([0, 0, -epsilon])
                    cylinder(h = standoff_h + 2 * epsilon, r = _pi_hole_d / 2);
            }
    }
}

// --- Fan mount standoffs ---
// 24mm square spacing around center, M3 holes, 3mm height
module _fan_standoffs() {
    standoff_h = 3;
    offset = 24 / 2;
    for (ox = [-offset, offset], oy = [-offset, offset]) {
        translate([_fan_x + ox, _fan_y + oy, base_floor])
            difference() {
                cylinder(h = standoff_h, r = _standoff_od / 2);
                translate([0, 0, -epsilon])
                    cylinder(h = standoff_h + 2 * epsilon, r = _fan_hole_d / 2);
            }
    }
}

// --- BME280 sensor shelf ---
// L-bracket shelf elevated 10mm (reduced from Phase 10's 20mm)
// with retention lip to hold breakout board
module _sensor_shelf() {
    shelf_z = 10;                  // Elevation from floor (was 20mm)
    shelf_w = bme280_width + 0.4;  // Width + tolerance
    shelf_l = bme280_length + 0.4; // Length + tolerance
    shelf_t = 1.5;                 // Shelf thickness
    lip_h = 1;                     // Retention lip height

    translate([_sensor_x - shelf_w / 2, _sensor_y - shelf_l / 2, base_floor]) {
        // Support column
        cube([shelf_w, shelf_l, shelf_z]);
        // Shelf platform
        translate([0, 0, shelf_z])
            cube([shelf_w, shelf_l, shelf_t]);
        // Retention lip on two edges
        translate([0, 0, shelf_z + shelf_t])
            cube([shelf_w, 1, lip_h]);
        translate([0, shelf_l - 1, shelf_z + shelf_t])
            cube([shelf_w, 1, lip_h]);
    }
}

// --- Humidifier well ---
// Raised cylindrical wall (not floor depression — floor too thin)
// 40mm diameter, 22mm deep (adapted from 25mm for 38.8mm base)
// with weep hole at bottom for overflow
module _humidifier_well() {
    well_d = humidifier_reservoir_diameter;
    well_wall = 2;                 // Well wall thickness
    well_h = 22;                   // Depth (was 25mm in Phase 10)
    well_od = well_d + 2 * well_wall;

    translate([_humidifier_x, _humidifier_y, base_floor])
        difference() {
            // Outer wall
            cylinder(h = well_h, r = well_od / 2);
            // Inner cavity
            translate([0, 0, -epsilon])
                cylinder(h = well_h + 2 * epsilon, r = well_d / 2);
        }
}

// --- Servo mount standoffs ---
// 2 posts at 28mm spacing, M2 holes, 5mm height
module _servo_standoffs() {
    standoff_h = 5;
    spacing = 28 / 2;
    for (oy = [-spacing, spacing]) {
        translate([_servo_x, _servo_y + oy, base_floor])
            difference() {
                cylinder(h = standoff_h, r = _standoff_od / 2);
                translate([0, 0, -epsilon])
                    cylinder(h = standoff_h + 2 * epsilon, r = _servo_hole_d / 2);
            }
    }
}

// === WALL CUTOUTS ===
// All subtractive wall features: USB-C, button, LED, intake vents
module wall_cutouts() {
    // USB-C cutout (+X side, centered at z=8mm from floor)
    _usbc_cutout();

    // Button hole (+Y side, centered at z=base_h/2)
    _button_cutout();

    // LED indicator hole (+Y side, offset from button)
    _led_cutout();

    // 8 intake vent slots (evenly spaced around perimeter)
    _intake_vents();
}

// --- USB-C cutout ---
// 9mm x 3.5mm rectangular opening on +X wall
module _usbc_cutout() {
    usbc_w = 9;
    usbc_h = 3.5;
    usbc_z = base_floor + 8;  // Center at 8mm above floor

    rotate([0, 0, 0])  // +X axis (0 degrees)
        translate([r_outer - wall - epsilon, -usbc_w / 2, usbc_z - usbc_h / 2])
            cube([wall + 2 * epsilon, usbc_w, usbc_h]);
}

// --- Button hole ---
// 12mm diameter hole on +Y wall, centered vertically
module _button_cutout() {
    button_d = 12;
    button_z = base_h / 2;

    rotate([0, 0, 70])  // +Y side, offset from USB-C
        translate([r_outer - wall / 2, 0, button_z])
            rotate([0, 90, 0])
                cylinder(h = wall + 2 * epsilon, r = button_d / 2, center = true);
}

// --- LED indicator hole ---
// 3mm diameter hole on +Y wall, offset from button
module _led_cutout() {
    led_d = 3;
    led_z = base_h / 2;

    rotate([0, 0, 90])  // Offset from button
        translate([r_outer - wall / 2, 0, led_z])
            rotate([0, 90, 0])
                cylinder(h = wall + 2 * epsilon, r = led_d / 2, center = true);
}

// --- 8 intake vent slots ---
// Evenly spaced around perimeter, 10mm wide x 5mm tall
// Centered at z = base_h * 0.6 (~23mm)
module _intake_vents() {
    vent_w = 10;
    vent_h = 5;
    vent_z = base_h * 0.6;

    for (angle = [0 : 45 : 315]) {
        rotate([0, 0, angle])
            translate([r_outer - wall - epsilon, -vent_w / 2, vent_z - vent_h / 2])
                cube([wall + 2 * epsilon, vent_w, vent_h]);
    }
}

// === CABLE CHANNELS ===
// 4 hull-based floor routing channels (2mm deep in 3mm floor)
// Connecting USB-C area to Pi, Pi to fan, Pi to sensor, Pi to humidifier
module cable_channels() {
    ch_w = 3;      // Channel width
    ch_d = cable_channel_depth;  // 2mm deep (from parameters.scad)

    // Channel 1: USB-C area (+X wall) to Pi Zero
    _cable_channel(
        _inner_r - 5, 0,       // Near +X wall
        _pi_x, _pi_y,          // Pi Zero position
        ch_w, ch_d
    );

    // Channel 2: Pi Zero to fan (center)
    _cable_channel(
        _pi_x, _pi_y,
        _fan_x, _fan_y,
        ch_w, ch_d
    );

    // Channel 3: Pi Zero to BME280 sensor
    _cable_channel(
        _pi_x, _pi_y,
        _sensor_x, _sensor_y,
        ch_w, ch_d
    );

    // Channel 4: Pi Zero to humidifier
    _cable_channel(
        _pi_x, _pi_y,
        _humidifier_x, _humidifier_y,
        ch_w, ch_d
    );
}

// --- Single cable channel ---
// Hull-based groove between two XY endpoints
module _cable_channel(x1, y1, x2, y2, width, depth) {
    hull() {
        translate([x1, y1, base_floor - depth/2])
            cube([width, width, depth], center = true);
        translate([x2, y2, base_floor - depth/2])
            cube([width, width, depth], center = true);
    }
}

// === FAN FLOOR OPENING ===
// Circular opening in floor for airflow from below
module _fan_floor_opening() {
    translate([_fan_x, _fan_y, -epsilon])
        cylinder(h = base_floor + 2 * epsilon, r = fan_diameter / 2);
}

// === HUMIDIFIER WEEP HOLE ===
// 1mm hole at bottom of humidifier well, draining toward nearest wall
module _humidifier_weep_hole() {
    weep_d = 1;
    translate([_humidifier_x, _humidifier_y, base_floor + 1])
        rotate([0, -90, 0])  // Point toward -X wall (outward)
            cylinder(h = 60, r = weep_d / 2);
}

// =============================================================================
// GOLDEN EASTER EGG ENGRAVING
// =============================================================================
// Hidden on the base bottom. A golden spiral with organic mycelium
// branching at the golden angle. phi at center — the seed of everything.
// Ported verbatim from golden_easter_egg.scad (underscore-prefixed).
// Etch depth 0.8mm into 3mm floor = 2.2mm remaining.
// =============================================================================

// === GOLDEN SPIRAL ===
module _golden_spiral(width = 1.2) {
    turns = 4;
    steps_per_turn = 72;
    steps = turns * steps_per_turn;
    a = 6;                   // Start clear of phi symbol
    b = (max_radius - a) / (turns * 360);

    for (i = [0:steps-1]) {
        t1 = i * (turns * 360) / steps;
        t2 = (i + 1) * (turns * 360) / steps;
        r1 = a + b * t1;
        r2 = a + b * t2;

        // Taper: thick near center, thin at edge
        w1 = width * (1.0 - 0.4 * (r1 / max_radius));
        w2 = width * (1.0 - 0.4 * (r2 / max_radius));

        hull() {
            translate([r1 * cos(t1), r1 * sin(t1), 0])
                cylinder(h = etch_depth, r = w1/2);
            translate([r2 * cos(t2), r2 * sin(t2), 0])
                cylinder(h = etch_depth, r = w2/2);
        }
    }
}

// === ORGANIC MYCELIUM BRANCH ===
// Draws a curving branch using multiple segments (not a straight line)
module _curved_branch(start_x, start_y, angle, length, start_width, segments = 4) {
    // Slight curve: each segment bends by a small amount
    curve_rate = 8;  // degrees per segment — gentle organic curve

    for (s = [0:segments-1]) {
        seg_len = length / segments;
        a1 = angle + s * curve_rate;
        a2 = angle + (s + 1) * curve_rate;
        frac1 = s / segments;
        frac2 = (s + 1) / segments;

        // Accumulated position along curve
        px1 = start_x + seg_len * s * cos(angle + s * curve_rate / 2);
        py1 = start_y + seg_len * s * sin(angle + s * curve_rate / 2);
        px2 = start_x + seg_len * (s + 1) * cos(angle + (s + 1) * curve_rate / 2);
        py2 = start_y + seg_len * (s + 1) * sin(angle + (s + 1) * curve_rate / 2);

        // Taper to a point
        w1 = start_width * (1.0 - 0.7 * frac1);
        w2 = start_width * (1.0 - 0.7 * frac2);

        hull() {
            translate([px1, py1, 0]) cylinder(h = etch_depth, r = max(w1/2, 0.15));
            translate([px2, py2, 0]) cylinder(h = etch_depth, r = max(w2/2, 0.15));
        }
    }
}

// === MYCELIUM NETWORK ===
module _mycelium_branches(width = 1.0) {
    turns = 4;
    steps = turns * 72;
    a = 6;
    b = (max_radius - a) / (turns * 360);

    // Primary branches: 14 main hyphae extending from the spiral
    primary_count = 14;
    spacing = floor(steps / primary_count);

    for (bi = [0:primary_count-1]) {
        i = bi * spacing + floor(spacing / 2.5);
        theta = i * (turns * 360) / steps;
        r = a + b * theta;
        x = r * cos(theta);
        y = r * sin(theta);
        bw = width * (1.0 - 0.3 * (r / max_radius));

        // Primary branch — outward at golden angle
        branch_angle = theta + golden_angle;
        branch_len = min(10 + bi * 1.8, (max_radius - r) * 0.85);

        if (branch_len > 4) {
            // Main hypha (curving)
            _curved_branch(x, y, branch_angle, branch_len, bw, 5);

            // Secondary fork at ~55% along primary, golden angle offset
            fork_frac = 0.55;
            // Approximate position along curved branch
            fork_x = x + branch_len * fork_frac * cos(branch_angle + 4 * fork_frac * 8 / 2);
            fork_y = y + branch_len * fork_frac * sin(branch_angle + 4 * fork_frac * 8 / 2);
            fork_angle = branch_angle + golden_angle * 0.5 + 15;
            fork_len = branch_len * 0.5;

            _curved_branch(fork_x, fork_y, fork_angle, fork_len, bw * 0.5, 3);

            // Tertiary fork — finest mycelium detail
            if (branch_len > 10) {
                t_frac = 0.3;
                t_x = x + branch_len * t_frac * cos(branch_angle + 4 * t_frac * 8 / 2);
                t_y = y + branch_len * t_frac * sin(branch_angle + 4 * t_frac * 8 / 2);
                t_angle = branch_angle - golden_angle * 0.35;
                t_len = branch_len * 0.3;

                _curved_branch(t_x, t_y, t_angle, t_len, bw * 0.3, 2);
            }

            // Opposite-side fork on some branches for asymmetry
            if (bi % 3 == 0 && branch_len > 8) {
                opp_frac = 0.7;
                opp_x = x + branch_len * opp_frac * cos(branch_angle + 4 * opp_frac * 8 / 2);
                opp_y = y + branch_len * opp_frac * sin(branch_angle + 4 * opp_frac * 8 / 2);
                opp_angle = branch_angle - golden_angle * 0.4;
                opp_len = branch_len * 0.35;

                _curved_branch(opp_x, opp_y, opp_angle, opp_len, bw * 0.35, 2);
            }
        }
    }
}

// === PHI SYMBOL ===
module _phi_symbol() {
    w = line_width * 0.7;
    // Vertical stroke
    hull() {
        translate([0, -5.5, 0]) cylinder(h = etch_depth, r = w/2);
        translate([0, 5.5, 0]) cylinder(h = etch_depth, r = w/2);
    }
    // Elliptical ring
    difference() {
        scale([1.2, 1, 1]) cylinder(h = etch_depth, r = 3.8);
        translate([0, 0, -0.1])
            scale([1.2, 1, 1]) cylinder(h = etch_depth + 0.2, r = 3.8 - w);
    }
}

// === COMPLETE EASTER EGG PATTERN ===
module _easter_egg_pattern() {
    _golden_spiral(width = line_width);
    _mycelium_branches(width = line_width * 0.85);
    _phi_symbol();
}

// === PUBLIC: Complete base housing ===
// Combines all additive and subtractive features.
// Includes golden easter egg engraving on base bottom.
module void_base() {
    difference() {
        union() {
            base_shell();           // Outer form with chamfer
            component_mounts();     // Internal posts, walls, shelves
        }
        base_interior();           // Hollow interior
        wall_cutouts();            // USB-C, button, LED, intake vents
        cable_channels();          // Floor routing
        dome_seating();            // Top groove for dome
        _fan_floor_opening();      // Airflow opening
        _humidifier_weep_hole();   // Overflow drain
        // Easter egg engraving on base bottom
        translate([0, 0, -0.01])
            _easter_egg_pattern();
    }
}

// === Standalone preview ===
void_base();
