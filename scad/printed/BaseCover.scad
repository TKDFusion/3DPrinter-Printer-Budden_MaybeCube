include <../global_defs.scad>

use <NopSCADlib/utils/fillet.scad>
use <NopSCADlib/vitamins/sheet.scad>
include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/vitamins/screws.scad>
include <NopSCADlib/vitamins/fans.scad>

include <../vitamins/bolts.scad>
include <../vitamins/nuts.scad>

use <extruderBracket.scad> // for iecHousingMountSize()

include <../Parameters_Main.scad>

supportHeight = 70;
baseCoverTopSize = [eX > 300 ? 260 : 210, eY + eSize, 3];
baseCoverBackSupportSize = [baseCoverTopSize.x, eSize, supportHeight - 2*eSize];
baseCoverSideSupportSize = [8, eY/2, supportHeight];
baseCoverFrontSupportSize = [baseCoverTopSize.x - baseCoverSideSupportSize.x, 12, 3*eSize/2];

module baseCoverBackSupport(size) {
    difference() {
        rounded_cube_xy(baseCoverBackSupportSize, 2);
        for (x = [10, size.x/2, size.x - 10])
            translate([x, size.y/2, size.z])
                vflip()
                    boltHoleM3(10);
        for (x = [size.x/4, 3*size.x/4])
            translate([x, size.y/2, size.z])
                vflip()
                    boltHoleM3Counterbore(size.z, boreDepth = size.z - 5);
    }
}

module Base_Cover_Back_Support_hardware() {
    size = baseCoverBackSupportSize;
    for (x = [size.x/4, 3*size.x/4])
        translate([x, size.y/2, 5])
            explode(30, true)
                boltM3ButtonheadHammerNut(8, nutExplode=50);
}

module Base_Cover_Back_Support_210_stl() {
    stl("Base_Cover_Back_Support_210")
        color(pp1_colour) 
            baseCoverBackSupport(baseCoverBackSupportSize);
}

module Base_Cover_Back_Support_260_stl() {
    stl("Base_Cover_Back_Support_260")
        color(pp1_colour) 
            baseCoverBackSupport(baseCoverBackSupportSize);
}

module baseCoverFrontSupport(size) {
    difference() {
        rounded_cube_xy([size.x, size.z, 3], 1);
        for (x = [10, size.x/2, size.x - 10])
            translate([x, 20, 0])
                boltHoleM3(3);
    }
    difference() {
        rounded_cube_xy([size.x, 5, size.y], 1);
        for (x = [10, size.x/2, size.x - 10])
            translate([x, 0, 7.5])
                rotate([-90, 180, 0])
                    boltHoleM3(5, horizontal=true);
    }
}

module Base_Cover_Front_Support_hardware() {
    size = baseCoverFrontSupportSize;
    for (x = [10, size.x/2, size.x - 10])
        translate([x, 20, 3])
            explode(30, true)
                boltM3ButtonheadHammerNut(8, nutExplode=40);
}

module Base_Cover_Front_Support_202_stl() {
    stl("Base_Cover_Front_Support_202")
        color(pp2_colour)
            baseCoverFrontSupport(baseCoverFrontSupportSize);
}
module Base_Cover_Front_Support_252_stl() {
    stl("Base_Cover_Front_Support_252")
        color(pp2_colour)
            baseCoverFrontSupport(baseCoverFrontSupportSize);
}

module baseCoverSideSupport(size, tap=false) {
    overlap = 5;
    difference() {
        union() {
            rounded_cube_xy([size.z, size.y + overlap, size.x/2], 1);
            rounded_cube_xy([size.z, size.y - overlap, size.x], 1);
        }
        for (y = [size.y/4, 3*size.y/4]) {
            translate([0, y, size.x/2])
                rotate([0, 90, 0])
                    boltHoleM3Tap(10, horizontal=true, rotate=90, chamfer_both_ends=false);
            translate([size.z, y, size.x/2])
                rotate([0, -90, 0])
                    boltHoleM3Tap(10, horizontal=true, rotate=-90, chamfer_both_ends=false);
        }
        for (x = [size.z/4, 3*size.z/4])
            translate([x, size.y, 0])
                if (tap)
                    boltHoleM3Tap(size.x/2);
                else
                    boltHoleM3(size.x/2);
    }
}

