// =============================================================================
// The Void -- Substrate Platform Module
// =============================================================================
//
// A shallow dish that holds the substrate block inside the dome.
// Sits on the base's internal support ledge at z=45mm.
//
// Geometry:
//   1. Base disc -- 140mm diameter, 2mm thick solid floor
//   2. Rim wall -- 6mm above disc surface, 2mm thick perimeter wall
//   3. Drain slots -- 6 radial slots (4mm x 20mm) cut through the floor
//   4. Drainage ribs -- 8 small radial ridges (1mm tall, 1.5mm wide)
//      on the floor between drain slots, elevating substrate for drainage
//
// The platform diameter (140mm) fits inside the base inner diameter (198mm)
// with clearance, and rests on the 3mm wide ledge ring at z=45mm.
//
// Source: PRODUCT-SPEC.md Section 3 -- Substrate Platform
// =============================================================================

include <parameters.scad>

// -----------------------------------------------------------------------------
// Derived platform constants
// -----------------------------------------------------------------------------

_plat_r = platform_diameter / 2;        // 70 mm -- platform outer radius
_plat_floor_h = 2;                      // mm -- floor disc thickness
_plat_rim_h = platform_rim_height + _plat_floor_h;  // 8 mm -- total rim height
_plat_rim_thickness = 2;                // mm -- rim wall thickness

// Drain slot positioning
// Slots start ~10mm inside the rim and extend toward center
_drain_start_r = _plat_r - 10;         // 60 mm -- outer end of slot (near rim)
_drain_end_r = _drain_start_r - drain_slot_length;  // 40 mm -- inner end of slot

// Drainage rib parameters
_rib_count = 8;                         // number of radial ribs
_rib_height = 1;                        // mm -- raised above floor surface
_rib_width = 1.5;                       // mm -- rib cross-section width
_rib_inner_r = 10;                      // mm -- ribs start 10mm from center
_rib_outer_r = _plat_r - _plat_rim_thickness - 2;  // mm -- stop 2mm before rim

// =============================================================================
// platform() -- Main substrate platform module
// =============================================================================
// Creates the shallow dish with rim, drain slots, and drainage ribs.
// Origin at center of disc bottom surface.
// =============================================================================

module platform() {
    difference() {
        union() {
            // 1. Base disc (solid floor)
            cylinder(
                h = _plat_floor_h,
                r = _plat_r,
                center = false
            );

            // 2. Rim wall (perimeter)
            // A hollow cylinder extending above the disc surface
            difference() {
                cylinder(
                    h = _plat_rim_h,
                    r = _plat_r,
                    center = false
                );
                translate([0, 0, -eps])
                    cylinder(
                        h = _plat_rim_h + 2 * eps,
                        r = _plat_r - _plat_rim_thickness,
                        center = false
                    );
            }

            // 3. Drainage ribs (small radial ridges on floor surface)
            // 8 ribs evenly spaced (45 deg apart), raised 1mm above the floor
            // These elevate the substrate block so water flows underneath
            // to the drain slots.
            for (i = [0 : _rib_count - 1]) {
                rotate([0, 0, i * (360 / _rib_count)])
                    translate([(_rib_inner_r + _rib_outer_r) / 2, 0, _plat_floor_h + _rib_height / 2])
                        cube(
                            [_rib_outer_r - _rib_inner_r,
                             _rib_width,
                             _rib_height],
                            center = true
                        );
            }
        }

        // 4. Drain slots (cut through the floor)
        // 6 radial slots equally spaced (60 deg apart)
        // Each is a rectangular cutout extending through the full floor thickness
        for (i = [0 : drain_slot_count - 1]) {
            rotate([0, 0, i * (360 / drain_slot_count)])
                translate([(_drain_start_r + _drain_end_r) / 2, 0, _plat_floor_h / 2])
                    cube(
                        [drain_slot_length,
                         drain_slot_width,
                         _plat_floor_h + 2 * eps],
                        center = true
                    );
        }
    }
}

// =============================================================================
// Render when called directly
// =============================================================================
platform();
