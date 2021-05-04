//!! This is a copy of the BabyCube file
include <../global_defs.scad>

include <NopSCADlib/core.scad>
use <NopSCADlib/utils/fillet.scad>
include <NopSCADlib/vitamins/blowers.scad>
include <NopSCADlib/vitamins/rails.scad>

use <../utils/carriageTypes.scad>
use <../utils/PrintheadOffsets.scad>

use <../vitamins/bolts.scad>

use <../../../BabyCube/scad/printed/Printhead.scad>
use <../../../BabyCube/scad/printed/X_Carriage.scad>
include <../../../BabyCube/scad/printed/X_CarriageBeltClamps.scad> //breaks if this is use
include <../../../BabyCube/scad/printed/X_CarriageFanDuct.scad>

use <../Parameters_CoreXY.scad>
include <../Parameters_Main.scad>


function blower_type() = is_undef(_blower_type) || _blower_type == 30 ? BL30x10 : BL40x10;

module X_Carriage_Front_stl() {
    xCarriageType = xCarriageType();

    // orientate for printing
    stl("X_Carriage_Front")
        color(pp4_colour)
            rotate([0, -90, 0])
                xCarriageFront(xCarriageType, beltOffsetZ(), coreXYSeparation().z);
}

//!1. Bolt the Belt_Clamps to the X_Carriage_Front, leaving them loose for later insertion of the belts.
//!2. Insert the Belt_tensioners into the X_Carriage_Front, and use the 20mm bolts to secure them in place.
module X_Carriage_Front_assembly()
assembly("X_Carriage_Front", big=true) {

    xCarriageType = xCarriageType();
    size = xCarriageFrontSize(xCarriageType);
    beltOffsetZ = beltOffsetZ();

    rotate([0, 90, 0])
        stl_colour(pp4_colour)
            X_Carriage_Front_stl();

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
                        Belt_Clamp_hardware();
                    }
        translate([size.x/2, -1.5, beltOffsetZ])
            rotate([0, -90, 90])
                explode(20, true) {
                    hidden()
                        stl_colour(pp2_colour)
                            Belt_Tidy_stl();
                    //Belt_Tidy_hardware();
                }

        translate([12, (size.y + beltInsetFront())/2, beltOffsetZ - coreXYSeparation().z/2]) {
            explode([0, -10, 0])
                stl_colour(pp3_colour)
                    Belt_Tensioner_stl();
            Belt_Tensioner_hardware();
        }

        translate([size.x - 12, (size.y + beltInsetFront())/2, beltOffsetZ + coreXYSeparation().z/2])
            rotate(180) {
                explode([0, 10, 0])
                    stl_colour(pp3_colour)
                        Belt_Tensioner_stl();
                Belt_Tensioner_hardware();
            }
    }
}

module xCarriageFrontAssemblyBolts(xCarriageType) {
    assert(is_list(xCarriageType));

    size = xCarriageFrontSize(xCarriageType);

    translate([-size.x/2, -xCarriageFrontOffsetY(xCarriageType), 0]) {
        // holes at the top to connect to the printhead
        for (x = xCarriageTopHolePositions(xCarriageType))
            translate([x, 0, xCarriageTopThickness()/2])
                rotate([90, 90, 0])
                    boltM3Buttonhead(10);
        // holes at the bottom to connect to the printhead
        for (x = xCarriageBottomHolePositions(xCarriageType))
            translate([x, 0, -size.z + xCarriageTopThickness() + xCarriageBaseThickness()/2])
                rotate([90, 90, 0])
                    boltM3Buttonhead(12);
    }
}

module xCarriageAssembly(xCarriageType, beltOffsetZ, coreXYSeparationZ) {
    assert(is_list(xCarriageType));

    size = xCarriageBackSize(xCarriageType);
    hotend_type = 0;

