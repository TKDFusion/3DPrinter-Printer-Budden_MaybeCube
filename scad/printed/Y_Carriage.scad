//!! This is a copy of the BabyCube file
include <../global_defs.scad>

include <NopSCADlib/core.scad>
use <NopSCADlib/utils/fillet.scad>

include <NopSCADlib/vitamins/pulleys.scad>
include <NopSCADlib/vitamins/rails.scad>
include <NopSCADlib/vitamins/screws.scad>


use <../vitamins/bolts.scad>

function pulleyStackHeight() = 2*washer_thickness(M3_washer) + pulley_height(GT2x16_plain_idler);// runs better without top washer
function plainPulleyPos(left, pulleyOffset, thickness, yCarriageBraceThickness) = [pulleyOffset.x + 12.25, 0, thickness + pulleyStackHeight()/2 + (left ? pulleyStackHeight() + yCarriageBraceThickness : 0)];
function toothedPulleyPos(left, pulleyOffset, thickness, yCarriageBraceThickness) = [pulleyOffset.x, 0, thickness + pulleyStackHeight()/2 + (left ? 0 : pulleyStackHeight() + yCarriageBraceThickness)];

function railFirstHoleOffset(type, length) = (length - (rail_holes(type, length) - 1)*rail_pitch(type))/2;

// allow adjustment of counterbore to optimise bolt length
function counterBore(thickness) = screw_head_height(M3_cap_screw) + max(thickness - 9, 0);
function yCarriageBlockSizeX(yCarriageType) = carriage_width(yCarriageType) + 4;


module Y_Carriage(yCarriageType, xRailType, xRailLength, thickness, chamfer, yCarriageBraceThickness, endStopOffsetX, tongueOffset, left, pulleyOffset, topInset=0, cnc=false) {
    assert(is_list(yCarriageType));
    assert(is_list(xRailType));

    fillet = 1.5;
    blockOffset = [0, 1];//!!was 1.5
    assert(blockOffset.x == 0);

    blockSize = [yCarriageBlockSizeX(yCarriageType) + 2*blockOffset.x, carriage_length(yCarriageType) + 1 + 2*blockOffset.y, thickness];
    rightInset = topInset == 0 ? 0 : 2;
    railFirstHoleOffset = railFirstHoleOffset(xRailType, xRailLength);
    tongueSize = [tongueOffset + railFirstHoleOffset + rail_pitch(xRailType) + rail_width(xRailType)/2 + 0.5, rail_width(xRailType) + 2, thickness - chamfer];

    module tongueBoltPositions() {
        translate([tongueOffset + xRailLength/2, 0, 0])
            rail_hole_positions(xRailType, xRailLength, screws=2, both_ends=false)
                children();
    }

    module chamfered_rounded_cube(size, fillet, chamfer) {
        hull() {
            if (chamfer) {
                translate([chamfer, chamfer, 0])
                    rounded_cube_xy([size.x - 2*chamfer, size.y - 2*chamfer, chamfer], fillet);
                translate([chamfer, chamfer, size.z - chamfer])
                    rounded_cube_xy([size.x - 2*chamfer, size.y - 2*chamfer, chamfer], fillet);
            }
            translate_z(chamfer)
                rounded_cube_xy([size.x, size.y, size.z - 2*chamfer], fillet);
        }
    }

    module tongue(left) {
        // add rail_width/2 to tongueSize.x to give a bit of extra length to the tongue for wider rails
        translate([0, -tongueSize.y/2, 0])
            chamfered_rounded_cube(tongueSize, fillet, chamfer);

        //endStopSize = [tongueOffset + endStopOffsetX, tongueSize.y + (left ? 5.5 : 11), tongueSize.z];
        //translate([0, -(endStopSize.y - tongueSize.y), 0])
        //    rounded_cube_xy(endStopSize, fillet);
        if (left) {
            translate([tongueOffset + endStopOffsetX + blockOffset.x, tongueSize.y/2, chamfer])
                fillet(1+3, tongueSize.z - 2*chamfer);
            translate([blockSize.x/2 + blockOffset.x, -tongueSize.y/2, chamfer])
                rotate(-90)
                    fillet(2+2, tongueSize.z - 2*chamfer);
        } else {
            translate([tongueOffset + endStopOffsetX + blockOffset.x, -tongueSize.y/2, chamfer])
                rotate(-90)
                    fillet(1+2, tongueSize.z - 2*chamfer);
            translate([blockSize.x/2 + blockOffset.x, tongueSize.y/2, chamfer])
                fillet(2+2, tongueSize.z - 2*chamfer);
        }

