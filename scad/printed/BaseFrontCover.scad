include <../global_defs.scad>

include <NopSCADlib/core.scad>
include <NopSCADlib/utils/fillet.scad>

use <../vitamins/bolts.scad>
use <../vitamins/displays.scad>
use <../../../BabyCube/scad/printed/DisplayHousing.scad>

use <DisplayHousingAssemblies.scad>

include <../Parameters_Main.scad>


fillet = 2;
countersunk = false;
lip = 3;
height = 8;

module Front_Cover_stl() {
    size = [eX/2, eSize + lip, height];

    stl("Front_Cover")
        color(pp1_colour)
            difference() {
                translate([0, eSize - size.y, 0])
                    rounded_cube_xy(size, fillet);
                for (x = [20, size.x - 20])
                    translate([x, eSize/2, size.z])
                        if (countersunk)
                            boltPolyholeM3Countersunk(size.z, sink=0.25);
                        else
                            vflip()
                                boltHoleM3(size.z);
            }
}

module Front_Display_Wiring_Cover_stl() {
    display_type = BTT_TFT35_E3_V3_0();
    size1 = [displayHousingSize(display_type).x, eSize + 5, height];
    size2 = [displayHousingSize(display_type).x, size1.y - eSize, eSize + size1.z];
    size3 = [eX/2 - size1.x, eSize + lip, size1.z];
    channelWidth = 20;
    channelDepth = size1.z - 1;


    stl("Front_Display_Wiring_Cover")
        color(pp2_colour)
            vflip()
                difference() {
                    union() {
                        translate_z(channelDepth)
                            rounded_cube_xy([size1.x, size1.y, size1.z - channelDepth], fillet);
                        for (x = [0, (size1.x + channelWidth)/2])
                            translate([x, 0, 0])
                                rounded_cube_xy([(size1.x - channelWidth)/2, size1.y, size1.z], fillet);
                        for (x = [0, (size1.x + channelWidth)/2])
                            translate([x, eSize, size1.z - size2.z])
                                rounded_cube_xy([(size2.x - channelWidth)/2, size2.y, size2.z], fillet);
                        // cover the gap
                        translate([(size1.x - channelWidth)/2 - 2*fillet, eSize + 5, size1.z - size2.z]) {
                            depth = 2;
                            translate([0, -depth, 0])
                                cube([channelWidth + 4*fillet, depth, size2.z]);
                            for (x =  [0, channelWidth + 2*fillet])
                                translate([x, -fillet, 0])
                                    cube([2*fillet, fillet, size2.z]);
                            translate([2*fillet, -depth, 0])
                                rotate(-90)
                                    fillet(1, size2.z);
                            translate([channelWidth + 2*fillet, -depth, 0])
                                rotate(180)
                                    fillet(1, size2.z);
                        }
                        translate([size1.x, eSize - size3.y, 0])
                            rounded_cube_xy(size3, fillet);
                        translate([size1.x, eSize, 0])
                            fillet(fillet, size1.z);
                        // cover the undesired fillets
                        translate([size1.x - 2*fillet, 0, 0])
                            cube([4*fillet, eSize, size1.z]);
                    }
                    for (x = [20, size1.x + size3.x - 20])
                        translate([x, eSize/2, size1.z])
                            if (countersunk)
                                boltPolyholeM3Countersunk(size1.z, sink=0.25);
                            else
                                vflip()
                                    boltHoleM3(size1.z);
                }
}