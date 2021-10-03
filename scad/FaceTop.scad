include <global_defs.scad>

include <NopSCADlib/utils/core/core.scad>
use <NopSCADlib/utils/fillet.scad>
include <NopSCADlib/vitamins/rails.scad>

use <printed/CameraMount.scad>
use <printed/PrintheadAssemblies.scad>
use <printed/TopCornerPiece.scad>
use <printed/WiringGuide.scad>
use <printed/XY_MotorMount.scad>
use <printed/XY_Idler.scad>
use <printed/Y_CarriageAssemblies.scad>

use <utils/FrameBolts.scad>
use <utils/carriageTypes.scad>
use <utils/RailNutsAndBolts.scad>
use <utils/CoreXYBelts.scad>
use <utils/X_Rail.scad>

include <vitamins/bolts.scad>
use <vitamins/extrusion.scad>

use <Parameters_Positions.scad>
include <Parameters_Main.scad>

function use2060ForTop() = !is_undef(_use2060ForTop) && _use2060ForTop;


//!1. Bolt the two motor mounts and the **Wiring_Guide** to the rear extrusion.
//!2. Bolt the two idlers to the front extrusion.
//!3. Screw the bolts into the ends of the front and rear extrusions.
//!4. Insert the t-nuts for the **Top_Corner_Piece**s into the extrusions.
//!5. Bolt the front and rear extrusions to the side extrusions, leaving the bolts slightly loose.
//!6. Bolt the **Top_Corner_Piece**s to the extrusions leaving the bolts slightly loose.
//!7. Turn the top face upside down and place on a flat surface. Ensure it is square and tighten the hidden bolts.
//!8. Turn the top face the right way up and tighten the bolts on the **Top_Corner_Piece**s.
//
module Face_Top_Stage_1_assembly()
assembly("Face_Top_Stage_1", big=true, ngb=true) {
    Left_Side_Upper_Extrusion_assembly();
    Right_Side_Upper_Extrusion_assembly();

    if (is_undef($hide_corexy) || !$hide_corexy) {
        explode(-120)
            XY_Idler_Left_assembly();
        explode(-100)
            XY_Motor_Mount_Left_assembly();
        explode(-120)
            XY_Idler_Right_assembly();
        explode(-100)
            XY_Motor_Mount_Right_assembly();
    }
    faceTopFront();
    faceTopBack();
    wiringGuidePosition(offset=0) {
        stl_colour(pp1_colour)
            Wiring_Guide_stl();
        Wiring_Guide_hardware();
    }
    *cameraMountPosition() {
        stl_colour(pp1_colour)
            Camera_Mount_stl();
        Camera_Mount_hardware();
    }
    translate_z(eZ)
        topCornerPieceAssembly(0);
    translate([eX + 2*eSize, 0, eZ])
        topCornerPieceAssembly(90);
    translate([eX + 2*eSize, eY + 2*eSize, eZ])
        topCornerPieceAssembly(180);
    translate([0, eY + 2*eSize, eZ])
        topCornerPieceAssembly(270);
}

//!1. Bolt the MGN rail to the Y_Carriages as shown. Ensure the MGN rail is square to the frame.
//!2. Turn the top face upside down and place on a flat surface. Rack the right side linear rail - move the X-rail
//!to one extreme of the frame and tighten the bolts on that end of the Y-rail. Then move the X-rail to the other
//!extreme and tighten the bolts on that end of the Y-rail. Finally tighten the remaining bolts on the Y-rail.
//!3. Ensure the X-rail moves freely, if it doesn't loosen the bolts you have just tightened and repeat step 2.
//
module Face_Top_Stage_2_assembly()
assembly("Face_Top_Stage_2", big=true, ngb=true) {

    Face_Top_Stage_1_assembly();
    //hidden() Y_Carriage_Left_AL_dxf();
    //hidden() Y_Carriage_Right_AL_dxf();

    translate_z(eZ)
        explode(100, true) {
            xRail(carriagePosition());
            xRailBoltPositions(carriagePosition())
                explode(20, true)
                    boltM3Caphead(10);
        }
}

//!1. Bolt the **X_Carriage_Belt_Side_MGN12H_assembly** to the MGN carriage.
//!2. Thread the belts as shown and attach them to the **X_Carriage_Belt_Side_MGN12H_assembly**
//! using the **X_Carriage_Belt_Clamp**s
//!3. Leave the belts fairly loose - tensioning of the belts is done after the frame is assembled.
//
module Face_Top_assembly()
assembly("Face_Top", big=true) {

    Face_Top_Stage_2_assembly();

    printheadBeltSide(explode=100);
    if (!exploded())
        CoreXYBelts(carriagePosition());
}

