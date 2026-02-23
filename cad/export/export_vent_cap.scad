// =============================================================================
// The Void -- STL Export: Vent Cap Set (4x)
// =============================================================================
// Renders vent_cap_set() at high quality for STL export.
// Print orientation: flange-down (natural, flat base on bed).
// Prints all 4 vent caps in a 2x2 grid layout.
// Output: void-vent-cap.stl
// OpenSCAD: File > Export > STL
// =============================================================================

include <../parameters.scad>
use <../vent_cap.scad>

$fn = 128;  // High quality for export

vent_cap_set();
