//!Display the X-axis linear rail.

include <../scad/global_defs.scad>

include <../scad/utils/X_Rail.scad>
use <../scad/printed/PrintheadAssemblies.scad>

include <../scad/Parameters_CoreXY.scad>
use <../scad/Parameters_Positions.scad>


//$explode = 1;
module xRail_test() {
    translate(-[eSize + eX/2, carriagePosition().y, eZ - yRailOffset().x - carriage_clearance(carriageType(_xCarriageDescriptor))]) {
        //fullPrinthead(accelerometer=true);
        printheadBeltSide();
        printheadHotendSide();
        translate_z(eZ)
            xRail(carriagePosition());
    }
}

if ($preview)
    xRail_test();
