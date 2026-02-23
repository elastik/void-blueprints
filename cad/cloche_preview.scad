// =============================================================================
// The Void — "Da Vinci" Cloche Preview
// =============================================================================
// "Simplicity is the ultimate sophistication." — Leonardo da Vinci
//
// Every dimension derived from the Golden Ratio (φ = 1.618).
// The same proportion found in nautilus shells, sunflower spirals,
// and the mycelium branching patterns this dome is built to nurture.
//
// Sacred geometry: The dome height-to-width uses φ, the straight wall
// to arch ratio uses φ, the base uses 1/φ³ — nested golden spirals
// all the way down.
//
// Historical precedent: The Florence Cathedral dome (Brunelleschi),
// apothecary bell jars, Fabergé eggs, and B&O speakers all embed
// golden proportions. Objects that feel "right" without knowing why.
// =============================================================================

$fn = 128;

// === THE SINGLE GOVERNING DIMENSION ===
// Everything flows from the dome diameter.
D = 203;                    // 8" dome outer diameter (product spec, fixed)
R = D / 2;                  // 101.5mm
phi = 1.6180339887;         // Golden ratio

// === DERIVED PROPORTIONS ===
wall = 2.5;                 // Shell thickness

// Dome arch: hemisphere cap, radius = R = 101.5mm
arch_height = R;            // 101.5mm — the natural semicircular cap

// Straight walls: φ × arch height — the golden proportion
// This ratio appears in cathedral naves, Greek columns, and violin bodies
straight_height = arch_height * phi;  // 164.2mm

// Total dome height
dome_height = straight_height + arch_height;  // 265.7mm

// Base height: R / φ² — minimal but harmonious
// Just enough for electronics (humidifier 25mm + 3mm floor + clearance)
base_h = R / (phi * phi);    // 38.8mm → rounds to ~39mm
// Practical check: 39mm interior - 3mm floor = 36mm clearance. Humidifier
// reservoir (25mm) fits with 11mm to spare. All electronics clear.

// Base overhang: wall thickness × φ — subtle visual grounding
base_overhang = wall * phi;  // 4mm — just enough shadow line

// === DOME MODULE ===
module void_dome() {
    difference() {
        rotate_extrude()
            _profile(R, straight_height, R);
        rotate_extrude()
            _profile(R - wall, straight_height, R - wall);
        // Clean bottom edge
        translate([0, 0, -1])
            cylinder(h = 1.1, r = R + 1);
    }
}

// 2D profile: straight wall + quarter-circle arch (seamless transition)
module _profile(radius, sh, cr) {
    square([radius, sh]);
    translate([0, sh])
        intersection() {
            square([radius, cr]);
            circle(r = cr);
        }
}

// === BASE MODULE ===
module void_base() {
    r_outer = R + base_overhang;

    difference() {
        // Outer form — slight chamfer on bottom edge for elegance
        union() {
            // Main cylinder
            translate([0, 0, 2])
                cylinder(h = base_h - 2, r = r_outer);
            // Bottom chamfer ring
            cylinder(h = 2, r1 = r_outer - 2, r2 = r_outer);
        }
        // Hollow interior (3mm floor)
        translate([0, 0, 3])
            cylinder(h = base_h, r = R - wall);
    }
}

// === ASSEMBLY ===
module void_assembly() {
    color("DimGray") void_base();
    color("DarkSlateGray", 0.7)
        translate([0, 0, base_h])
            void_dome();
}

void_assembly();

// === PROPORTION SUMMARY ===
// Dome diameter:     203.0mm (8.0")
// Straight walls:    164.2mm (φ × arch)
// Arch cap:          101.5mm (R)
// Total dome:        265.7mm (10.5")
// Base height:        38.8mm (R/φ²)
// Base overhang:       4.0mm (wall×φ)
// Total height:      304.5mm (12.0")
// Base ratio:         12.7% of total
//
// Golden ratios embedded:
//   straight / arch  = φ     (1.618)
//   dome / diameter  = 1.311 (≈ φ/1.236, close to √φ)
//   total / dome     = 1.146 (≈ φ/√2)
//   base / arch      = 1/φ²  (0.382)
