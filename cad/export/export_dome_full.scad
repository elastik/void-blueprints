// =============================================================================
// The Void -- STL Export: Full Dome Shell
// =============================================================================
// Renders dome_shell() at high quality for STL export.
// Output: void-dome-full.stl
// OpenSCAD: File > Export > STL
// =============================================================================

include <../parameters.scad>
use <../dome.scad>

$fn = 128;  // High quality for export

dome_shell();
