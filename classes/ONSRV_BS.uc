//=============================================================================
// Http://ut2004.BSsoft.com
// Created: 11-06-04
// BAF
// Scorpion Vehicle Onslaught
//=============================================================================
class ONSRV_BS extends ONSRV;

var int NOCharge;
var int NOChargeRate;
var int NOChargeMax;
var int MaxBoostMPH;
var int SpeedBoost;
var bool bBoosting;

function int LimitPitch(int pitch)
{
	return pitch;
}

simulated function DrawHUD(Canvas C)
{
	local PlayerController PC;

	PC = PlayerController(Controller);
	// Don't draw if we are dead, scoreboard is visible, etc
	if (Health < 1 || PC == None || PC.myHUD == None || PC.MyHUD.bShowScoreboard)
	{
		return;
	}
	super.DrawHUD(C);
	C.SetDrawColor(0,255,0,0);

	if (EngineRPM > 1600)
	{
		C.SetDrawColor(255,0,0,0);
	}

	C.Style = ERenderStyle.STY_Alpha;
	C.Font = PC.MyHUD.GetFontSizeIndex(C, -1);

	C.SetPos(C.ClipX * 0.3, C.ClipY * 0.9);
	C.DrawText("RPMs: " $ EngineRPM);

	//resetting default HUD color as green
	C.SetDrawColor(0,255,0,0);

	if (carMPH > 45)
	{
		C.SetDrawColor(255,0,0,0);
	}
	C.SetPos(C.ClipX * 0.485, C.ClipY * 0.9);
	C.DrawText("MPH: " $ CarMPH);

	//resetting default HUD color as green
	C.SetDrawColor(0,255,0,0);

	C.SetPos(C.ClipX * 0.625, C.ClipY * 0.9);
	C.DrawText("Gear: " $ Gear);

    C.SetPos(C.ClipX * 0.3, C.ClipY * 0.880);
/*	if(NOCharge < 2)
       C.SetDrawColor(255,0,0,0);
	C.DrawText("Nitrous Oxide Charge (percent): " $ ((NOCharge / NOChargeMax) * 100));
*/
    if(bBoosting)
    {
       C.SetDrawColor(255,0,0,0);
       C.DrawText("Nitrous Boost!");
    }
	C.SetDrawColor(0,255,0,0);
//	C.DrawLine(3, ((NOCharge / NOChargeMax) * 100));
}

function VehicleFire(bool bWasAltFire)
{
     if(bWasAltFire)
          bBoosting = true;
     Super.VehicleFire(bWasAltFire);
}
function VehicleCeaseFire(bool bWasAltFire)
{
    if (bWasAltFire)
    {
        bBoosting = false;
    }
    Super.VehicleCeaseFire(bWasAltFire);
}

simulated function KApplyForce(out vector Force, out vector Torque)
{
    Super.KApplyForce(Force, Torque);

    if (bBoosting == true) {
    /*  //   unfinished code
           if (CarMPH < MaxBoostMPH && bVehicleOnGround == true) {
           OldCarMPH = CarMPH;
           Force += vector(Rotation * CurBoost);
           //Force += vector(Rotation) * SpeedBoost;
           }
           OldCarMPH = CarMPH;
           */

           if (CarMPH < MaxBoostMPH /*&& bVehicleOnGround == true*/)
           {
               Force += vector(Rotation) * SpeedBoost;
           }
//           NOCharge -= 2;
        }
}

simulated function Tick(float Delta)
{
    Super.Tick(Delta);
    if(!bBoosting && NOCharge < NOChargeMax)
    {
        if(NOCharge + NOChargeRate > NOChargeMax)
            NOCharge = NOChargeMax;
        else
            NOCharge += NOChargeRate;
    }
    if(bBoosting && NOCharge <= 0)
        bBoosting = false;
//    Super.Tick(Delta);
}

defaultproperties
{
     NOCharge=100
     NOChargeRate=5
     NOChargeMax=100
     MaxBoostMPH=150
     SpeedBoost=270
     GearRatios(2)=0.600000
     GearRatios(3)=0.800000
     GearRatios(4)=0.990000
     TransRatio=0.550000
     ChangeUpPoint=1900.000000
     bDoStuntInfo=False
     DriverWeapons(0)=(WeaponClass=Class'bsons.ONSRVWebLauncher_BS')
     TPCamDistance=675.000000
     GroundSpeed=9000.000000
     HealthMax=700.000000
     Health=700
     bCanTeleport=True
     Begin Object Class=KarmaParamsRBFull Name=KParams1
         KInertiaTensor(0)=1.000000
         KInertiaTensor(3)=3.000000
         KInertiaTensor(5)=3.000000
         KCOMOffset=(X=-0.250000,Z=-0.400000)
         KLinearDamping=0.050000
         KAngularDamping=0.050000
         KStartEnabled=True
         bKNonSphericalInertia=True
         KMaxSpeed=65000.000000
         bHighDetailOnly=False
         bClientOnly=False
         bKDoubleTickRate=True
         bDestroyOnWorldPenetrate=True
         bDoSafetime=True
         KFriction=0.500000
         KImpactThreshold=700.000000
     End Object
     KParams=KarmaParamsRBFull'bsons.ONSRV_BS.KParams1'

}
