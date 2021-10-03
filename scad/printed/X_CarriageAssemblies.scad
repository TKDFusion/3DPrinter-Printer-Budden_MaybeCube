//!! This is a copy of the BabyCube file with alterations
include <../global_defs.scad>

include <NopSCADlib/core.scad>
use <NopSCADlib/utils/fillet.scad>
include <NopSCADlib/vitamins/blowers.scad>
include <NopSCADlib/vitamins/rails.scad>

use <../utils/carriageTypes.scad>
use <../utils/PrintheadOffsets.scad>

include <../vitamins/bolts.scad>

use <../../../BabyCube/scad/printed/Printhead.scad>
use <../../../BabyCube/scad/printed/X_Carriage.scad>
use <../../../BabyCube/scad/printed/X_CarriageBeltAttachment.scad>
use <../../../BabyCube/scad/printed/X_CarriageBeltClamps.scad>
include <../../../BabyCube/scad/printed/X_CarriageFanDuct.scad>

use <../Parameters_CoreXY.scad>
include <../Parameters_Main.scad>


function hotendOffset(xCarriageType, hotend_type=0) = printHeadHotendOffset(hotend_type) + [-xCarriageBackSize(xCarriageType).x/2, xCarriageBackOffsetY(xCarriageType), 0];
function grooveMountSize(blower_type, hotend_type=0) = [printHeadHotendOffset(hotend_type).x, blower_size(blower_type).x + 6.25, 12];
function blower_type() = is_undef(_blowerDescriptor) || _blowerDescriptor == "BL30x10" ? BL30x10 : BL40x10;
//function accelerometerOffset() = [10, -1, 8];
function accelerometerOffset() = [6.5, -2, 8];
function xCarriageHoleOffsetTop() = -1;//[5.65, -1]; // for alignment with EVA
//function xCarriageHoleOffsetTop() = [4, 0];
//function xCarriageHoleOffsetBottom() = [9.7, 4.5]; // for alignment with EVA
//function xCarriageHoleOffsetBottom() = [9.7, 0];
//function xCarriageHoleOffsetBottom() = [4, 0];
//evaHoleOffsetBottom = 9.7;
//evaHoleSeparationBottom = 26;
evaHoleSeparationTop = 34;
function xCarriageHoleSeparationTopMGN12H() = evaHoleSeparationTop; //45.4 - 8
function xCarriageHoleSeparationBottomMGN12H() = 38;//34;//37.4; //45.4 - 8

xCarriageBeltTensionerSizeX = 23;


module X_Carriage_Belt_Side_MGN12H_stl() {
    xCarriageType = MGN12H_carriage;
    size = xCarriageFrontSize(xCarriageType, _beltWidth, clamps=false);// + [1, 0, 1];
    holeSeparationTop = xCarriageHoleSeparationTopMGN12H();
    holeSeparationBottom = xCarriageHoleSeparationBottomMGN12H();
    offsetT = xCarriageHoleOffsetTop();

    // orientate for printing
    stl("X_Carriage_Belt_Side_MGN12H")
        color(pp4_colour)
            rotate([90, 0, 0])
                xCarriageBeltSide(xCarriageType, size, holeSeparationTop, holeSeparationBottom, extraX=1, accelerometerOffset=accelerometerOffset(), offsetT=offsetT);
}

//!Insert the belts into the **X_Carriage_Belt_Tensioner**s and then bolt the tensioners into the
//!**X_Carriage_Belt_Side_MGN12H** part as shown. Note the belts are not shown in this diagram.
//
module X_Carriage_Belt_Side_MGN12H_assembly()
assembly("X_Carriage_Belt_Side_MGN12H") {

    rotate([-90, 0, 0])
        stl_colour(pp4_colour)
            X_Carriage_Belt_Side_MGN12H_stl();

    boltLength = 40;
    gap = 0.1; // small gap so can see clearance when viewing model
    offset = [ 22.5,
               xCarriageBeltTensionerSize().y - beltAttachmentOffsetY() + xCarriageBeltAttachmentCutoutOffset() + gap,
               -31 ];
    translate(offset) {
        rotate([0, 0, 180]) {
            explode([-40, 0, 0])
                stl_colour(pp2_colour)
                    X_Carriage_Belt_Tensioner_stl();
            X_Carriage_Belt_Tensioner_hardware(boltLength, offset.x);
        }
        translate([-2*offset.x, 0, -2])
            rotate([180, 0, 0]) {
                explode([-40, 0, 0])
                    stl_colour(pp2_colour)
                        X_Carriage_Belt_Tensioner_stl();
                X_Carriage_Belt_Tensioner_hardware(boltLength, offset.x);
            }
    }
}

