//! Display the Voron Afterburner X carriage

include <../scad/global_defs.scad>

use <../scad/printed/PrintheadAssemblies.scad>
use <../scad/printed/Y_CarriageAssemblies.scad>
use <../scad/MainAssemblyVoronAfterburner.scad>

include <../scad/utils/CoreXYBelts.scad>
include <../scad/utils/X_Rail.scad>


use <../scad/Parameters_Positions.scad>

//$explode = 1;
//$pose = 1;
t = 2;

module VoronAfterburner_test() {
    carriagePosition = carriagePosition();
    translate(-[eSize + eX/2, carriagePosition.y, eZ - yRailOffset().x - carriage_clearance(carriageType(_xCarriageDescriptor))]) {
        //CoreXYBelts(carriagePosition + [2, 0], x_gap = -25, show_pulleys = ![1, 0, 0]);
        rotate = 180;
        printheadBeltSide(rotate + 180);
        //printheadHotendSide(rotate + 180);
        printheadVoronAfterburner(rotate);
        translate_z(eZ)
            xRail(carriagePosition, MGN12H_carriage);
        *translate([0, carriagePosition.y - carriagePosition().y, eZ - eSize])
            Y_Carriage_Left_assembly();
        *translate([2*eSize + eX, carriagePosition.y - carriagePosition().y, eZ - eSize])
            Y_Carriage_Right_assembly();
    }
}

if ($preview)
    VoronAfterburner_test();
