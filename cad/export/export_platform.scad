// =============================================================================
// The Void -- STL Export: Substrate Platform
// =============================================================================
// Renders platform() at high quality for STL export.
// Print orientation: flat (natural, bottom surface on bed).
// Output: void-platform.stl
// OpenSCAD: File > Export > STL
// =============================================================================

include <../parameters.scad>
use <../platform.scad>

$fn = 128;  // High quality for export

platform();
