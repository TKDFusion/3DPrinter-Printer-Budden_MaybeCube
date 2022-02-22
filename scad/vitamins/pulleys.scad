include <NopSCADlib/vitamins/ball_bearings.scad>
include <NopSCADlib/vitamins/belts.scad>

//                                                         n       t   o      b         w    h  h    b     f    f  s   s    s              s
//                                                         a       e   d      e         i    u  u    o     l    l  c   c    c              c
//                                                         m       e          l         d    b  b    r     a    a  r   r    r              r
//                                                         e       t          t         t            e     n    n  e   e    e              e
//                                                                 h                    h    d  l          g    g  w   w    w              w
//                                                                                                         e    e                          s
//                                                                                                                 l   z
//                                                                                                         d    t
//
GT2x20x11_pulley          = ["GT2x20x11_pulley",          "GT2",   20, 12.22, GT2x9, 11.0,  15, 7.5, 5, 15.0, 1.5, 6, 3.25, M3_grub_screw, 2]; //Openbuilds
GT2x20x11x3_toothed_idler = ["GT2x20x11x3_toothed_idler", "GT2",   20, 12.22, GT2x9, 11.0,  16, 0,   3, 16.0, 1.5, 0, 0,    false,         0];
GT2x20x11x3_plain_idler   = ["GT2x20x11x3_plain_idler",   "GT2",    0, 12.0,  GT2x9, 11.0,  16, 0,   3, 16.0, 1.5, 0, 0,    false,         0];
GT2x20x3_toothed_idler_sf = ["GT2x20x3_toothed_idler_sf", "GT2",   20, 12.22, GT2x6,  6.5,  18, 0,   3, 13.5, 1.0, 0, 0,    false,         0];
GT2x20x3_plain_idler_sf   = ["GT2x20x3_plain_idler_sf",   "GT2",    0, 12.0,  GT2x6,  6.5,  18, 0,   3, 13.5, 1.0, 0, 0,    false,         0];
// simulate flange bearing F623, most similar in size to GT2x16 pulley
GT2x16x6p5x3_plain_idler_fb=["GT2x16x6p5x3_plain_idler_fb","GT2",   0, 10.0,  GT2x6,  6.5,  11.5,0,  3, 11.5, 1.0, 0, 0,    false,         0];
GT2x25x7x3_toothed_idler  = ["GT2x25x7x3_toothed_idler",  "GT2",   25, 15.41, GT2x6,  7.0,  20, 0,   3, 20.0, 2.0, 0, 0,    false,         0];
GT2x25x7x3_plain_idler    = ["GT2x25x7x3_plain_idler",    "GT2",    0, 15.4,  GT2x6,  7.0,  20, 0,   3, 20.0, 2.0, 0, 0,    false,         0];
GT2x25x11x3_toothed_idler = ["GT2x25x11x3_toothed_idler", "GT2",   25, 15.41, GT2x9, 11.0,  20, 0,   3, 20.0, 2.0, 0, 0,    false,         0];
GT2x25x11x3_plain_idler   = ["GT2x25x11x3_plain_idler",   "GT2",    0, 15.4,  GT2x9, 11.0,  20, 0,   3, 20.0, 2.0, 0, 0,    false,         0];
//GT2x40_pulley           = ["GT2x40_pulley",             "GT2",   40, 24.95, GT2x6,  7.1,  18, 7.0, 5, 28.15,1.5, 6, 3.5,  M4_grub_screw, 2];
GT2x40sd_pulley           = ["GT2x40sd_pulley",           "GT2sd", 40, 24.95, GT2x6,  7.0,  18, 0.0, 5, 28.15-1.6,0.8, 0, 0,false,         0];
GT2x20sd_pulley           = ["GT2x20sd_pulley",           "GT2sd", 20, 12.22, GT2x6,  7.0,  18, 0.0, 5, 14.02,0.8, 0, 0,    false,         0];
//GT2x20um_pulley         = ["GT2x20um_pulley",           "GT2UM", 20, 12.22, GT2x6,  7.5,  18, 6.5, 5, 18.0, 1.0, 6, 3.75, M3_grub_screw, 2]; //Ultimaker
//GT2x20ob_pulley         = ["GT2x20ob_pulley",           "GT2OB", 20, 12.22, GT2x6,  7.5,  16, 5.5, 5, 16.0, 1.0, 6, 3.25, M3_grub_screw, 2]; //Openbuilds

function bearingStackHeight(bearingType=BBF623, washer=M3_washer) = 3*washer_thickness(washer) + 2*bb_width(bearingType);

module bearingStack(bearingType=BBF623, washer=M3_washer, explode=5) {
    echo(bsh=bearingStackHeight());
    washer(washer);
    translate_z(washer_thickness(washer) + bb_width(bearingType)/2) {
        explode(explode)
            ball_bearing(bearingType);
        explode(2*explode)
            translate_z(bb_width(bearingType)/2)
                washer(washer);
        explode(3*explode)
            translate_z(bb_width(bearingType) + washer_thickness(washer))
                vflip()
                    ball_bearing(bearingType);
        explode(4*explode)
            translate_z(3*bb_width(bearingType)/2 + washer_thickness(washer))
                washer(washer);
    }
    if ($children)
        translate_z(bearingStackHeight(bearingType, washer))
            children();
}
