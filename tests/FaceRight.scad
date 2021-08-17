//! Display the right face

include <NopSCADlib/core.scad>

use <../scad/printed/extruderBracket.scad>
use <../scad/printed/IEC_Housing.scad>

use <../scad/utils/Z_Rods.scad>
use <../scad/utils/CoreXYBelts.scad>

use <../scad/vitamins/Panels.scad>

use <../scad/FaceRight.scad>
use <../scad/FaceRightExtras.scad>
use <../scad/FaceLeft.scad>
use <../scad/FaceTop.scad>

use <../scad/Parameters_Positions.scad>
include <../scad/Parameters_Main.scad>


//$explode = 1;
//$pose = 1;
module Right_Side_test() {
    //CoreXYBelts(carriagePosition(), show_pulleys=!true);
    Right_Side_assembly();
    //Left_Side_assembly();
    //Face_Top_assembly();
    //faceRightSpoolHolder();
    //faceRightSpool();
    //zRods(left=false);
    //Extruder_Bracket_assembly();
    //iecHousing();
    //IEC_Housing_stl();
    //IEC_Housing_Mount_stl();
    //IEC_Housing_assembly();

    //faceRightExtras();
    //Extruder_Bracket_stl();
    faceRightSpoolHolder();
    faceRightSpoolHolderBracket();
    faceRightSpoolHolderBracketHardware();
    //faceRightSpool();

    // always add the panels last, so it is transparent to other items
    //Right_Side_Panel_assembly();
    //Partition_assembly();
}

if ($preview)
    translate([-eX - 2*eSize, 0, 0])
        Right_Side_test();