        /*if (blockSize.x/2 + blockOffset.x < tongueOffset) {
            translate([blockSize.x/2 + blockOffset.x, tongueSize.y, 0])
                fillet(left ? 1 : 3 - rightInset, tongueSize.z);
            translate([blockSize.x/2 + blockOffset.x, -(endStopSize.y - tongueSize.y), 0])
                rotate(-90)
                    fillet(left ? 2 : 1, tongueSize.z);
        } else {
            translate([blockSize.x/2 + blockOffset.x, tongueSize.y/2, 0])
                fillet(4, tongueSize.z);
            translate([blockSize.x/2 + blockOffset.x, -tongueSize.y/2, 0])
                rotate(-90)
                    fillet(4, tongueSize.z);
        }*/
    }

    difference() {
        plainPulleyPos = plainPulleyPos(left, pulleyOffset, thickness, yCarriageBraceThickness);
        toothedPulleyPos = toothedPulleyPos(left, pulleyOffset, thickness, yCarriageBraceThickness);
        union() {
            endstopX = tongueOffset - blockSize.x/2 + endStopOffsetX;
            translate([-blockSize.x/2 + blockOffset.x, left ? blockOffset.y : -blockSize.y/2 - blockOffset.y, 0]) {
                // inset the block to avoid possible interference with the idler pulleys
                rounded_cube_xy([blockSize.x + endstopX, blockSize.y/2, blockSize.z - 1], fillet);
                if (left) {
                    rounded_cube_xy([blockSize.x + endstopX, blockSize.y/2 - topInset, blockSize.z], fillet);
                    translate([0, -blockSize.y/2, 0])
                        rounded_cube_xy([blockSize.x, blockSize.y - topInset, blockSize.z], fillet);
                } else {
                    translate([0, topInset, 0]) {
                        rounded_cube_xy([blockSize.x, blockSize.y - topInset, blockSize.z], fillet);
                        rounded_cube_xy([blockSize.x + endstopX, blockSize.y/2 - topInset, blockSize.z], fillet);
                    }
                }
            }
            tongue(left);
            h = thickness + pulleyStackHeight();
            if (left) {
                if (yCarriageType == MGN9C_carriage) {
                    size = [10, 7, h];
                    translate([plainPulleyPos.x - 3.25, -size.y/2, 0])
                        rounded_cube_xy(size, 3);
                } else {
                    size = [22, 10, h];
                    translate([plainPulleyPos.x - 5, -3.25, 0])
                        rounded_cube_xy(size, 1.5);
                    if (yCarriageBraceThickness) {
                        size2 = [7.5, 10 + 3.25/2, h];
                        translate([-blockSize.x/2, -size.y/2, 0])
                            rounded_cube_xy(size2, 1.5);
                    }
                }
            } else {
                if (yCarriageType == MGN9C_carriage) {
                    size = [8.5, 15, h];
                    translate([toothedPulleyPos.x - 3.25, -size.y/2, 0])
                        rounded_cube_xy(size, 1.5);
                } else {
                    size = [8.5, tongueSize.y, h];
                    translate([toothedPulleyPos.x - 3.25, -size.y/2, 0])
                        rounded_cube_xy(size, 1.5);
                    if (yCarriageBraceThickness) {
                        size3 = [12, 10.25, h];
                        translate([plainPulleyPos.x + 7, -3.25, 0])
                            rounded_cube_xy(size3, 1.5);
                        size2 = [8.5, size.y, h];
                        translate([-blockSize.x/2, -size2.y/2, 0])
                            rounded_cube_xy(size2, 1.5);
                    }
                }
            }
        } // end union
        tongueBoltPositions()
            if (rail_hole(xRailType) < 3)
                boltHoleM2Tap(thickness, cnc=cnc);
            else
                boltHoleM3Tap(thickness, cnc=cnc);
        translate_z(thickness - carriage_height(yCarriageType))
            rotate(90)
                carriage_hole_positions(yCarriageType)
                    vflip()
                        boltHoleM3Counterbore(thickness, counterBore(thickness), cnc=cnc);
        if (left) {
            translate([toothedPulleyPos.x, toothedPulleyPos.y, 0])
                boltHoleM3Tap(thickness, cnc=cnc);
            translate([plainPulleyPos.x, 0, 0])
                boltHoleM3Tap(thickness + pulleyStackHeight(), cnc=cnc);
        } else {
            translate([plainPulleyPos.x, plainPulleyPos.y, 0])
                boltHoleM3Tap(thickness, cnc=cnc);
            translate([toothedPulleyPos.x, toothedPulleyPos.y, 0])
                boltHoleM3Tap(thickness + pulleyStackHeight(), cnc=cnc);
        }
        for (x = [-blockSize.x/2 + 4, 23])
            translate([x, 0, 0])
                boltHoleM3Tap(thickness + pulleyStackHeight(), cnc=cnc);
    } // end difference
}