module Base_Cover_Side_Support_150A_stl() {
    stl("Base_Cover_Side_Support_150A")
        color(pp1_colour)
            baseCoverSideSupport(baseCoverSideSupportSize, tap=false);
}

module Base_Cover_Side_Support_150B_stl() {
    stl("Base_Cover_Side_Support_150B")
        color(pp2_colour)
            baseCoverSideSupport(baseCoverSideSupportSize, tap=true);
}

module Base_Cover_Side_Support_175A_stl() {
    stl("Base_Cover_Side_Support_175A")
        color(pp1_colour)
            baseCoverSideSupport(baseCoverSideSupportSize, tap=false);
}

module Base_Cover_Side_Support_175B_stl() {
    stl("Base_Cover_Side_Support_175B")
        color(pp2_colour)
            baseCoverSideSupport(baseCoverSideSupportSize, tap=true);
}

BaseCover = ["BaseCover", "Sheet perspex", 3, pp3_colour, false];

module baseCoverTopHolePositions(size) {
    xFront = baseCoverFrontSupportSize.x;
    for (x = [10, xFront/2, xFront - 10])
        translate([x - size.x/2 + baseCoverSideSupportSize.x, 8 - size.y/2, 0])
            children();
    yLeft = baseCoverSideSupportSize.y/4;
    for (y = [yLeft, 3*yLeft, 5*yLeft, 7*yLeft])
        translate([4 -size.x/2, y -size.y/2, 0])
            children();
    xBack = baseCoverBackSupportSize.x;
    for (x = [10, xBack/2, xBack - 10])
        translate([x - size.x/2, size.y/2 - 10, 0])
            children();
}

module baseCoverTopAssembly(addBolts=true) {
    size = baseCoverTopSize;

    translate([eX + eSize - size.x/2, eSize + size.y/2, supportHeight + size.z/2]) {
        if (addBolts)
            baseCoverTopHolePositions(size)
                translate_z(size.z/2)
                    boltM3Buttonhead(8);
        render_2D_sheet(BaseCover, w=size.x, d=size.y)
            if (eX == 300)
                Base_Cover_210_dxf();
            else
                Base_Cover_260_dxf();
    }
}

module baseCoverDxf(size) {
    sheet = BaseCover;
    fillet = 1;

    color(sheet_colour(sheet))
        difference() {
            sheet_2D(sheet, size.x, size.y, fillet);
            baseCoverTopHolePositions(size)
                circle(r=M3_clearance_radius);
        }
}
module Base_Cover_210_dxf() {
    dxf("Base_Cover_210")
        baseCoverDxf(baseCoverTopSize);
}

module Base_Cover_260_dxf() {
    dxf("Base_Cover_260")
        baseCoverDxf(baseCoverTopSize);
}

module Base_Cover_Top_stl() {
    stl("Base_Cover_Top")
        color(pp3_colour)
            rounded_cube_xy(baseCoverTopSize, 2);
}


module baseCoverFrontSupportsAssembly() {
    translate([eX + eSize - baseCoverFrontSupportSize.x, eSize, supportHeight])
        rotate([-90, 0, 0]) {
            color(pp2_colour)
                if (eX == 300)
                    Base_Cover_Front_Support_202_stl();
                else
                    Base_Cover_Front_Support_252_stl();
            Base_Cover_Front_Support_hardware();
        }
}

module baseCoverBackSupportsAssembly() {
    translate([eX - baseCoverBackSupportSize.x, 0, 2*eSize]) {
        color(pp1_colour)
            if (eX == 300)
                Base_Cover_Back_Support_210_stl();
            else
                Base_Cover_Back_Support_260_stl();
        Base_Cover_Back_Support_hardware();
    }
}

module baseCoverSideSupportsAssembly() {
    size = baseCoverSideSupportSize;
    translate([eX + eSize - baseCoverBackSupportSize.x + size.x, eSize, 0])
        rotate([0, -90, 0]) {
            color(pp1_colour)
                if (eX == 300)
                    Base_Cover_Side_Support_150A_stl();
                else
                    Base_Cover_Side_Support_175A_stl();
            for (x = [size.z/4, 3*size.z/4])
                translate([x, size.y, 0])
                    vflip()
                        boltM3Buttonhead(size.x);
        }
    translate([eX + eSize - baseCoverBackSupportSize.x, eSize + 2*size.y, 0])
        rotate([180, -90, 0])
            color(pp2_colour)
                if (eX == 300)
                    Base_Cover_Side_Support_150B_stl();
                else
                    Base_Cover_Side_Support_175B_stl();
}

