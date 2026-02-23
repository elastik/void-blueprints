// =============================================================================
// The Void -- STL Export: Base Housing
// =============================================================================
// Renders base_housing() at high quality for STL export.
// Print orientation: bottom-down (natural, stable base).
// Output: void-base.stl
// OpenSCAD: File > Export > STL
// =============================================================================

include <../parameters.scad>
use <../base.scad>

$fn = 128;  // High quality for export

base_housing();
