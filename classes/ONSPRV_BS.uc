class ONSPRV_BS extends ONSPRV;


var() float MaxSuspension;
var() float MinSuspension;
var() float MinSpeedSuspension;
var() InterpCurve SpeedTorqueCurve;
var() InterpCurve RegularTorqueCurve;
var() InterpCurve SpeedSteerCurve;
var() InterpCurve RegularSteerCurve;
var() float RegularLatScale;
var() float SpeedLatScale;
var() float tl,ts;
var() float expow;
var() float RegTransRatio;
var() float HighTransRatio;
var() float HighChassisTorque;
var() float LowChassisTorque;

var() float RegWheelRadius;
var() float RegWheelScale;
var() float BigWheelScale;
var() float BigWheelRadius;

//var() float LastMinFR, LastMinFL, LastMinBR, LastMinBL;
//var() bool bPGFR, bPGFL, bPGBR, bPGBL;

var int NOCharge;
var int NOChargeRate;
var int NOChargeMax;
var int MaxBoostMPH;
var int SpeedBoost;
var bool bBoosting;


// Locked differentials and nitrous boost

function VehicleFire(bool bWasAltfire)
{
    if (bWasAltfire) bWeaponIsAltFiring = true;
    else bBoosting = true;
}
function VehicleCeaseFire(bool bWasAltFire)
{
    if (!bWasAltFire)
    {
        bBoosting = false;
    }
    Super.VehicleCeaseFire(bWasAltFire);
}


simulated function Tick( float Delta )
{
  local int i;
  //local float tw;
  tl = 0.0;
  ts = 0.0;
  //tw = 0.0;
  expow = 0.0;
  Super.Tick( Delta );

  for(i=0;i<Wheels.Length;i++) {
      tl += Wheels[i].SpinVel;
      ts += Wheels[i].SlipVel;
      /*
      if (Wheels[i].bWheelOnGround == false) {
         tw += 1.0;
      }
      */
  }
  /*
  if (tw < Wheels.Length) {
  tl = tl/(Wheels.Length-tw);
  ts = ts/(Wheels.Length-tw);
  }
  else {
    tl = tl/(Wheels.Length);
    ts = ts/(Wheels.Length);
  }
  */

    tl = tl/(Wheels.Length);
    ts = ts/(Wheels.Length);

  if (bWeaponIsAltFiring) {
    if (ts > 35.0)
    {
       //expow = ts*2.0;
       ts = 35.0;
    }
    for(i=0;i<Wheels.Length;i++) {
       //if (Wheels[i].bWheelOnGround) {
           Wheels[i].SpinVel = tl;
           Wheels[i].SlipVel = ts;
       //}
       //else {
       //    Wheels[i].SpinVel = 0.0;
       //}
    }
  }

  if(!bBoosting && NOCharge < NOChargeMax)
    {
        if(NOCharge + NOChargeRate > NOChargeMax)
            NOCharge = NOChargeMax;
        else
            NOCharge += NOChargeRate;
    }
    if(bBoosting && NOCharge <= 0)
        bBoosting = false;
}



simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    if (WheelSuspensionOffset >= MinSpeedSuspension) {
         ApplySpdVals(true);
    }
}

exec function dsup()
{
   ChangeSuspension(true);
}
exec function dsdown()
{
   ChangeSuspension(false);
}

function ChangeSuspension(bool bGoingUp)
{
  local int i;
  if (bGoingUp == false) {
    if (WheelSuspensionOffset+2.5 > MinSuspension) WheelSuspensionOffset = MinSuspension;
    else WheelSuspensionOffset += 2.5;
  }
  else {
    if (WheelSuspensionOffset-2.5 < MaxSuspension) WheelSuspensionOffset = MaxSuspension;
    else WheelSuspensionOffset -= 2.5;
  }

  if (WheelSuspensionOffset >= MinSpeedSuspension) {
    ApplySpdVals(true);
  }
  else {
    ApplySpdVals(false);
  }

  if (WheelSuspensionOffset <= -4.0) {
    ApplyHeightVals(true);
  }
  else {
    ApplyHeightVals(false);
  }

  if (WheelSuspensionOffset == MaxSuspension) {
    SetWheelsScale(BigWheelScale);
    for(i=0;i<Wheels.Length;i++) {
       Wheels[i].WheelRadius = BigWheelRadius;
    }
  }

  if (WheelSuspensionOffset > MaxSuspension) {
    SetWheelsScale(RegWheelScale);
    for(i=0;i<Wheels.Length;i++) {
       Wheels[i].WheelRadius = RegWheelRadius;
    }
  }

  SVehicleUpdateParams();
// special code below hehehe
// this code makes the rear end be lower than the front
// just what I needed to simulate a heavy ass artillery thing's weight
/*
Wheels[0].SuspensionOffset += 10.000000;
Wheels[1].SuspensionOffset += 10.000000;
*/

//Wheels[1].SuspensionOffset = 9.000000;
//Wheels[3].SuspensionOffset = 9.000000;

}

