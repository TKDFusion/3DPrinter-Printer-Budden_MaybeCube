function isNEMAType(motorType) = is_list(motorType) && motorType[0][0] == "N";

function motorWidth(motorType) = isNEMAType(motorType) ? NEMA_width(motorType) : motorType[0]=="BLDC4250" ? 56 : 62.5;

function motorType(motorDescriptor) =
    motorDescriptor == "NEMA14" ? NEMA14_36 :
    motorDescriptor == "NEMA14_36" ? NEMA14_36 :
    motorDescriptor == "NEMA17_20" ? NEMA17_20 :
    motorDescriptor == "NEMA17_27" ? NEMA17_27 :
    motorDescriptor == "NEMA17_34" ? NEMA17_34 :
    motorDescriptor == "NEMA17_40" ? NEMA17_40 :
    motorDescriptor == "NEMA17_48" ? NEMA17_47 :
    motorDescriptor == "NEMA17_60" ? NEMA17_60 :
    motorDescriptor == "NEMA17_61_KRAKEN" ? NEMA17_61_KRAKEN :
    motorDescriptor == "NEMA17_40L160" ? NEMA17_40L160 :
    motorDescriptor == "NEMA17_40L200" ? NEMA17_40L200 :
    motorDescriptor == "NEMA17_40L230" ? NEMA17_40L230 :
    motorDescriptor == "NEMA17_40L250" ? NEMA17_40L250 :
    motorDescriptor == "NEMA17_40L280" ? NEMA17_40L280 :
    motorDescriptor == "NEMA17_40L300" ? NEMA17_40L300 :
    motorDescriptor == "NEMA17_40L330" ? NEMA17_40L330 :
    motorDescriptor == "NEMA17_40L350" ? NEMA17_40L350 :
    motorDescriptor == "NEMA17_40L380" ? NEMA17_40L380 :
    motorDescriptor == "NEMA17_40L400" ? NEMA17_40L400 :
    motorDescriptor == "NEMA17_40L430" ? NEMA17_40L430 :
    motorDescriptor == "NEMA17_40L440" ? NEMA17_40L440 :
    motorDescriptor == "BLDC4250" ? BLDC4250 :
    undef;
