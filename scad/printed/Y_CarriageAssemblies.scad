//!! This is a copy of the BabyCube file with alterations
include <../global_defs.scad>

include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/vitamins/screws.scad>
include <NopSCADlib/vitamins/rails.scad>

include <../utils/carriageTypes.scad>

use <../../../BabyCube/scad/printed/Y_Carriage.scad>

include <../Parameters_CoreXY.scad>
use <../Parameters_Positions.scad>

// When using standard belts the inside idler is plain and the outside idler is toothed.
// When using reversed belts the inside idler is toothed and the outside idler is plain.
// Need to compensate for belt teeth when using bearings rather than toothed pulleys.
// Note that when using reversed belts, plainIdler refers to the toothed idler and toothIdler refers to he plain idler,
// hence the beltToothHeight compensation is appled to the "plainIdler".
// In principle both the x and y offsets should be compensated, but the y offset is not compensated here, instead it is
// handled at the X_Carriage. This improves belt clearances on the Y_Carriage.
beltToothHeight = coreXYBearing() ? 1*belt_tooth_height(coreXY_belt(coreXY_type())) : 0;
plainIdlerOffsetY = 1; // offset to increase amount of support around left Y_Carriage shoulder bolt
function plainIdlerOffset(left=true) = [useReversedBelts() ? -2.15 + beltToothHeight + (coreXYIdlerBore()==4 ? 1 : 0) : -yRailShiftX() + plainIdlerPulleyOffset().x, left ? -coreXYOffsetY()/2 - plainIdlerOffsetY : coreXYOffsetY()/2 + plainIdlerOffsetY, undef];
function toothedIdlerOffset(left=true) = [-yRailShiftX(), left ? coreXYOffsetY()/2 : -coreXYOffsetY()/2, undef];
function tongueOffset() = (eX + 2*eSize - _xRailLength - 2*yRailOffset().x)/2;
function pulleyWasherHeight(coreXYIdlerBore=coreXYIdlerBore()) = 2*washer_thickness(coreXYIdlerBore == 3 ? M3_washer : coreXYIdlerBore == 4 ? M4_shim : M5_shim);

topInset = 0;
yCarriageInserts = true;
blockOffsetX = 0;
blockOffset = 0.5;

idlerHeight = pulley_height(coreXY_plain_idler(coreXY_type()));
chamfer = _xCarriageDescriptor == "MGN9C" || _xCarriageDescriptor == "MGN9H" ? 1 : 0;

holeRadius = coreXYIdlerBore() == 3 ? M3_tap_radius : coreXYIdlerBore() == 4 ? 4/2 : M5_tap_radius;


module Y_Carriage_Left_16_stl() {
    pulleyStackHeight = idlerHeight + pulleyWasherHeight();
    assert(pulleyStackHeight + yCarriageBraceThickness() == coreXYSeparation().z);
    //xMin = xPos(3);
    //endStopOffsetX = max(0, xMin - 68); // 12
    //endStopOffsetX = max(0, xMin - 75); // 5
    //endStopOffsetX = 5; // set this to zero and instead set software endstop offset (X_MIN_POS in Marlin) to -12
    endStopOffsetX = 9.65;

    stl("Y_Carriage_Left_16")
        color(pp2_colour)
            Y_Carriage(carriageType(_yCarriageDescriptor), idlerHeight, coreXYIdlerBore(), railType(_xCarriageDescriptor), _xRailLength, yCarriageThickness(), chamfer, yCarriageBraceThickness(), blockOffset, endStopOffsetX, tongueOffset(), plainIdlerOffset(), toothedIdlerOffset(), topInset, inserts=yCarriageInserts, left=true, cnc=false);
}

module Y_Carriage_Right_16_stl() {
    endStopOffsetX = 0;
    stl("Y_Carriage_Right_16")
        color(pp2_colour)
            Y_Carriage(carriageType(_yCarriageDescriptor), idlerHeight, coreXYIdlerBore(), railType(_xCarriageDescriptor), _xRailLength, yCarriageThickness(), chamfer, yCarriageBraceThickness(), blockOffset, endStopOffsetX, tongueOffset(), plainIdlerOffset(), toothedIdlerOffset(), topInset, inserts=yCarriageInserts, left=false, cnc=false);
}