module faceTopFront() {
    // add the front top extrusion oriented in the X direction
    translate([eSize, 0, eZ - eSize]) {
        explode([0, -120, 0], true) {
            extrusionOXEndBoltPositions(eX)
                boltM5Buttonhead(_endBoltShortLength);
            difference() {
                extrusionOX(eX);
                for (x = use2060ForTop() ? [eSize/2, 3*eSize/2, eX - eSize/2, eX - 3*eSize/2] : [eSize/2, eX - eSize/2])
                    translate([x, 0, eSize/2])
                        rotate([-90, 0, 0])
                            jointBoltHole();
            }
        }
    }
}

module faceTopBack() {
    // add the back top extrusion oriented in the X direction
    translate([eSize, eY + eSize, eZ - eSize]) {
        use2020 = is_undef(_use2020TopExtrusion) || _use2020TopExtrusion == false ? false : true;

        explode([0, 120, 0], true) {
            extrusionOXEndBoltPositions(eX)
                boltM5Buttonhead(_endBoltShortLength);
            if (!use2020)
                translate_z(-eSize)
                    extrusionOXEndBoltPositions(eX)
                        boltM5Buttonhead(_endBoltLength);
            difference() {
                if (use2020)
                    extrusionOX(eX);
                else
                    translate_z(-eSize)
                        extrusionOX2040V(eX);
                for (x = use2060ForTop() ? [eSize/2, 3*eSize/2, eX - eSize/2, eX - 3*eSize/2] : [eSize/2, eX - eSize/2])
                    translate([x, eSize, eSize/2])
                        rotate([90, 0, 0])
                            jointBoltHole();
            }
        }
    }
}

//!1. Bolt the MGN linear rail to the extrusion, using the **Rail_Centering_Jig** to align the rail. Fully tighten the
//!bolts - the left rail is the fixed rail and the right rail will be aligned to it.
//!bolts at this stage - they will be fully tightened when the rail is racked at a later stage.
//!2. Bolt the **Y_Carriage_Left_assembly** to the MGN carriage.
//!3. Screw the bolts into ends of the extrusion in preparation for attachment to the rest of the top face.
//
module Left_Side_Upper_Extrusion_assembly() pose(a=[180 + 55, 0, 25 + 90])
assembly("Left_Side_Upper_Extrusion", big=true, ngb=true) {

    yCarriageType = yCarriageType(_yCarriageDescriptor);
    translate([0, eSize, eZ - eSize])
        if (use2060ForTop())
            extrusionOY2060HEndBolts(eY);
        else
            extrusionOY2040HEndBolts(eY);
    translate([1.5*eSize, eSize + _yRailLength/2, eZ - eSize])
        explode(-40, true)
            rotate([180, 0, 90])
                if (is_undef($hide_rails) || $hide_rails == false) {
                    rail_assembly(yCarriageType, _yRailLength, carriagePosition().y - eSize - _yRailLength/2, carriage_end_colour="green", carriage_wiper_colour="red");
                    railBoltsAndNuts(carriage_rail(yCarriageType), _yRailLength, 5);
                }
    translate([0, 0, eZ - eSize])
        explode(-80, true) {
            Y_Carriage_Left_assembly();
            explode(-20, true)
                Y_Carriage_bolts(yCarriageType, yCarriageThickness(), left=true);
        }
}

//!1. Bolt the MGN linear rail to the extrusion, using the **Rail_Centering_Jig** to align the rail. Do not fully tighten the
//!bolts at this stage - they will be fully tightened when the rail is racked at a later stage.
//!2. Bolt the **Y_Carriage_Right_assembly** to the MGN carriage.
//!3. Screw the bolts into ends of the extrusion in preparation for attachment to the rest of the top face.
//
module Right_Side_Upper_Extrusion_assembly() pose(a=[180 + 55, 0, 25 - 90])
assembly("Right_Side_Upper_Extrusion", big=true, ngb=true) {

    yCarriageType = yCarriageType(_yCarriageDescriptor);
    translate([eX, eSize, eZ - eSize])
        if (use2060ForTop())
            translate([-eSize, 0, 0])
                extrusionOY2060HEndBolts(eY);
        else
            extrusionOY2040HEndBolts(eY);

    translate([eX + eSize/2, eSize + _yRailLength/2, eZ - eSize])
        explode(-40, true)
            rotate([180, 0, 90])
                if (is_undef($hide_rails) || $hide_rails == false) {
                    rail_assembly(yCarriageType, _yRailLength, carriagePosition().y - eSize - _yRailLength/2, carriage_end_colour="green", carriage_wiper_colour="red");
                    railBoltsAndNuts(carriage_rail(yCarriageType), _yRailLength, 5);
                }
    translate([eX + 2*eSize, 0, eZ - eSize])
        explode(-80, true) {
            Y_Carriage_Right_assembly();
            explode(-20, true)
                Y_Carriage_bolts(yCarriageType, yCarriageThickness(), left=false);
        }
}
