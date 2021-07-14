//!# EVA adaptors
//
include <global_defs.scad>

include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/rails.scad>

use <printed/X_CarriageEVA.scad>
use <utils/CoreXYBelts.scad>

use <../scad/Parameters_Positions.scad>
include <target.scad>


//$explode = 1;
module EVA_assembly()
assembly("EVA", big=true) {

    hidden()
        stl_colour(evaColorGrey())
            evaPrintheadList();

    xCarriageType = MGN12H_carriage;

    translate_z(carriage_height(xCarriageType)) {
        stl_colour(evaColorGrey())
            not_on_bom()
                evaHotendBase(top="bmg_mgn12", explode=60);
        evaHotendBaseHardware(explode=60);
        stl_colour(pp2_colour)
            evaTensioners();
        stl_colour(pp2_colour)
            evaBeltClamps();
        translate([0, 18.5, -20.5]) {
            explode([0, 30, 0])
                stl_colour(evaColorGreen())
                    EVA_MC_back_corexy_stl();
            *explode([0, -30, 0])
                translate([0, -32, 0])
                    stl_colour(evaColorGreen())
                        EVA_MC_universal_face_stl();
        }
    }
    explode(40)
        not_on_bom()
            rail_assembly(xCarriageType, _xRailLength, pos=0, carriage_end_colour="green", carriage_wiper_colour="red");
    carriagePosition = carriagePosition();
    if (!exploded())
        rotate(180)
            translate(-[eSize + eX/2, carriagePosition.y, eZ - yRailOffset().x - carriage_clearance(xCarriageType)])
                CoreXYBelts(carriagePosition + [-2, 0], x_gap=-25);
}

if ($preview)
    EVA_assembly();