module Y_Carriage_Left_RB3_stl() {
    pulleyStackHeight = idlerHeight + pulleyWasherHeight();
    assert(pulleyStackHeight + yCarriageBraceThickness() == coreXYSeparation().z);
    endStopOffsetX = 9.65;
    stl("Y_Carriage_Left_RB3");
    color(pp2_colour)
        Y_Carriage(carriageType(_yCarriageDescriptor), idlerHeight, coreXYIdlerBore(), railType(_xCarriageDescriptor), _xRailLength, yCarriageThickness(), chamfer, yCarriageBraceThickness(), blockOffset, endStopOffsetX, tongueOffset(), plainIdlerOffset(), toothedIdlerOffset(), topInset, inserts=yCarriageInserts, reversedBelts=true, left=true, cnc=false);
}

module Y_Carriage_Right_RB3_stl() {
    endStopOffsetX = 0;
    stl("Y_Carriage_Right_RB3");
    color(pp2_colour)
        Y_Carriage(carriageType(_yCarriageDescriptor), idlerHeight, coreXYIdlerBore(), railType(_xCarriageDescriptor), _xRailLength, yCarriageThickness(), chamfer, yCarriageBraceThickness(), blockOffset, endStopOffsetX, tongueOffset(), plainIdlerOffset(), toothedIdlerOffset(), topInset, inserts=yCarriageInserts, reversedBelts=true, left=false, cnc=false);
}

module Y_Carriage_Left_RB4_stl() {
    pulleyStackHeight = idlerHeight + pulleyWasherHeight();
    assert(pulleyStackHeight + yCarriageBraceThickness() == coreXYSeparation().z);
    endStopOffsetX = 10.65;
    stl("Y_Carriage_Left_RB4");
    color(pp2_colour)
        Y_Carriage(carriageType(_yCarriageDescriptor), idlerHeight, coreXYIdlerBore(), railType(_xCarriageDescriptor), _xRailLength, yCarriageThickness(), chamfer, yCarriageBraceThickness(), blockOffset, endStopOffsetX, tongueOffset(), plainIdlerOffset(), toothedIdlerOffset(), topInset, inserts=yCarriageInserts, reversedBelts=true, left=true, cnc=false);
}

module Y_Carriage_Right_RB4_stl() {
    endStopOffsetX = 0;
    stl("Y_Carriage_Right_RB4");
    color(pp2_colour)
        Y_Carriage(carriageType(_yCarriageDescriptor), idlerHeight, coreXYIdlerBore(), railType(_xCarriageDescriptor), _xRailLength, yCarriageThickness(), chamfer, yCarriageBraceThickness(), blockOffset, endStopOffsetX, tongueOffset(), plainIdlerOffset(left=false), toothedIdlerOffset(left=false), topInset, inserts=yCarriageInserts, reversedBelts=true, left=false, cnc=false);
}

module Y_Carriage_Left_AL_dxf() {
    endStopOffsetX = 5;
    dxf("Y_Carriage_Left_AL")
        color(silver)
            Y_Carriage(carriageType(_yCarriageDescriptor), idlerHeight, coreXYIdlerBore(), railType(_xCarriageDescriptor), _xRailLength, yCarriageThickness(), chamfer, yCarriageBraceThickness(), blockOffset, endStopOffsetX, tongueOffset(), plainIdlerOffset(), toothedIdlerOffset(), topInset, left=true, cnc=true);
}

module Y_Carriage_Right_AL_dxf() {
    endStopOffsetX = 0;
    dxf("Y_Carriage_Right_AL")
        color(silver)
            Y_Carriage(carriageType(_yCarriageDescriptor), idlerHeight, coreXYIdlerBore(), railType(_xCarriageDescriptor), _xRailLength, yCarriageThickness(), chamfer, yCarriageBraceThickness(), blockOffset, endStopOffsetX, tongueOffset(), plainIdlerOffset(), toothedIdlerOffset(), topInset, left=false, cnc=true);
}

