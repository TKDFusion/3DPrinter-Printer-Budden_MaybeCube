_variant = "JubileeToolChanger";

__extrusionLengths = [400, 400, 400];
eX = __extrusionLengths.x;
eY = __extrusionLengths.y;
eZ = __extrusionLengths.z;

eSize = 20;

_xyMotorDescriptor = "NEMA17_48";
_zMotorDescriptor = "NEMA17_40L280";


_xRailLength = eX - 50;
_yRailLength = eY;
_zRodLength = eZ - 100;

_xCarriageDescriptor = "MGN12H";
_xCarriageCountersunk = true;
_yCarriageDescriptor = "MGN12H";


_coreXYDescriptor = "GT2_20_F623";

_useReversedBelts = true;

_printbedArmSeparation = 150;

__skBracketWidth = 42; // same for SK8, SK10, and SK12
_zRodOffsetY = __skBracketWidth/2 + 40;
_zLeadScrewOffset = 30;// ensures clearance of zMotor from frame and zRail
_upperZRodMountsExtrusionOffsetZ = eZ - 90;
