//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ONSPRV_BSa extends ONSPRV_BS;



simulated function KApplyForce(out vector Force, out vector Torque) {
/*
local vector psss;
local vector psx;
*/
Super(ONSPRV).KApplyForce(Force, Torque);
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

if (bJet == true) {
Wheels[0].SpinVel = 300;
Wheels[1].SpinVel = 300;
}
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


simulated function Tick( float Delta )
{
  local int i;
  tl = 0.0;
  ts = 0.0;
  expow = 0.0;
  Super(ONSPRV).Tick( Delta );

  Wheels[0].TireLoad += 100.0;
  Wheels[1].TireLoad += 100.0;
  //Wheels[0].SuspensionPosition += 10.0;
  //Wheels[1].SuspensionPosition += 10.0;

  for(i=0;i<Wheels.Length;i++) {
      tl += Wheels[i].SpinVel;
      ts += Wheels[i].SlipVel;
  }


    tl = tl/(Wheels.Length);
    ts = ts/(Wheels.Length);

  if (bWeaponIsAltFiring) {
    /*if (ts > 35.0)
    {
       ts = 35.0;
    }*/
    for(i=0;i<Wheels.Length;i++) {
           Wheels[i].SpinVel = tl;
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

defaultproperties
{
}