module yCarriageBraceMGN12H(thickness, plainPulleyOffset, toothedPulleyOffset, boltHoleRadius, pulleyBoreRadius, blockOffsetX=undef, reversedBelts=false, left) {
    yCarriageType = MGN12H_carriage;
    size = left ? (is_undef(blockOffsetX) ? [pulleyBoreRadius == 2 ? 39.65 : 40.65, reversedBelts ? 14 : 12, thickness] : [48.15 + blockOffsetX, 12.5, thickness])
                : (is_undef(blockOffsetX) ? [reversedBelts ? (pulleyBoreRadius == 2 ? 40.25 : 38.5) : 41.15, 14, thickness] : [48.15 + blockOffsetX, 14, thickness]);
    blockSizeX = yCarriageBlockSizeX(yCarriageType);
    difference() {
        blockOffsetX = is_undef(blockOffsetX) ? 0 : blockOffsetX;
        translate([-blockSizeX/2 - blockOffsetX, left ? (blockOffsetX ? -5.5 : reversedBelts ? -7 : -5) : -size.y/2, 0])
            if (left) {
                sizeL = [16.45, 13, size.z];
                hull() {
                    rounded_cube_xy([6.5, size.y, size.z], 1.5);
                    translate([23.7, 0, 0])
                        rounded_cube_xy([1.5, sizeL.y, size.z], 0);
                }
                translate([23.7, 0, 0])
                    rounded_cube_xy(sizeL, 1.5);
            } else {
                rounded_cube_xy([19.5, size.y, size.z], 1.5);
                hull() {
                    translate([18, 0, 0])
                        cube([1.5, size.y, size.z]);
                    sizeR = [6, 12, size.z];
                    translate([size.x - sizeR.x, -sizeR.y + 10, 0])
                        rounded_cube_xy(sizeR, 1.5);
                }
            }

        yCarriageBraceBoltPositionsMGN12(blockSizeX, blockOffsetX, left)
            boltHole(boltHoleRadius*2, size.z, twist=4);
        translate([0, toothedPulleyOffset.y, 0])
            boltHole(pulleyBoreRadius*2, size.z, twist=4);
        translate([12.25 + plainPulleyOffset.x, plainPulleyOffset.y, 0])
            rotate(22.5) // rotate bolthole to maximise wall thickness
                boltHole(pulleyBoreRadius*2, size.z, twist=4);
    }
}

module Y_Carriage_Brace_Left_RB3_stl() {
    stl("Y_Carriage_Brace_Left_RB3");
    color(pp3_colour)
        yCarriageBraceMGN12H(yCarriageBraceThickness(), plainIdlerOffset(), toothedIdlerOffset(), holeRadius, holeRadius, _coreXYDescriptor == "GT2_20_25" ? blockOffsetX : undef, reversedBelts=true, left=true);
}

module Y_Carriage_Brace_Right_RB3_stl() {
    stl("Y_Carriage_Brace_Right_RB3");
    color(pp3_colour)
        yCarriageBraceMGN12H(yCarriageBraceThickness(), plainIdlerOffset(), toothedIdlerOffset(), holeRadius, holeRadius, _coreXYDescriptor == "GT2_20_25" ? blockOffsetX : undef, reversedBelts=true, left=false);
}

module Y_Carriage_Brace_Left_RB4_stl() {
    stl("Y_Carriage_Brace_Left_RB4");
    color(pp3_colour)
        yCarriageBraceMGN12H(yCarriageBraceThickness(), plainIdlerOffset(), toothedIdlerOffset(), M3_tap_radius, holeRadius, _coreXYDescriptor == "GT2_20_25" ? blockOffsetX : undef, reversedBelts=true, left=true);
}

module Y_Carriage_Brace_Right_RB4_stl() {
    stl("Y_Carriage_Brace_Right_RB4");
    color(pp3_colour)
        yCarriageBraceMGN12H(yCarriageBraceThickness(), plainIdlerOffset(left=false), toothedIdlerOffset(left=false), M3_tap_radius, holeRadius, _coreXYDescriptor == "GT2_20_25" ? blockOffsetX : undef, reversedBelts=true, left=false);
}

module Y_Carriage_Brace_Left_16_stl() {
    stl("Y_Carriage_Brace_Left_16")
        color(pp3_colour)
            yCarriageBraceMGN12H(yCarriageBraceThickness(), plainIdlerOffset(), toothedIdlerOffset(), holeRadius, holeRadius, _coreXYDescriptor == "GT2_20_25" ? blockOffsetX : undef, left=true);
}

module Y_Carriage_Brace_Right_16_stl() {
    stl("Y_Carriage_Brace_Right_16")
        color(pp3_colour)
            yCarriageBraceMGN12H(yCarriageBraceThickness(), plainIdlerOffset(), toothedIdlerOffset(), holeRadius, holeRadius, _coreXYDescriptor == "GT2_20_25" ? blockOffsetX : undef, left=false);
}

