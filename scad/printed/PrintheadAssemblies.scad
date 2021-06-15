//!! This is a copy of the BabyCube file
include <../global_defs.scad>

include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/blowers.scad>
include <NopSCADlib/vitamins/rails.scad>

use <../utils/PrintheadOffsets.scad>
use <../utils/X_rail.scad>

use <../vitamins/bolts.scad>
include <../vitamins/pcbs.scad>

use <../../../BabyCube/scad/printed/Printhead.scad>
use <../../../BabyCube/scad/printed/X_Carriage.scad>
use <X_CarriageAssemblies.scad>

use <../Parameters_CoreXY.scad>
include <../Parameters_Main.scad>


function hotendClampOffset(xCarriageType, hotend_type=0) =  [hotendOffset(xCarriageType, hotend_type).x, 18 + xCarriageBackOffsetY(xCarriageType) + grooveMountOffsetX(hotend_type), hotendOffset(xCarriageType, hotend_type).z];
grooveMountFillet = 1;
function grooveMountClampSize(blower_type, hotend_type) = [grooveMountSize(blower_type, hotend_type).y - 2*grooveMountFillet - grooveMountClampOffsetX(), 12, 17];

//!1. Assemble the E3D hotend, including fan, thermistor cartridge and heater cartridge.
//!2. Use the Hotend_Clamp to attach the hotend to the X_Carriage.
//!3. Collect the wires together and attach to the X_Carriage using the Hotend_Strain_Relief_Clamp.
module Printhead_MGN12H_assembly()
assembly("Printhead_MGN12H", big=true) {

    xCarriageType = MGN12H_carriage;
    blower_type = blower_type();
    hotend_type = 0;

    X_Carriage_MGN12H_assembly();
    *translate([0, 0, 10])
        rotate(90)
            pcb(ADXL345);

    hotendOffset = hotendOffset(xCarriageType, hotend_type);
    hotEndHolderAlign(xCarriageType, hotendOffset, left=false) {
        explode([20, 0, 0])
            hotEndHolderHardware(xCarriageType, hotend_type);

        translate(hotendClampOffset(xCarriageType, hotend_type))
            rotate([90, 0, -90]) {
                explode(-40, true) {
                    stl_colour(pp2_colour)
                        if (blower_size(blower_type).x == 30)
                            Hotend_Clamp_stl();
                        else
                            Hotend_Clamp_40_stl();
                    Hotend_Clamp_hardware(xCarriageType, blower_type, hotend_type);
                }
                explode(-60, true)
                    translate([0, grooveMountClampStrainReliefOffset(), -grooveMountClampSize(blower_type, hotend_type).z - 5])
                        vflip() {
                            stl_colour(pp1_colour)
                                Hotend_Strain_Relief_Clamp_stl();
                            Hotend_Strain_Relief_Clamp_hardware();
                        }
            }
    }
}

module fullPrinthead(xCarriageType, rotate=180, explode=0, t=undef) {
    xRailCarriagePosition(t)
        explode(explode, true)
            rotate(rotate) {// for debug, to see belts better
                explode([0, -20, 0], true) {
                    X_Carriage_Front_MGN12H_assembly();
                    xCarriageFrontAssemblyBolts(xCarriageType, _beltWidth);
                }
                Printhead_MGN12H_assembly();
                xCarriageTopBolts(xCarriageType);
                if (!exploded())
                    xCarriageBeltFragments(xCarriageType, coreXY_belt(coreXY_type()), beltOffsetZ(), coreXYSeparation().z, coreXY_upper_belt_colour(coreXY_type()), coreXY_lower_belt_colour(coreXY_type()));
            }
}

module hotEndHolderHardware(xCarriageType, hotend_type = 0) {
    hotendOffset = hotendOffset(xCarriageType, hotend_type);

    translate(hotendOffset)
        E3Dv6plusFan();
}

module Hotend_Strain_Relief_Clamp_stl() {
    holeSpacing = hotendStrainReliefClampHoleSpacing();
    size = [holeSpacing + 8, 10, 3];

    stl("Hotend_Strain_Relief_Clamp")
        color(pp1_colour)
            linear_extrude(size.z)
                difference() {
                    rounded_square([size.x, size.y], 1.5);
                    for (x = [-holeSpacing/2, holeSpacing/2])
                        translate([x, 0, 0])
                            poly_circle(r = M3_clearance_radius);
                }
}

module Hotend_Strain_Relief_Clamp_hardware() {
    holeSpacing = hotendStrainReliefClampHoleSpacing();
    size = [holeSpacing + 8, 10, 3];

    for (x = [-holeSpacing/2, holeSpacing/2])
        translate([x, 0, size.z])
            boltM3Buttonhead(12);
}

module Hotend_Clamp_stl() {
    blower_type = BL30x10;

    stl("Hotend_Clamp")
        color(pp2_colour)
            mirror([1, 0, 0])
                grooveMountClamp(grooveMountClampSize(blower_type));
}

module Hotend_Clamp_40_stl() {
    blower_type = BL40x10;

    stl("Hotend_Clamp")
        color(pp2_colour)
            mirror([1, 0, 0])
                grooveMountClamp(grooveMountClampSize(blower_type));
}

module Hotend_Clamp_hardware(xCarriageType, blower_type, hotend_type) {
    grooveMountClampHardware(grooveMountClampSize(blower_type, hotend_type));
}

module Hotend_Clamp_MGN12H_stl() {
    blower_type = BL40x10;

    stl("Hotend_Clamp_MGN12H")
        color(pp2_colour)
            grooveMountClamp(MGN12H_carriage, 0, blower_type);
}