module baseCoverTopSupportsAssembly() {
    translate([eX - baseCoverBackSupportSize.x, eSize, supportHeight])
        Base_Cover_Top_stl();
}

module baseCoverSupportsAssembly() {
    baseCoverFrontSupportsAssembly();
    baseCoverBackSupportsAssembly();
    baseCoverSideSupportsAssembly();
}

module baseFanMountHolePositions(size, z=0) {
    for (x = [eSize/2, size.x - eSize/2], y = [eSize/2,  size.y - eSize/2])
        translate([x, y, z])
            rotate(exploded() ? 0 : 90)
                children();

}

module baseFanPosition(size, offsetX=0, z=0) {
    translate([offsetX > 0 ? offsetX : size.x + offsetX, size.y/2 - 2.5, z])
        children();
}

module baseFanMount(sizeX, offsetX=0) {
    size = [sizeX, iecHousingMountSize(eX).y, 3];
    fillet = 2;
    fan = fan40x11;

    difference() {
        rounded_cube_xy(size, fillet);
        baseFanPosition(size, offsetX, size.z/2)
            fan_holes(fan, h=size.z + 2*eps);
        baseFanMountHolePositions(size)
            boltHoleM4(size.z);
    }
}

module Base_Fan_Mount_120A_stl() {
    stl("Base_Fan_Mount_120A")
        color(pp1_colour)
            vflip() // better orientation for printing
                baseFanMount((eY + 2*eSize - iecHousingMountSize(eX).x)/2, 50);
}

module Base_Fan_Mount_145A_stl() {
    stl("Base_Fan_Mount_145A")
        color(pp1_colour) {
            vflip() // better orientation for printing
                baseFanMount((eY + 2*eSize - iecHousingMountSize(eX).x)/2, 50);
        }
}

module Base_Fan_Mount_120B_stl() {
    stl("Base_Fan_Mount_120B")
        color(pp2_colour)
            vflip() // better orientation for printing
                baseFanMount((eY + 2*eSize - iecHousingMountSize(eX).x)/2, -40);
}

module Base_Fan_Mount_145B_stl() {
    stl("Base_Fan_Mount_145B")
        color(pp2_colour)
            vflip() // better orientation for printing
                baseFanMount((eY + 2*eSize - iecHousingMountSize(eX).x)/2, -40);
}

module baseFanMountAssembly() {
    size = [(eY + 2*eSize - iecHousingMountSize(eX).x)/2, iecHousingMountSize(eX).y, 3];
    fan = fan40x11;

    translate([eX + 2*eSize, 0, 0])
        rotate([90, 0, 90]) 
            explode(50, true) {
                color(pp1_colour)
                    vflip()
                        if (eX == 300)
                            Base_Fan_Mount_120A_stl();
                        else
                            Base_Fan_Mount_145A_stl();
                baseFanMountHolePositions(size, size.z)
                    boltM4ButtonheadHammerNut(8);
                baseFanPosition(size, 50, size.z/2 - fan_thickness(fan)) {
                    explode(-15)
                        fan(fan);
                    fan_hole_positions(fan) {
                        translate_z(size.z)
                            boltM3Buttonhead(16);
                        translate_z(-size.z - fan_thickness(fan))
                            explode(-30)
                                nutM3();
                    }
            }
        }
    translate([eX + 2*eSize, (eY + 2*eSize - iecHousingMountSize(eX).x)/2, 0])
        rotate([90, 0, 90])
            explode(50, true) {
                color(pp2_colour)
                    vflip()
                        if (eX == 300)
                            Base_Fan_Mount_120B_stl();
                        else
                            Base_Fan_Mount_145B_stl();
                baseFanMountHolePositions(size, size.z)
                    boltM4ButtonheadHammerNut(8);
                baseFanPosition(size, -40, size.z/2 - fan_thickness(fan)) {
                    explode(-15)
                        fan(fan);
                    fan_hole_positions(fan) {
                        translate_z(size.z)
                            boltM3Buttonhead(16);
                        translate_z(-size.z - fan_thickness(fan))
                            explode(-30)
                                nutM3();
                    }
                }
            }
}