//!1. Insert the threaded inserts into the **Y_Carriage_Left** as shown.
//!2. Drive a long M3 bolt through the Y carriage from the insert side to self tap the part of the hole after the insert.
//!Once this hole is tapped, remove the bolt.
//!3. Bolt the **Y_Carriage_Brace_Left** and the pulleys to the **Y_Carriage_Left** as shown. Note the position of the washers.
//!4. Tighten the bolts until the pulleys no longer turn freely and then loosen by about 1/4 turn so the pulleys can again turn.
//
module Y_Carriage_Left_assembly() pose(a=[55 + 180, 0, 25])
assembly("Y_Carriage_Left", big=true, ngb=true) {

    yCarriageType = carriageType(_yCarriageDescriptor);
    railOffsetX = coreXYPosBL().x;

    plainIdler = useReversedBelts() ? coreXYBearing() : coreXY_plain_idler(coreXY_type());
    toothedIdler = useReversedBelts() ? coreXYBearing() : coreXY_toothed_idler(coreXY_type());
    pulleyStackHeight = idlerHeight + pulleyWasherHeight();

    translate([railOffsetX, carriagePosition().y, -carriage_height(yCarriageType)])
        rotate([180, 0, 0]) {
            stl_colour(pp2_colour)
                if (useReversedBelts()) {
                    if (coreXYIdlerBore() == 3)
                        Y_Carriage_Left_RB3_stl();
                    else
                        Y_Carriage_Left_RB4_stl();
                } else {
                    Y_Carriage_Left_16_stl();
                }
            if (yCarriageBraceThickness())
                translate_z(yCarriageThickness() + pulleyStackHeight + eps)
                    explode(5*yCarriageExplodeFactor())
                        stl_colour(pp3_colour)
                            if (useReversedBelts()) {
                                if (coreXYIdlerBore() == 3)
                                    Y_Carriage_Brace_Left_RB3_stl();
                                else
                                    Y_Carriage_Brace_Left_RB4_stl();
                            } else {
                                Y_Carriage_Brace_Left_16_stl();
                            }
            yCarriagePulleys(yCarriageType, plainIdler, toothedIdler, yCarriageThickness(), yCarriageBraceThickness(), plainIdlerOffset(), toothedIdlerOffset(), blockOffsetX, left=true);
            if (yCarriageInserts)
                Y_Carriage_inserts(yCarriageType, tongueOffset(), railType(_xCarriageDescriptor), _xRailLength, thickness=yCarriageTongueThickness(yCarriageType));
       }
}

//!1. Insert the threaded inserts into the **Y_Carriage_Right** as shown.
//!2. Drive a long M3 bolt through the Y carriage from the insert side to self tap the part of the hole after the insert.
//! Once this hole is tapped, remove the bolt.
//!3. Bolt the **Y_Carriage_Brace_Right** and the pulleys to the **Y_Carriage_Right** as shown. Note the position of the washers.
//!4. Tighten the bolts until the pulleys no longer turn freely and then loosen by about 1/4 turn so the pulleys can again turn.
//
module Y_Carriage_Right_assembly() pose(a=[55 + 180, 0, 25])
assembly("Y_Carriage_Right", big=true, ngb=true) {

    yCarriageType = carriageType(_yCarriageDescriptor);
    railOffsetX = coreXYPosBL().x;

    plainIdler = useReversedBelts() ? coreXYBearing() : coreXY_plain_idler(coreXY_type());
    toothedIdler = useReversedBelts() ? coreXYBearing() : coreXY_toothed_idler(coreXY_type());
    pulleyStackHeight = idlerHeight + pulleyWasherHeight();

    translate([-railOffsetX, carriagePosition().y, -carriage_height(yCarriageType)])
        rotate([180, 0, 180]) {
            stl_colour(pp2_colour)
                if (useReversedBelts()) {
                    if (coreXYIdlerBore() == 3)
                        Y_Carriage_Right_RB3_stl();
                    else
                        Y_Carriage_Right_RB4_stl();
                } else {
                    Y_Carriage_Right_16_stl();
                }
            if (yCarriageBraceThickness())
                translate_z(yCarriageThickness() + pulleyStackHeight + 2*eps)
                    explode(5*yCarriageExplodeFactor())
                        stl_colour(pp3_colour)
                            if (useReversedBelts()) {
                                if (coreXYIdlerBore() == 3)
                                    Y_Carriage_Brace_Right_RB3_stl();
                                else
                                    Y_Carriage_Brace_Right_RB4_stl();
                            } else {
                                Y_Carriage_Brace_Right_16_stl();
                            }
            yCarriagePulleys(yCarriageType, plainIdler, toothedIdler, yCarriageThickness(), yCarriageBraceThickness(), plainIdlerOffset(left=false), toothedIdlerOffset(left=false), blockOffsetX, left=false);
            if (yCarriageInserts)
                Y_Carriage_inserts(yCarriageType, tongueOffset(), railType(_xCarriageDescriptor), _xRailLength, thickness=yCarriageTongueThickness(yCarriageType));
        }
}

module Y_Carriage_bolts(yCarriageType, thickness, left) {
    railOffsetX = coreXYPosBL().x;

    translate([left ? railOffsetX : -railOffsetX, carriagePosition().y, -carriage_height(yCarriageType)])
        rotate([180, 0, left ? 0 : 180])
            yCarriageBolts(yCarriageType, thickness);
}