function ApplyHeightVals(bool bForHeight) {
    if (bForHeight) {
        ChassisTorqueScale = HighChassisTorque;
        TransRatio = HighTransRatio;
    }
    else {
        ChassisTorqueScale = LowChassisTorque;
        TransRatio = RegTransRatio;
    }
}

function ApplySpdVals(bool bForSpeed)
{
  if (bForSpeed == true) {
    TorqueCurve = SpeedTorqueCurve;
    MaxSteerAngleCurve = SpeedSteerCurve;
    WheelLatFrictionScale = SpeedLatScale;
  }
  else {
    TorqueCurve = RegularTorqueCurve;
    MaxSteerAngleCurve = RegularSteerCurve;
    WheelLatFrictionScale = RegularLatScale;
  }
}

simulated function DrawHUD(Canvas B)
{
	local PlayerController PC;

	PC = PlayerController(Controller);
	// Don't draw if we are dead, scoreboard is visible, etc
	if (Health < 1 || PC == None || PC.myHUD == None || PC.MyHUD.bShowScoreboard) {
		return;
          }
	super.DrawHUD(B);
        B.SetDrawColor(0,255,0,0);
	B.Style = ERenderStyle.STY_Alpha;
        B.Font = PC.MyHUD.GetFontSizeIndex(B, -1);

        if (EngineRPM > 1800) {
        B.SetDrawColor(255,0,0,0);            }
	B.SetPos(B.ClipX * 0.3, B.ClipY * 0.9);
        B.DrawText("RPMs: " $ EngineRPM);

        //resetting default HUD color as green
        B.SetDrawColor(0,255,0,0);

        if (CarMPH > 35) {
        B.SetDrawColor(255,0,0,0);    }

        B.SetPos(B.ClipX * 0.485, B.ClipY * 0.9);
	B.DrawText("MPH: " $ CarMPH);
	//B.SetPos(B.ClipX * 0.485, B.ClipY * 1.9);
    //B.DrawText("UnrealSpeed: " $ );
    B.SetPos(B.ClipX * 0.3, B.ClipY * 0.880);
    if (WheelSuspensionOffset < MinSpeedSuspension) B.SetDrawColor(255,0,0,0);
    else B.SetDrawColor(0,255,0,0);
    B.DrawText("Suspension: " $ WheelSuspensionOffset);

    B.SetPos(B.ClipX * 0.6, B.ClipY * 0.880);
    B.SetDrawColor(0,0,255,0);
    B.DrawText("Yaw: " $ Rotation.Yaw $ " Pitch: " $ Rotation.Pitch $ " Roll: " $ Rotation.Roll);

    B.SetPos(B.ClipX * 0.3, B.ClipY * 0.860);
    B.DrawText("SlipVel: " $ ts);
    B.SetPos(B.ClipX * 0.6, B.ClipY * 0.860);
    B.DrawText("SpinVel: " $ tl);

        //resetting default HUD color as green
        B.SetDrawColor(0,255,0,0);


	B.SetPos(B.ClipX * 0.625, B.ClipY * 0.9);
	B.DrawText("Gear: " $ Gear);

	if(bBoosting)
    {
       B.SetPos(B.ClipX * 0.1, B.ClipY * 0.860);
       B.SetDrawColor(255,0,0,0);
       B.DrawText("Nitrous Boost!");
    }
}


function KApplyForce(out vector Force, out vector Torque) {
/*
local vector psss;
local vector psx;
*/
Super.KApplyForce(Force, Torque);
//Force += vector(Rotation) * expow;
/*
psss = vector(Rotation);
//if (bVehicleOnGround) {

psx.Y = psss.X;
psx.X = psss.Y;
psx.Z = 0;
Torque += psx * 450.0000;
*/
//}

//Force = vect(0,0,0);

//Force += vect(0.0,1.0,0.0) * 150.000;

/*
psss = vector(Rotation);
psss.Z = 0.0;
psss.X = psss.Y;
psss.Y = vector(Rotation).X;
if (bVehicleOnGround) {
Torque += psss * 150.000;
}
*/
     if (bBoosting == true) {
    /*  //   unfinished code
           if (CarMPH < MaxBoostMPH && bVehicleOnGround == true) {
           OldCarMPH = CarMPH;
           Force += vector(Rotation * CurBoost);
           //Force += vector(Rotation) * SpeedBoost;
           }
           OldCarMPH = CarMPH;
           */

           if (CarMPH < MaxBoostMPH && bVehicleOnGround == true)
           {
               Force += vector(Rotation) * SpeedBoost;
           }
//           NOCharge -= 2;
        }
}



