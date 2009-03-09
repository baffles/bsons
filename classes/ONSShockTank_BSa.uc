//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ONSShockTank_BSa extends ONSShockTank;


var() float tl,ts;
var() float MaxSuspension;
var() float MinSuspension;
var() bool bLockDif, bJet;
var() float RegTraction;


simulated function VehicleFire(bool bWasAltfire)
{
    if (bWasAltfire) {
    bWeaponIsAltFiring = true;
    bLockDif = true;
    }
    /*
    else {
    Wheels[1].SuspensionOffset = 30;
    Wheels[2].SuspensionOffset = 30;
    Wheels[5].SuspensionOffset = 30;
    Wheels[6].SuspensionOffset = 30;
    Wheels[0].SuspensionOffset -= 10;
    Wheels[3].SuspensionOffset -= 10;
    Wheels[4].SuspensionOffset -= 10;
    Wheels[7].SuspensionOffset -= 10;
    }
    */
}
simulated function VehicleCeaseFire(bool bWasAltFire)
{
    /*if (!bWasAltFire)
    {
        bJet = false;
    }*/
    if (bWasAltFire) bLockDif = false;
    Super.VehicleCeaseFire(bWasAltFire);
}

// Locked differentials

simulated function Tick( float Delta )
{
  local int i;
  tl = 0.0;
  ts = 0.0;
  Super.Tick( Delta );

  //Wheels[3].CurrentRotation = Wheels[2].CurrentRotation*1.5;
  //Wheels[7].CurrentRotation = Wheels[6].CurrentRotation*1.5;
  /*
  if (bJet) {
  for(i=0;i<Wheels.Length;i++) {
      Wheels[i].SpinVel = 15.0;
  }
  }
  */
  for(i=0;i<Wheels.Length;i++) {
      tl += Wheels[i].SpinVel;
      ts += Wheels[i].SlipVel;
  }
  tl = tl/Wheels.Length;
  ts = ts/Wheels.Length;
  //if (ts > 35.0) ts = 35;      \
  if (bLockDif) {
  for(i=0;i<Wheels.Length;i++) {
     Wheels[i].SpinVel = tl;
     //Wheels[i].SlipVel = ts;
  }
  }

}




simulated exec function rstrac() {
   WheelLongFrictionScale=RegTraction;
}

simulated exec function inctrac() {
   WheelLongFrictionScale += 0.11;
}

simulated exec function dectrac() {
   WheelLongFrictionScale -= 0.11;
}

simulated exec function dsup()
{
   ChangeSuspension(true);
}
simulated exec function dsdown()
{
   ChangeSuspension(false);
}
  /*
simulated function ApplyHeightVals(bool bForHeight) {
    if (bForHeight) {
        ChassisTorqueScale = HighChassisTorque;
        TransRatio = HighTransRatio;
    }
    else {
        ChassisTorqueScale = LowChassisTorque;
        TransRatio = RegTransRatio;
    }
} */
 /*
simulated function ApplySpdVals(bool bForSpeed)
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
*/


simulated function ChangeSuspension(bool bGoingUp)
{
  //local int i;
  if (bGoingUp == false) {
    if (WheelSuspensionOffset+2.5 > MinSuspension) WheelSuspensionOffset = MinSuspension;
    else WheelSuspensionOffset += 2.5;
  }
  else {
    if (WheelSuspensionOffset-2.5 < MaxSuspension) WheelSuspensionOffset = MaxSuspension;
    else WheelSuspensionOffset -= 2.5;
  }
  /*
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
  } */
  /*
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
   */
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


simulated function DrawHUD(Canvas B)
{
  local PlayerController PC;

  PC = PlayerController(Controller);
  // Don't draw if we are dead, scoreboard is visible, etc
  if (!bAllowChargingJump || Health < 1 || PC == None || PC.myHUD == None || PC.MyHUD.bShowScoreboard)
  {
    return;
  }
  Super(ONSWheeledCraft).DrawHUD(B);
  B.SetDrawColor(0,255,0,0);
  B.Style = ERenderStyle.STY_Alpha;
  B.Font = PC.MyHUD.GetFontSizeIndex(B, -1);

  if (EngineRPM > 2700)
  {
    B.SetDrawColor(255,0,0,0);
  }
  B.SetPos(B.ClipX * 0.3, B.ClipY * 0.9);
  B.DrawText("RPMs: " $ EngineRPM);

  //resetting default HUD color as green
  B.SetDrawColor(0,255,0,0);

  if (CarMPH > 10)
  {
    B.SetDrawColor(255,0,0,0);
  }

  B.SetPos(B.ClipX * 0.485, B.ClipY * 0.9);
  B.DrawText("MPH: " $ CarMPH);

  //resetting default HUD color as green
  B.SetDrawColor(0,255,0,0);

  B.SetPos(B.ClipX * 0.625, B.ClipY * 0.9);
  B.DrawText("R1 Adhesion: " $ Wheels[0].Adhesion);
}

defaultproperties
{
     MaxSuspension=-38.500000
     MinSuspension=39.000000
     RegTraction=2.000000
     WheelSuspensionOffset=-16.000000
     DriverWeapons(0)=(WeaponClass=Class'bsons.ONSShockTankCannon_BSa')
     TPCamDistance=775.000000
}
