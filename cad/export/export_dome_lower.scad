// =============================================================================
// The Void -- STL Export: Lower Dome Half
// =============================================================================
// Renders dome_lower() at high quality for STL export.
// Print orientation: lip-down (natural, stable base).
// Output: void-dome-lower.stl
// OpenSCAD: File > Export > STL
// =============================================================================

include <../parameters.scad>
use <../dome_split.scad>

$fn = 128;  // High quality for export

dome_lower();