    //translate([-size.x/2-eps, carriage_size(xCarriageType).y/2-beltInsetBack()+xCarriageBackSize(xCarriageType).y, beltOffsetZ + coreXYSeparationZ/2]) {
    //!!TODO fix magic number 5
    translate([-size.x/2 - 1, carriage_size(xCarriageType).y/2 - beltInsetBack() + xCarriageBackSize(xCarriageType).y, beltOffsetZ - 5]) {
        rotate([0, 90, 180])
            explode(10, true) {
                stl_colour(pp2_colour)
                    Belt_Clamp_stl();
                Belt_Clamp_hardware();
            }
        translate([size.x + 2, 0, coreXYSeparationZ])
            rotate([0, 90, 0])
                explode(10, true) {
                    stl_colour(pp2_colour)
                        Belt_Clamp_stl();
                    Belt_Clamp_hardware();
                }
    }
}

module X_Carriage_stl() {
    xCarriageType = xCarriageType();
    blower_type = blower_type();
    hotend_type = 0;

    stl("X_Carriage")
        color(pp1_colour)
            rotate([0, -90, 0]) {
                xCarriageBack(xCarriageType, beltOffsetZ(), coreXYSeparation().z);
                hotEndHolder(xCarriageType, hotend_type, blower_type);
            }
}

//!1. Bolt the belt clamps to the sides of the X_Carriage. Leave the clamps loose to allow later insertion of the belts.
//!2. Bolt the fan onto the side of the X_Carriage, secure the fan wire with a ziptie.
//!3. Ensure a good fit between the fan and the fan duct and bolt the fan duct to the X_Carriage.
module X_Carriage_assembly()  pose(a=[55, 0, 25 + 290])
assembly("X_Carriage", big=true, ngb=true) {

    xCarriageType = xCarriageType();
    blower_type = blower_type();
    hotend_type = 0;

    rotate([0, 90, 0])
        stl_colour(pp1_colour)
            X_Carriage_stl();

    xCarriageAssembly(xCarriageType, beltOffsetZ(), coreXYSeparation().z);
    explode([-20, 0, 10], true)
        hotEndPartCoolingFan(xCarriageType, hotend_type, blower_type);

    explode([-20, 0, -10], true)
        blowerTranslate(xCarriageType, hotend_type, blower_type)
            rotate([-90, 0, 0]) {
                stl_colour(pp2_colour)
                    Fan_Duct_stl();
                Fan_Duct_hardware(xCarriageType, hotend_type);
            }
}

