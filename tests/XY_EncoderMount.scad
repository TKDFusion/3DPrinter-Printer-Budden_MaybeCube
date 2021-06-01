//!Display the left and right motor encoder mounts.
include <../scad/global_defs.scad>

include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/bldc_motors.scad>

include <../scad/printed/XY_EncoderMount.scad>
include <../scad/printed/XY_MotorMount.scad>
use <../scad/utils/CoreXYBelts.scad>

use <../scad/Parameters_Positions.scad>
include <../scad/Parameters_Main.scad>

BLDC_type = BLDC4250;

//$explode = 1;
//$pose=1;
module XY_Motor_Mount_test() {
    CoreXYBelts(carriagePosition(), show_pulleys=[1, 0, 0], xyMotorWidth=56);
    //XY_Motor_Mount_4250_Left_stl();
    //let($hide_bolts=true)
    //XY_Motor_Mount_hardware(BLDC_type, left=true);
    XY_Motor_Mount_4250_Left_assembly();
    XY_Encoder_Mount_Left_assembly();
    //XY_Motor_Mount_4250_Right_stl();
    //XY_Motor_Mount_hardware(BLDC_type, left=false);
    XY_Motor_Mount_4250_Right_assembly();
    XY_Encoder_Mount_Right_assembly();
}

//cornerCube([20, 20, 10], -1, 5);
*rotate(0) {
    XY_Encoder_Mount_stl();
    vflip()
        BLDC(BLDC_type);
}

if ($preview)
    translate([0, -eY - eSize, -eZ + eSize])
        XY_Motor_Mount_test();
