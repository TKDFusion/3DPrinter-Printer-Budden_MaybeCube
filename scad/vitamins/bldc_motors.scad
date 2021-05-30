//
//  Brushless hDC electric motors
//
crimson = [220/255,20/255,60/255];
//                                     shaft  shaft shaft      body   base             holes                 base            side  bell             holes          boss  prop shaft   thread
//                      diameter height diam length offset   colour   diam   h1    h2  diam position         open  wire    colour  diam   h1    h1  d  pos spokes  d  h  length diam  length  diam
BLDC0603  = ["BLDC0603",    9.0,  8,    1,    15.5,     1, crimson,    10,   1,  1.5,  1.6, [6,6,6],        true,  0.8, grey(20),    9,   1,    1,  0,  0,     5,  0, 0,     0,   0,      0,     0];
BLDC0802  = ["BLDC0802",   11.5,  9.5,  1.5,    12,   0.5, grey(20),    9,   1,    2,  1.6, [6,6,6],        true,  1.0, grey(20),   11,   2, 0.75,  0,  0,     3,  0, 0,     0,   0,      0,     0];
BLDC1105  = ["BLDC1105",   14.0, 11.75, 1.5,    11,     0, grey(90), 12.5, 1.6,  1.4,  2,    9,             true,  1.0, grey(90),   12,   1,    1,  2,  [5,5], 4,  0, 0,     0,   0,      0,     0];
BLDC1306  = ["BLDC1306",  17.75, 14.5,    2,    14,     0, crimson,    16, 1.5,    1,  2,   12,            false,  1.0, grey(20),   12,   1,    1,  0,  0,     6,  8, 1,  11.5,   5,    6.5,     5];
BLDC1804  = ["BLDC1804",   23.0, 12,      2,    11,     0, grey(20),   19, 2.5,  1.5,  2,   12,            false,  1.5, grey(20),   18,   1,  2.5,  0,  0,     6,  9, 1,    12,   5,      6,     5];
BLDC2205  = ["BLDC2205",   28.0, 17.25,   3,    16,     0, crimson,    26,   2,    3,  3,   [19,16,19,16], false,  1.6, grey(20), 22.5,   1, 3.75,  0,  0,     6,  0, 0,    14,   5,      9,     5];
BLDC2212  = ["BLDC2212",   28.0, 27,      3,    26,     0, grey(20),   23,   4,    2,  3,   [19,16,19,16], false,  2.0, grey(20),   18,   2,    4,  0,  0,     6,  0, 0,    14,   8,      7,     6];
BLDC4250  = ["BLDC4250",   42.5, 48,      5,    70,    20, crimson,    30,   4,    6,  3,   25,            false,  3.5, grey(20),   30,   6,    4,  3, 17,     8, 12, 2,     0,   0,      0,     0];

bldc_motors = [BLDC0603, BLDC0802, BLDC1105, BLDC1306, BLDC1804, BLDC2205, BLDC2212, BLDC4250];
//bldc_motors = [BLDC0603, BLDC1105,BLDC1804,BLDC4250];
//bldc_motors = [BLDC2205];
use <bldc_motor.scad>
