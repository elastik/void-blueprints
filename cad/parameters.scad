// =============================================================================
// The Void -- Parametric Constants Module
// =============================================================================
//
// All dimensions for The Void mushroom cultivation dome.
// Units: millimeters (mm) unless otherwise noted.
// Source: PRODUCT-SPEC.md
//
// Usage: include <parameters.scad> in any module file.
// =============================================================================

// -----------------------------------------------------------------------------
// Global Settings
// -----------------------------------------------------------------------------

// Render quality: set quality = "preview" for fast preview, "render" for final
// From PRODUCT-SPEC.md OpenSCAD conventions
quality = "preview";  // "preview" or "render"
$fn = (quality == "render") ? 128 : 64;

// FDM printing tolerance / clearance
// Standard FDM tolerance for friction-fit parts
fdm_tolerance = 0.2;  // mm -- default clearance for FDM printing

// Small epsilon for boolean operations (prevents z-fighting)
eps = 0.01;  // mm

// -----------------------------------------------------------------------------
// Overall Dimensions
// From PRODUCT-SPEC.md Section 1 -- Overall Dimensions
// -----------------------------------------------------------------------------

total_diameter = 203;   // mm (8.0") -- widest point at dome-base junction
total_height   = 254;   // mm (10.0") -- dome + base assembled
dome_height    = 165;   // mm (6.5") -- from base top to dome apex
base_height    = 89;    // mm (3.5") -- houses electronics, platform, airflow plenum

// -----------------------------------------------------------------------------
// Dome Parameters
// From PRODUCT-SPEC.md Section 2 -- Dome Shell
// -----------------------------------------------------------------------------

dome_outer_diameter = 203;  // mm (8.0") -- matches total_diameter
dome_inner_diameter = 190;  // mm (7.5") -- wall thickness reduces usable interior
dome_wall_thickness = 2.0;  // mm -- structural integrity + light diffusion

// Dome geometry breakdown
dome_vertical_sidewall_height = 25;   // mm (1.0") -- straight-walled section at base
dome_hemisphere_height        = 140;  // mm (dome_height - sidewall = 165 - 25)
dome_apex_flat                = 10;   // mm -- flat at top for clean 3D print bridging

// Derived dome radii
dome_outer_radius = dome_outer_diameter / 2;  // 101.5 mm
dome_inner_radius = dome_inner_diameter / 2;  // 95.0 mm

// Exhaust vents (dome upper)
// From PRODUCT-SPEC.md Section 4 -- Exhaust Vents
exhaust_vent_diameter        = 12;   // mm (0.47") -- individual hole diameter
exhaust_vent_count           = 4;    // quantity -- evenly spaced around circumference
exhaust_vent_angle_from_apex = 60;   // degrees -- position in upper third of dome

// Magnet pocket (dome seating lip)
// From PRODUCT-SPEC.md Section 2 -- Magnetic reed switch integration
magnet_pocket_diameter = 6.5;  // mm -- sized for 6mm neodymium disc magnet + clearance
magnet_pocket_depth    = 2.5;  // mm -- depth into dome seating lip

// Alignment notch (dome seating lip)
// From PRODUCT-SPEC.md Section 2 -- Dome-to-Base Interface
alignment_notch_width = 5;  // mm -- single notch for dome orientation
alignment_notch_depth = 3;  // mm -- depth of rectangular cutout in seating lip

// Seating lip
// From PRODUCT-SPEC.md Section 2 -- Dome-to-Base Interface
dome_seating_lip_height = 2.0;  // mm -- inward step at bottom edge of dome
dome_seating_lip_inset  = 2.0;  // mm -- how far inward the lip steps

// -----------------------------------------------------------------------------
// Base Parameters
// From PRODUCT-SPEC.md Section 3 -- Base Unit
// -----------------------------------------------------------------------------

base_outer_diameter = 203;  // mm (8.0") -- matches dome diameter for flush fit
// base_height already defined above (89 mm)
base_wall_thickness = 2.5;  // mm -- slightly thicker than dome for rigidity

