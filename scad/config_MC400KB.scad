_variant = "MC400KB";

__extrusionLengths = [400, 400, 450];
eX = __extrusionLengths.x;
eY = __extrusionLengths.y;
eZ = __extrusionLengths.z;

eSize = 20;

_xyMotorDescriptor = "NEMA17_48";
_zMotorDescriptor = "NEMA17_40L330";
_corkDamperThickness = 2;

_xRailLength = eX - 50;
_yRailLength = eY;
_zRailLength = eZ - 100;

_xCarriageDescriptor = "MGN12H";
_xCarriageCountersunk = true;
_yCarriageDescriptor = "MGN12H";
_zCarriageDescriptor = "MGN12C";

_beltWidth = 6;

_use2060ForTop = true;

_printBedSize = [305, 300, 6.35];
_printBedHoleOffset = [8, 30];
_printBedArmSeparation = 50 + _printBedSize.y - 2*_printBedHoleOffset.y;
_printBedKinematic = true;

_zRodOffsetY = 66;
_zLeadScrewOffset = 30;// ensures clearance of zMotor from frame and zRail
_upperZRodMountsExtrusionOffsetZ = eZ - 90;
