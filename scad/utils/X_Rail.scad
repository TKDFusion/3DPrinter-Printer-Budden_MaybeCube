include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/rails.scad>

use <carriageTypes.scad>

include <../Parameters_Main.scad>


module xRailBoltPositions(carriagePosition) {
    xCarriageType = xCarriageType(_xCarriageDescriptor);
    xRailType = carriage_rail(xCarriageType);
    yRailType = yRailType(_yCarriageDescriptor);
    translate([eSize + eX/2, carriagePosition.y, -eSize - rail_height(xRailType) - rail_height(yRailType) + carriage_clearance(xCarriageType)])
        for (x = [1, 3], s = [-_xRailLength/2, _xRailLength/2 - 2*rail_pitch(xRailType)])
            translate([s + x*rail_pitch(xRailType)/2, 0, rail_height(xRailType) - rail_bore_depth(xRailType)])
                children();
}

module xRail(carriagePosition, xCarriageType=undef) {
    xCarriageType = is_undef(xCarriageType) ? xCarriageType(_xCarriageDescriptor) : xCarriageType;
    xRailType = carriage_rail(xCarriageType);
    yRailType = yRailType(_yCarriageDescriptor);
    translate([eSize + eX/2, carriagePosition.y, -eSize - rail_height(xRailType) - rail_height(yRailType) + carriage_clearance(xCarriageType)])
        rotate(180)
            if (is_undef($hide_rails) || $hide_rails == false)
                rail_assembly(xCarriageType, _xRailLength, eX - _xRailLength/2 - 5 - carriagePosition.x, carriage_end_colour="green", carriage_wiper_colour="red");
}

module xRailCarriagePosition(carriagePosition, rotate=180) {
    xCarriageType = xCarriageType(_xCarriageDescriptor);
    xRailType = carriage_rail(xCarriageType);
    yRailType = yRailType(_yCarriageDescriptor);
    translate([ carriagePosition.x + eSize + 5 - (eX - _xRailLength)/2,
                carriagePosition.y,
                eZ - eSize - rail_height(xRailType) - rail_height(yRailType) + carriage_clearance(xCarriageType) + carriage_height(xCarriageType)
            ])
        rotate(rotate)
            children();
}