// Dome seating channel (base top rim)
// From PRODUCT-SPEC.md Section 2 -- Dome-to-Base Interface
dome_seating_channel_depth = 2.0;  // mm -- recessed channel in base top surface
dome_seating_channel_width = 2.0;  // mm -- width of the seating groove

// Silicone gasket groove
// From PRODUCT-SPEC.md Section 2 -- silicone gasket ring in base channel
gasket_groove_depth = 1.5;  // mm -- groove for silicone gasket ring
gasket_groove_width = 2.0;  // mm -- width of gasket groove

// Intake vents (base lower perimeter)
// From PRODUCT-SPEC.md Section 4 -- Intake Vents
intake_vent_width  = 15;  // mm (0.6") -- individual slot width
intake_vent_height = 5;   // mm (0.2") -- individual slot height
intake_vent_count  = 8;   // quantity -- evenly distributed around circumference

// USB-C cutout (rear-center of base)
// From PRODUCT-SPEC.md Section 10 -- Physical Connectors
usb_cutout_width  = 9;    // mm -- rectangular cutout for USB-C receptacle
usb_cutout_height = 3.5;  // mm -- height of USB-C cutout

// Mode button cutout (front-center of base)
// From PRODUCT-SPEC.md Section 10 -- Physical Controls
button_cutout_diameter = 12;  // mm -- waterproof silicone-cap tactile switch

// Red indicator LED hole
// From PRODUCT-SPEC.md Section 10 -- Visual Indicators
led_indicator_diameter = 3;  // mm -- 3mm through-hole LED

// -----------------------------------------------------------------------------
// Platform Parameters
// From PRODUCT-SPEC.md Section 3 -- Substrate Platform
// -----------------------------------------------------------------------------

platform_diameter  = 140;  // mm (5.5") -- centered in base, sized for Void Pack
platform_depth     = 13;   // mm (0.5") -- shallow recessed well
platform_rim_height = 6;   // mm (0.25") -- raised lip prevents block sliding

// Drain slots in platform
// From PRODUCT-SPEC.md Section 3 -- Substrate Platform (4-6 drain slots)
drain_slot_count  = 6;   // quantity
drain_slot_width  = 4;   // mm
drain_slot_length = 20;  // mm

// -----------------------------------------------------------------------------
// Void Core Additions
// From PRODUCT-SPEC.md Section 8 -- Void Core Smart Electronics
// -----------------------------------------------------------------------------

// Raspberry Pi Zero W 2 dimensions
pi_zero_width  = 30;  // mm -- board width
pi_zero_length = 65;  // mm -- board length

// 30mm axial fan
// From PRODUCT-SPEC.md Section 4 -- Void Core Active Airflow
fan_diameter = 30;  // mm -- 5V DC axial fan
fan_depth    = 10;  // mm -- fan thickness

// BME280 sensor breakout board
// From PRODUCT-SPEC.md Section 8 -- BME280 sensor
bme280_width  = 13;  // mm -- typical breakout board width
bme280_length = 11;  // mm -- typical breakout board length

// Piezoelectric humidifier reservoir
// From PRODUCT-SPEC.md Section 5 -- Void Core Active Humidity
humidifier_reservoir_diameter = 40;  // mm -- reservoir well diameter
humidifier_reservoir_depth    = 25;  // mm -- reservoir well depth

// Motorized damper servo
// From PRODUCT-SPEC.md Section 8 -- Motorized damper
servo_width  = 12;  // mm -- small servo width
servo_length = 23;  // mm -- small servo length

// -----------------------------------------------------------------------------
// Vent Cap Parameters
// From PRODUCT-SPEC.md Section 4 -- Exhaust Vent Cover Design
// From BUILD-GUIDE.md Section 2 -- void-vent-cap.stl
// -----------------------------------------------------------------------------

vent_cap_outer_diameter  = 16;   // mm (exhaust_vent_diameter + 4mm lip)
vent_cap_inner_diameter  = 12;   // mm -- matches exhaust vent hole diameter
vent_cap_depth           = 4;    // mm -- depth of cap body
vent_cap_snap_thickness  = 1.0;  // mm -- snap-fit tab thickness
