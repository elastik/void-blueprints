// =============================================================================
// The Void — Parametric Constants (Golden Ratio Cloche)
// =============================================================================
// Every proportion derived from φ = 1.618 and the 8" dome diameter.
// The same ratio found in nautilus shells, sunflower spirals,
// and the mycelium branching patterns this dome nurtures.
//
// Design lineage: D → R → arch → straight (×φ) → base (÷φ²)
// =============================================================================

// === GLOBAL ===
quality = "preview";  // "preview" or "render"
$fn = (quality == "render") ? 128 : 64;

phi = 1.6180339887;          // Golden ratio
golden_angle = 137.507764;   // 360° / φ²
fdm_tolerance = 0.2;         // mm — FDM print tolerance
epsilon = 0.01;              // mm — CSG overlap

// === OVERALL DIMENSIONS ===
D = 203;                     // 8" dome outer diameter (product spec, fixed)
R = D / 2;                   // 101.5mm
wall = 2.5;                  // mm — shell thickness

// === DOME SHELL ===
// Derivation chain: R → arch_height → straight_height (×φ) → dome_height
arch_height = R;                              // 101.5mm — semicircular cap
straight_height = arch_height * phi;          // 164.2mm — φ × arch
dome_height = straight_height + arch_height;  // 265.7mm — total dome

// === BASE HOUSING ===
// Derivation chain: R → base_h (÷φ²), wall → base_overhang (×φ)
base_h = R / (phi * phi);      // 38.8mm — R/φ²
base_overhang = wall * phi;     // 4.0mm — wall×φ
base_floor = 3;                 // mm — floor thickness
base_chamfer = 2;               // mm — bottom edge chamfer
r_outer = R + base_overhang;    // 105.5mm — total base radius

// === PLATFORM ===
platform_diameter = 140;        // mm — growing platform
platform_rim_height = 6;        // mm — rim around edge
platform_z = base_floor + 2;    // mm — clearance above base floor

// === VOID CORE COMPONENTS ===
// Port from Phase 10 — internal electronics layout unchanged by dome shape

// Raspberry Pi Zero W 2
pi_zero_width  = 30;   // mm
pi_zero_length = 65;   // mm

// 30mm axial fan
fan_diameter = 30;      // mm
fan_depth    = 10;      // mm

// BME280 sensor breakout
bme280_width  = 13;    // mm
bme280_length = 11;    // mm

// Humidifier reservoir
humidifier_reservoir_diameter = 40;  // mm
humidifier_reservoir_depth    = 25;  // mm

// Servo
servo_width  = 12;     // mm
servo_length = 23;     // mm

// Cable channel
cable_channel_depth = 2;  // mm — preserves floor integrity

// === VENT SYSTEM ===
vent_hole_diameter = 12;      // mm — exhaust vent holes
vent_cap_flange = 16;         // mm — cap outer flange
vent_cap_insert = 11.8;       // mm — 12 - 2×fdm_tolerance
vent_cap_snap_protrusion = 1; // mm

// === EASTER EGG ENGRAVING ===
etch_depth = 0.8;       // mm
line_width = 1.2;        // mm
max_radius = R - 8;      // mm — pattern boundary

// =============================================================================
// PROPORTION SUMMARY
// =============================================================================
// Dome diameter:     203.0mm (8.0")
// Straight walls:    164.2mm (φ × arch)
// Arch cap:          101.5mm (R)
// Total dome:        265.7mm (10.5")
// Base height:        38.8mm (R/φ²)
// Base overhang:       4.0mm (wall×φ)
// Total height:      304.5mm (12.0")
//
// Golden ratios embedded:
//   straight / arch  = φ     (1.618)
//   base / arch      = 1/φ²  (0.382)
//   overhang / wall  = φ     (1.618)
// =============================================================================