module X_Carriage_Belt_Tensioner_stl() {
    stl("X_Carriage_Belt_Tensioner")
        color(pp2_colour)
            xCarriageBeltTensioner(xCarriageBeltTensionerSizeX);
}

module X_Carriage_Belt_Clamp_Buttonhead_stl() {
    size = [xCarriageBeltAttachmentSize().x - 0.5, 25, 4.5];

    stl("X_Carriage_Belt_Clamp_Buttonhead")
        color(pp2_colour)
            xCarriageBeltClamp(size);
            /*translate([0, -size.y/2, 0])
                difference() {
                    fillet = 1;
                    rounded_cube_xy(size, fillet);
                    *for (x = [0, xCarriageBeltClampHoleSeparation()])
                        translate([x + 3.2, size.y/2, 0])
                            boltHoleM3(size.z, twist=4);
                    for (y = [-xCarriageBeltClampHoleSeparation()/2, xCarriageBeltClampHoleSeparation()/2])
                        translate([size.x/2 + 1.25, y + size.y/2, 0])
                            boltHoleM3(size.z, twist=4);
                }*/
}

module X_Carriage_Belt_Clamp_stl() {
    size = [xCarriageBeltAttachmentSize().x - 0.5, 25, 4.5];

    stl("X_Carriage_Belt_Clamp")
        color(pp2_colour)
            vflip()
                xCarriageBeltClamp(size, countersunk=true);
}

module xCarriageBeltClampAssembly(xCarriageType, countersunk=true) {
    assert(is_list(xCarriageType));

    size = xCarriageFrontSize(xCarriageType, _beltWidth, clamps=false);

    xCarriageBeltClampPosition(xCarriageType, size) {
        stl_colour(pp2_colour)
            if (countersunk)
                vflip()
                    X_Carriage_Belt_Clamp_stl();
            else
                X_Carriage_Belt_Clamp_Buttonhead_stl();
        X_Carriage_Belt_Clamp_hardware(countersunk=countersunk);
    }
}

module X_Carriage_Groovemount_MGN12H_stl() {
    xCarriageType = MGN12H_carriage;
    blower_type = blower_type();
    hotend_type = 0;
    grooveMountSize = grooveMountSize(blower_type, hotend_type);
    hotendOffset = hotendOffset(xCarriageType, hotend_type);

    stl("X_Carriage_Groovemount_MGN12H")
        color(pp1_colour)
            rotate([0, 90, 0]) {
                size = xCarriageBackSize(xCarriageType, _beltWidth, clamps=false);
                difference() {
                    union() {
                        xCarriageBack(xCarriageType, size, _beltWidth, beltOffsetZ(), coreXYSeparation().z, clamps=false, reflected=true, strainRelief=true, countersunk=_xCarriageCountersunk ? 4 : 0, offsetT=xCarriageHoleOffsetTop(), accelerometerOffset=accelerometerOffset());
                        hotEndHolder(xCarriageType, grooveMountSize, hotendOffset, hotend_type, blower_type, baffle=false, left=false);
                    }
                    // bolt holes for Z probe mount
                    for (z = [0, -8])
                        translate([size.x/2, 18, z - 26])
                            rotate([0, -90, 0])
                                boltHoleM3Tap(9);
                }
            }
}

//!1. Bolt the belt clamps to the sides of the X_Carriage. Leave the clamps loose to allow later insertion of the belts.
module X_Carriage_Groovemount_MGN12H_assembly() {
//assembly("X_Carriage_Groovemount_MGN12H", big=true, ngb=true) {

    xCarriageType = MGN12H_carriage;
    blower_type = blower_type();
    hotend_type = 0;
    hotendOffset = hotendOffset(xCarriageType, hotend_type);

    rotate([0, -90, 0])
        stl_colour(pp1_colour)
            X_Carriage_Groovemount_MGN12H_stl();

    *translate([0, carriage_size(xCarriageType).y/2 + xCarriageBackSize(xCarriageType).y - beltInsetBack(undef), beltOffsetZ()])
        xCarriageBeltClamps(xCarriageType);

    grooveMountSize = grooveMountSize(blower_type, hotend_type);

