include <../global_defs.scad>

include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/rails.scad>

include <../Parameters_Main.scad>

function xCarriageType() =
    _xCarriageType == "7C" ? MGN7C_carriage :
    _xCarriageType == "9C" ? MGN9C_carriage :
    _xCarriageType == "9H" ? MGN9H_carriage :
    MGN12H_carriage;

function yCarriageType() =
    _yCarriageType == "7C" ? MGN7C_carriage :
    _yCarriageType == "9C" ? MGN9C_carriage :
    _yCarriageType == "9H" ? MGN9H_carriage :
    MGN12H_carriage;

function xRailType() = carriage_rail(xCarriageType());
function yRailType() = carriage_rail(yCarriageType());


function railFirstHoleOffset(type, length) = (length - (rail_holes(type, length) - 1)*rail_pitch(type))/2;
