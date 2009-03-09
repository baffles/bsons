class ONSPRV_BStf extends ONSPRV_BS;

var () float MaxTrans;
var () float MinTrans;
var () float PerCH;
var () float MaxRPM;
var () float MinRPM;


simulated function Tick( float Delta )
{
    local float TCH;
    Super.Tick(Delta);
    if (EngineRPM < MinRPM && TransRatio > MinTrans)
        TransRatio -= PerCH;
    if (EngineRPM > MaxRPM && TransRatio < MaxTrans)
        TransRatio += PerCH;
}

defaultproperties
{
     MaxTrans=1.500000
     MinTrans=0.020000
     PerCH=0.020000
     MaxRPM=5600.000000
     MinRPM=5400.000000
     ChassisTorqueScale=0.000000
     GearRatios(0)=-0.850000
     GearRatios(1)=0.850000
     GearRatios(2)=0.850000
     GearRatios(4)=0.850000
     TPCamDistance=775.000000
}