/*
beltTidySize = [tidyHoleSpacing() + 8, 7, 2];

module Belt_Tidy_stl() {
    size = beltTidySize;

    stl("Belt_Tidy")
        difference() {
            rounded_cube_xy(size, 1.5, xy_center=true);
            for (x = [-tidyHoleSpacing()/2, tidyHoleSpacing()/2])
                translate([x, 0, 0])
                    boltHoleM3(size.z);
        }
}

module Belt_Tidy_hardware() {
    size = beltTidySize;

    for (x = [-tidyHoleSpacing()/2, tidyHoleSpacing()/2])
        translate([x, 0, size.z])
            boltM3Buttonhead(10);
}


beltClampSize = [clampHoleSpacing() + 8, 7, 2];

module Belt_Clamp_stl() {
    size = beltClampSize;

    stl("Belt_Clamp")
        color(pp2_colour)
            difference() {
                rounded_cube_xy(size, 1.5, xy_center=true);
                for (x = [-clampHoleSpacing()/2, clampHoleSpacing()/2])
                    translate([x, 0, 0])
                        boltHoleM3(size.z);
            }
}

module Belt_Clamp_hardware() {
    size = beltClampSize;

    for (x = [-clampHoleSpacing()/2, clampHoleSpacing()/2])
        translate([x, 0, size.z])
            boltM3Buttonhead(10);
}

module Belt_Tensioner_stl() {
    size = beltTensionerSize();
    holeLength = size.x + size.y/8; // length of rectangular part plus a quarter the radius of the cylinder

    stl("Belt_Tensioner")
        difference() {
            union() {
                translate([size.x/2, 0, 0])
                    cylinder(d=size.y, h=size.z, center=true);
                cube(size, center=true);
            }
            translate([-size.x/2, -size.y/2, -size.z/2-eps])
                fillet(0.5, size.z + 2*eps);
            translate([-size.x/2, size.y/2, -size.z/2-eps])
                rotate(-90)
                    fillet(0.5, size.z + 2*eps);
            translate([-size.x/2 - eps, 0, 0])
                rotate([90, 0, 90])
                    boltHoleM3(holeLength, horizontal = true, chamfer_both_ends = false);
        }
}

module Belt_Tensioner_hardware() {
    size = beltTensionerSize();
    boltLength = 20;
    holeLength = size.x + 2; // length of rectangular part, plus two into the cylinder

    translate([holeLength - size.x/2 - boltLength, 0, 0])
        rotate([0, -90, 0])
            boltM3Caphead(boltLength);
}
*/
/*
fanDuctTabThickness = 2;

module Fan_Duct_stl() {
    blower_type = BL30x10;
    blowerSize = blower_size(blower_type);

    exit = blower_exit(blower_type);
    wallLeft = blower_wall_left(blower_type);
    wallRight = blower_wall_right(blower_type);
    base = blower_base(blower_type);
    top = blower_top(blower_type);

    stl("Fan_Duct")
        color(pp2_colour) {
            difference() {
                fillet = 2;
                offsetX = 1;
                chimneySize = [exit + wallLeft + wallRight - offsetX, blowerSize.z, 14];
                chimneyTopSize = [exit, blowerSize.z - base - top, chimneySize.z + 2];
                union() {
                    translate([0, -chimneySize.y, -chimneySize.z]) {
                        translate([offsetX, 0, 0])
                            rounded_cube_xy(chimneySize, fillet);
                        translate([wallLeft, top, 0])
                            rounded_cube_xy(chimneyTopSize, fillet);
                        translate([offsetX, 0, -3]) {
                            // the foot
                            hull() {
                                rounded_cube_xy([chimneySize.x, chimneySize.y, 5], fillet);
                                translate([0, 11, 0])
                                    rounded_cube_xy([chimneySize.x, 5, 3], fillet);
                            }
                        }
                    }
                    tabTopSize = [34, fanDuctTabThickness, 5];
                    tabBottomSize = [chimneySize.x, tabTopSize.y, 1];
                    hull() {
                        translate([offsetX, -fanDuctTabThickness, -chimneySize.z+0.5])
                            rounded_cube_xy(tabBottomSize, 0.5);
                        translate([30 - tabTopSize.x, -fanDuctTabThickness, -tabTopSize.z])
                            rounded_cube_xy(tabTopSize, 0.5);
                    }
                }
                fanDuctHolePositions(-fanDuctTabThickness)
                    rotate([-90, 180, 0])
                        boltHoleM2(fanDuctTabThickness, horizontal=true);

                flueSize = chimneyTopSize - [1.5, 1.5, 0];
                translate([wallLeft + 1.5/2, -chimneySize.y + top+1.5/2, -chimneySize.z + eps])
                    rounded_cube_xy(flueSize, 1);

                jetEndSize = [5, 2, 2];
                jetStartSize = [16, 2, 2];
                translate([14, -8, 0])
                    #hull() {
                        translate([-jetEndSize.x/2, 6+printHeadHotendOffset().x, -21])
                            cube(jetEndSize);
                        translate([-jetStartSize.x/2, 0, -13])
                            cube(jetStartSize);
                    }
            }
        }
}

module Fan_Duct_hardware(xCarriageType, hotend_type) {
    fanDuctHolePositions(-fanDuctTabThickness)
        rotate([90, 0, 0])
            boltM2Caphead(6);
}
*/
/*module fanDuctTranslate(xCarriageType, hotend_type) {
    hotendOffset = hotendOffset(xCarriageType);
    grooveMountSize = grooveMountSize(xCarriageType, hotend_type, blower_type);

    translate([hotendOffset.x - grooveMountSize.x, hotendOffset.y + grooveMountOffsetX(hotend_type), 3 - grooveMountSize.z/2 - 38])
        rotate([90, 0, 90])
            children();
}*/
