// =============================================================================
// The Void -- STL Export: Upper Dome Half
// =============================================================================
// Renders dome_upper() at high quality for STL export.
// Print orientation: apex-up (natural, stable hemisphere base).
// Output: void-dome-upper.stl
// OpenSCAD: File > Export > STL
// =============================================================================

include <../parameters.scad>
use <../dome_split.scad>

$fn = 128;  // High quality for export

dome_upper();