    explode([40, 0, 0], true)
        hotEndPartCoolingFan(xCarriageType, grooveMountSize, hotendOffset, blower_type, left=false);
    explode([40, 0, -10], true)
        hotEndHolderAlign(hotendOffset, left=false)
            blowerTranslate(xCarriageType, grooveMountSize, hotendOffset, blower_type)
                rotate([-90, 0, 0]) {
                    stl_colour(pp2_colour)
                        Fan_Duct_stl();
                    Fan_Duct_hardware(xCarriageType, hotend_type);
                }
}

/*
module X_Carriage_Front_MGN12H_stl() {
    xCarriageType = MGN12H_carriage;

    // orientate for printing
    stl("X_Carriage_Front_MGN12H")
        color(pp4_colour)
            rotate([0, -90, 0])
                xCarriageFront(xCarriageType, _beltWidth, beltOffsetZ(), coreXYSeparation().z);
}

//!1. Bolt the Belt_Clamps to the X_Carriage_Front, leaving them loose for later insertion of the belts.
//!2. Insert the Belt_tensioners into the X_Carriage_Front, and use the 20mm bolts to secure them in place.
module X_Carriage_Front_MGN12H_assembly()
assembly("X_Carriage_Front_MGN12H", big=true) {

    xCarriageType = MGN12H_carriage;
    size = xCarriageFrontSize(xCarriageType, _beltWidth, clamps=true);
    beltOffsetZ = beltOffsetZ();

    rotate([0, 90, 0])
        stl_colour(pp4_colour)
            X_Carriage_Front_MGN12H_stl();

    translate([-size.x/2, -xCarriageFrontOffsetY(xCarriageType), 0]) {
        for (i= [
                    [beltClampOffsetX(), -1.5, beltOffsetZ - coreXYSeparation().z/2],
                    [size.x - beltClampOffsetX(), -1.5, beltOffsetZ + coreXYSeparation().z/2]
                ])
            translate(i)
                rotate([0, -90, 90])
                    explode(20, true) {
                        stl_colour(pp2_colour)
                            Belt_Clamp_stl();
                        Belt_Clamp_hardware(_beltWidth);
                    }
        translate([size.x/2, -1.5, beltOffsetZ])
            rotate([0, -90, 90])
                explode(20, true) {
                    stl_colour(pp2_colour)
                        Belt_Tidy_stl();
                    Belt_Tidy_hardware(_beltWidth);
                }

        translate([12, (size.y + beltInsetFront(undef))/2, beltOffsetZ - coreXYSeparation().z/2]) {
            explode([0, -10, 0])
                stl_colour(pp3_colour)
                    Belt_Tensioner_stl();
            Belt_Tensioner_hardware(_beltWidth);
        }

        translate([size.x - 12, (size.y + beltInsetFront(undef))/2, beltOffsetZ + coreXYSeparation().z/2])
            rotate(180) {
                explode([0, 10, 0])
                    stl_colour(pp3_colour)
                        Belt_Tensioner_stl();
                Belt_Tensioner_hardware(_beltWidth);
            }
    }
}

module xCarriageBeltClamps(xCarriageType) {
    assert(is_list(xCarriageType));

    sizeX = xCarriageBackSize(xCarriageType, _beltWidth).x;

    translate([-sizeX/2 - 1, 0, -coreXYSeparation().z/2])
        rotate([0, 90, 180])
            explode(10, true) {
                stl_colour(pp2_colour)
                    Belt_Clamp_stl();
                Belt_Clamp_hardware(_beltWidth);
            }
    translate([sizeX/2 + 1, 0, coreXYSeparation().z/2])
        rotate([0, 90, 0])
            explode(10, true) {
                stl_colour(pp2_colour)
                    Belt_Clamp_stl();
                Belt_Clamp_hardware(_beltWidth);
            }
}

module Belt_Tidy_stl() {
    stl("Belt_Tidy")
        color(pp2_colour)
            beltTidy(_beltWidth);
}

module Belt_Clamp_stl() {
    stl("Belt_Clamp")
        color(pp2_colour)
            beltClamp(_beltWidth);
}

module Belt_Tensioner_stl() {
    stl("Belt_Tensioner")
        color(pp3_colour)
            beltTensioner(_beltWidth);
}
*/

module Fan_Duct_stl() {
    stl("Fan_Duct")
        color(pp2_colour)
            translate([26, 0, 0])
                mirror([1, 0, 0])
                    fanDuct(printHeadHotendOffset().x, jetOffset=-0.5, chimneySizeZ=17);
}