module yCarriageBrace(yCarriageType, yCarriageBraceThickness, left, pulleyOffset) {
    blockSizeX = yCarriageBlockSizeX(yCarriageType);
    size = left ? [45, 10 + 3.25/2, yCarriageBraceThickness] : [46.75, 14, yCarriageBraceThickness];
    difference() {
        translate([-blockSizeX/2, left ? -5 : -size.y/2, 0])
            rounded_cube_xy(size, 1.5);
        for (x = [-blockSizeX/2 + 4, 0, 12.25, 23])
            translate([x, 0, 0])
                boltHoleM3Tap(size.z);
    }
}

module yCarriageBolts(yCarriageType, thickness) {
    assert(is_list(yCarriageType));

    // depth of holes in MGN9 and MGN12 carriages is approx 5mm. so 4.5mm leaves room for error
    carriageHoleDepth = 4.5;
    counterBore = counterBore(thickness);
    boltLength = screw_shorter_than(thickness - counterBore + carriageHoleDepth);
    //echo(boltLength=boltLength, counterBore=counterBore, cap=screw_head_height(M3_cap_screw),protrudes=boltLength-thickness+counterBore);

    rotate(90)
        translate_z(thickness - carriage_height(yCarriageType) - counterBore)
            carriage_hole_positions(yCarriageType)
                boltM3Caphead(boltLength);
}

module pulleyStack(pulley, washer=M3_washer) {
    translate_z(-washer_thickness(washer) - pulley_height(pulley)/2)
        explode(-10)
            washer(washer)
                pulley(pulley);
    if ($children)
        translate_z(pulley_height(pulley)/2)
            children();
}

module yCarriagePulleys(yCarriageType, thickness, yCarriageBraceThickness, left, pulleyOffset, inset) {
    blockSizeX = yCarriageBlockSizeX(yCarriageType);

    explode(30, true) {
        translate(plainPulleyPos(left, pulleyOffset, thickness, yCarriageBraceThickness))
            pulleyStack(GT2x16_plain_idler)
                washer(M3_washer)
                    translate_z(left ? 0 : yCarriageBraceThickness)
                        boltM3Caphead(screw_shorter_than(thickness + pulleyStackHeight() + (left ? pulleyStackHeight() + yCarriageBraceThickness : 0)));

        toothedPulleyPos = toothedPulleyPos(left, pulleyOffset, thickness, yCarriageBraceThickness);
        translate(toothedPulleyPos)
            pulleyStack(GT2x16_toothed_idler)
                washer(M3_washer)
                    translate_z(left ? yCarriageBraceThickness : 0)
                        boltM3Caphead(screw_shorter_than(thickness + pulleyStackHeight() + (left ? 0 : pulleyStackHeight() + yCarriageBraceThickness)));
        if (yCarriageBraceThickness)
            for (x = [-blockSizeX/2 + 4, 23])
                translate([x, 0, thickness + pulleyStackHeight() +yCarriageBraceThickness])
                    boltM3Caphead(screw_shorter_than(thickness + pulleyStackHeight() + yCarriageBraceThickness));
    }
}

module Y_Carriage_hardware(yCarriageType, thickness, yCarriageBraceThickness, left, pulleyOffset, inset=0) {
    assert(is_list(yCarriageType));

    yCarriagePulleys(yCarriageType, thickness, yCarriageBraceThickness, left, pulleyOffset, inset);
    explode(15)
        yCarriageBolts(yCarriageType, thickness);
}
