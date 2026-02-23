// =============================================================================
// The Void — Golden Ratio Easter Egg (Final Engraving)
// =============================================================================
// Hidden on the base bottom. A golden spiral with organic mycelium
// branching at the golden angle. φ at center — the seed of everything.
//
// "Simplicity is the ultimate sophistication." — Leonardo da Vinci
// =============================================================================

$fn = 64;

phi = 1.6180339887;
golden_angle = 137.507764;  // 360° / φ²

// === BASE DIMENSIONS ===
D = 203;
R = D / 2;
base_h = R / (phi * phi);
wall = 2.5;
base_overhang = wall * phi;
r_outer = R + base_overhang;

// === ENGRAVING PARAMETERS ===
etch_depth = 0.8;
line_width = 1.2;
max_radius = R - 8;         // Pattern boundary

// === GOLDEN SPIRAL ===
module golden_spiral(width = 1.2) {
    turns = 4;
    steps_per_turn = 72;
    steps = turns * steps_per_turn;
    a = 6;                   // Start clear of φ symbol
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
module curved_branch(start_x, start_y, angle, length, start_width, segments = 4) {
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
module mycelium_branches(width = 1.0) {
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
            curved_branch(x, y, branch_angle, branch_len, bw, 5);

            // Secondary fork at ~55% along primary, golden angle offset
            fork_frac = 0.55;
            // Approximate position along curved branch
            fork_x = x + branch_len * fork_frac * cos(branch_angle + 4 * fork_frac * 8 / 2);
            fork_y = y + branch_len * fork_frac * sin(branch_angle + 4 * fork_frac * 8 / 2);
            fork_angle = branch_angle + golden_angle * 0.5 + 15;
            fork_len = branch_len * 0.5;

            curved_branch(fork_x, fork_y, fork_angle, fork_len, bw * 0.5, 3);

            // Tertiary fork — finest mycelium detail
            if (branch_len > 10) {
                t_frac = 0.3;
                t_x = x + branch_len * t_frac * cos(branch_angle + 4 * t_frac * 8 / 2);
                t_y = y + branch_len * t_frac * sin(branch_angle + 4 * t_frac * 8 / 2);
                t_angle = branch_angle - golden_angle * 0.35;
                t_len = branch_len * 0.3;

                curved_branch(t_x, t_y, t_angle, t_len, bw * 0.3, 2);
            }

            // Opposite-side fork on some branches for asymmetry
            if (bi % 3 == 0 && branch_len > 8) {
                opp_frac = 0.7;
                opp_x = x + branch_len * opp_frac * cos(branch_angle + 4 * opp_frac * 8 / 2);
                opp_y = y + branch_len * opp_frac * sin(branch_angle + 4 * opp_frac * 8 / 2);
                opp_angle = branch_angle - golden_angle * 0.4;
                opp_len = branch_len * 0.35;

                curved_branch(opp_x, opp_y, opp_angle, opp_len, bw * 0.35, 2);
            }
        }
    }
}

// === PHI SYMBOL ===
module phi_symbol() {
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

// === COMPLETE PATTERN ===
module easter_egg_pattern() {
    golden_spiral(width = line_width);
    mycelium_branches(width = line_width * 0.85);
    phi_symbol();
}

// === BASE WITH ENGRAVING ===
module base_with_easter_egg() {
    difference() {
        // Base body
        union() {
            translate([0, 0, 2])
                cylinder(h = base_h - 2, r = r_outer);
            cylinder(h = 2, r1 = r_outer - 2, r2 = r_outer);
        }
        // Hollow interior
        translate([0, 0, 3])
            cylinder(h = base_h, r = R - wall);
        // Easter egg engraving on bottom
        translate([0, 0, -0.01])
            easter_egg_pattern();
    }
}

// === RENDER ===
// Flip base to show engraved bottom
rotate([180, 0, 0])
    translate([0, 0, -base_h])
        base_with_easter_egg();