defaultproperties
{
 TorqueCurve=(Points=((OutVal=9.000000),(InVal=200.000000,OutVal=10.000000),(InVal=1500.000000,OutVal=11.000000),(InVal=3800.000000)))
 RegularTorqueCurve=(Points=((OutVal=9.000000),(InVal=200.000000,OutVal=10.000000),(InVal=1500.000000,OutVal=11.000000),(InVal=3800.000000)));
 //SpeedTorqueCurve=(Points=((OutVal=9.000000),(InVal=200.000000,OutVal=10.000000),(InVal=1500.000000,OutVal=11.000000),(InVal=3500.000000,Outval=12.000000),(InVal=5500.000000,OutVal=16.000000),(InVal=10000.000000)))
 SpeedTorqueCurve=(Points=((OutVal=12.000000),(InVal=200.000000,OutVal=13.000000),(InVal=1500.000000,OutVal=14.000000),(InVal=3500.000000,Outval=15.000000),(InVal=5500.000000,OutVal=19.000000),(InVal=10000.000000)))
 MaxSteerAngleCurve=(Points=((OutVal=25.000000),(InVal=1000.000000,OutVal=8.000000),(InVal=2200.000000,OutVal=1.300000),(InVal=2700.000000,OutVal=0.9000000),(InVal=1000000000.000000,OutVal=0.900000)))
 SpeedSteerCurve=(Points=((OutVal=25.000000),(InVal=1000.000000,OutVal=8.000000),(InVal=2200.000000,OutVal=6.00000),(InVal=2700.000000,OutVal=4.0000000),(InVal=1000000000.000000,OutVal=2.900000)))
 RegularSteerCurve=(Points=((OutVal=25.000000),(InVal=1000.000000,OutVal=8.000000),(InVal=2200.000000,OutVal=1.300000),(InVal=2700.000000,OutVal=0.9000000),(InVal=1000000000.000000,OutVal=0.900000)))

 RegTransRatio=0.110000
 HighTransRatio=0.02000
 HighChassisTorque=0.0
 LowChassisTorque=0.300000

 RegWheelRadius=34.0
 RegWheelScale=1.0
 BigWheelScale=1.5
 BigWheelRadius=51.0

 WheelLongFrictionScale=1.800000
 WheelLatFrictionScale=2.700000
 RegularLatScale=2.700000
 SpeedLatScale=3.000000
 VehicleMass=6.000000
 FlipTorque=500.000000
 WheelSuspensionOffset=9.000000
 MinSuspension=29.000000
 MinSpeedSuspension=9.000000
 MaxSuspension=-28.500000
 ChassisTorqueScale=0.300000
 WheelSuspensionTravel=15.000000
 ChangeUpPoint=3000.000000
 ChangeDownPoint=1500.000000
 PassengerWeapons(0)=(WeaponPawnClass=Class'ONSPRVSideGunPawn_BS',WeaponBone="Dummy01")
 PassengerWeapons(1)=(WeaponPawnClass=Class'ONSArtilleryCannonPawn_BS',WeaponBone="Dummy02")
     Begin Object Class=SVehicleWheel Name=SRRWheel
         SteerType=VST_Inverted
         bPoweredWheel=True
         bHandbrakeWheel=True
         BoneName="RightRearTIRe"
         BoneOffset=(X=-15.000000)
         WheelRadius=34.000000
         SupportBoneName="RightRearSTRUT"
     End Object
     Wheels(0)=SVehicleWheel'ONSPRV_BS.SRRWheel'


     Begin Object Class=SVehicleWheel Name=SLRWheel
         SteerType=VST_Inverted
         bPoweredWheel=True
         bHandbrakeWheel=True
         BoneName="LeftRearTIRE"
         BoneOffset=(X=15.000000)
         WheelRadius=34.000000
         SupportBoneName="LeftRearSTRUT"
     End Object
     Wheels(1)=SVehicleWheel'ONSPRV_BS.SLRWheel'


     VehiclePositionString="in a HellBender Denali"
     VehicleNameString="HellBender Denali"

     Begin Object Class=KarmaParamsRBFull Name=KParamsD
         KInertiaTensor(0)=1.000000
         KInertiaTensor(3)=3.000000
         KInertiaTensor(5)=3.500000
         KCOMOffset=(X=-0.300000,Z=-0.500000)
         KLinearDamping=0.050000
         KAngularDamping=0.050000
         KStartEnabled=True
         bKNonSphericalInertia=True
         bHighDetailOnly=False
         bClientOnly=False
         KMaxSpeed=25000.000000
         bKDoubleTickRate=True
         bDestroyOnWorldPenetrate=True
         bDoSafetime=True
         KFriction=0.500000
         KImpactThreshold=500.000000
         StayUprightStiffness=7000.000000
     End Object
     KParams=KarmaParamsRBFull'ONSPRV_BS.KParamsD'

     NOCharge = 100;
     NOChargeRate = 5;
     NOChargeMax = 100;
     MaxBoostMPH = 100;
     SpeedBoost = 250;
     bBoosting = false;
}
