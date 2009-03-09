//=============================================================================
// Http://ut2004.BSsoft.com
// Created: 11-06-04
// BAF
// Scorpion Vehicle Onslaught
//=============================================================================
class ONSRV_BSbaf extends ONSRV;

var int NOCharge;
var int NOChargeRate;
var int NOChargeMax;
var int MaxBoostMPH;
var int SpeedBoost;
var bool bBoosting;
var bool awsOn;
var bool awsOnClient;
var InterpCurve AWS_4SteeringCurve;
var InterpCurve AWS_2SteeringCurve;
var InterpCurve AWS_4SteeringTorque;
var InterpCurve AWS_2SteeringTorque;

replication
{
    reliable if (bNetDirty && Role == ROLE_AUTHORITY)
        awsOnClient;
}

function int LimitPitch(int pitch)
{
	return pitch;
}

simulated function SetupSteering()
{
   local int i;

   if(awsOn)
    {
        MaxSteerAngleCurve=AWS_4SteeringCurve;
        wheels[0].SteerType = VST_Inverted;
        wheels[1].SteerType = VST_Inverted;
        TransRatio = default.TransRatio * 0.8;
        TorqueCurve = AWS_4SteeringTorque;

        /*for(i=0; i < Wheels.Length; i++)
        {
            Wheels[i].LongSlip = default.Wheels[i].LongSlip * 0.5;
            Wheels[i].LatSlip = default.Wheels[i].LongSlip * 0.5;
            Wheels[i].LatFriction = default.Wheels[i].LongSlip * 1.5;
            Wheels[i].LongFriction = default.Wheels[i].LongSlip * 1.5;
        }*/
    }
    else
    {
        MaxSteerAngleCurve=AWS_2SteeringCurve;
        wheels[0].SteerType = VST_Fixed;
        wheels[1].SteerType = VST_Fixed;
        TransRatio = default.TransRatio * 1.25;
        TorqueCurve = AWS_2SteeringTorque;

        /*for(i=0; i < Wheels.Length; i++)
        {
            Wheels[i].LongSlip = default.Wheels[i].LongSlip;
            Wheels[i].LatSlip = default.Wheels[i].LongSlip;
            Wheels[i].LatFriction = default.Wheels[i].LongSlip;
            Wheels[i].LongFriction = default.Wheels[i].LongSlip;
        }*/
    }
}

event Created()
{
    SetupSteering();
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

//	C.SetPos(C.ClipX * 0.485, C.ClipY * 0.6);
    C.SetPos(C.ClipX * 0.3, C.ClipY * 0.880);
    if(awsOn)
	{
	    c.SetDrawColor(255, 255, 0, 0);
	    c.DrawText("AWS: ON (Low Speed, High Torque)");
	}
	else
	{
	    //c.SetDrawColor(255, 0, 0, 0);
	    c.SetDrawColor(0, 255, 0, 0);
	    c.DrawText("AWS: OFF (High Speed, Low Torque)");
	}

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
     {
//          bBoosting = true;
          if(Role == ROLE_Authority)
          {
              awsOn = !awsOn;
              awsOnClient = awsOn;
              SetupSteering();
          }
     }
     else
     {
//          EjectDriver();
//          Health = 0   ;
super.VehicleFire(false);
//          super.VehicleFire(true);
     }
//     Super.VehicleFire(bWasAltFire);
}
function VehicleCeaseFire(bool bWasAltFire)
{
    if (bWasAltFire)
    {
//        bBoosting = false;
    }
    else
        super.VehicleCeaseFire(false);
//    Super.VehicleCeaseFire(bWasAltFire);
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
    if(!bBoosting && NOCharge < NOChargeMax)
    {
        if(NOCharge + NOChargeRate > NOChargeMax)
            NOCharge = NOChargeMax;
        else
            NOCharge += NOChargeRate;
    }
    if(bBoosting && NOCharge <= 0)
        bBoosting = false;

    if(awsOn != awsOnClient && Role < ROLE_Authority)
    {
         awsOn = awsOnClient;
         SetupSteering();
    }

    Super.Tick(Delta);
}

defaultproperties
{
//     TorqueCurve=(Points=((OutVal=9.000000),(InVal=200.000000,OutVal=10.000000),(InVal=1500.000000,OutVal=11.000000),(InVal=2800.000000,OutVal=15.000000),(InVal=5800.000000)))
     AWS_4SteeringTorque=(Points=((OutVal=9.000000),(InVal=200.000000,OutVal=10.000000),(InVal=1500.000000,OutVal=11.000000),(InVal=2800.000000,OutVal=13.000000),(InVal=5800.000000)))
     AWS_2SteeringTorque=(Points=((OutVal=18.000000),(InVal=200.000000,OutVal=16.000000),(InVal=1500.000000,OutVal=14.000000),(InVal=2800.000000,OutVal=15.000000),(InVal=5800.000000)))
     GearRatios(0)=-0.400000
     GearRatios(1)=0.200000
     GearRatios(2)=0.450000
     GearRatios(3)=0.8500000
     GearRatios(4)=1.260000

     TransRatio=0.250000
     ChangeUpPoint=4000.000000
     ChangeDownPoint=800.000000

     EngineInertia=0.050000
     IdleRPM=350.000000

     EngineBrakeFactor=0.000200
     EngineBrakeRPMScale=0.150000
//     IdleRPM=337.000000
     bDoStuntInfo=True
     DriverWeapons(0)=(WeaponClass=Class'ONSRVWebLauncher_BSbaf')
     GroundSpeed=9000.000000
     HealthMax=3000.000000
     Health=3000

     bCanTeleport=True
     NOCharge = 100;
     NOChargeRate = 5;
     NOChargeMax = 100;
     MaxBoostMPH = 180;
//     SpeedBoost = 270;
     SpeedBoost = 95;
     bBoosting = false;
     bAllowChargingJump = false;
     Begin Object Class=KarmaParamsRBFull Name=KParams1
         KInertiaTensor(0)=1.000000
         KInertiaTensor(3)=3.000000
         KInertiaTensor(5)=3.000000
         KCOMOffset=(X=-0.250000,Z=-0.400000)
         KLinearDamping=0.050000
         KAngularDamping=0.050000
         KStartEnabled=True
         bKNonSphericalInertia=True
         bHighDetailOnly=False
         bClientOnly=False
         bKDoubleTickRate=True
         bDestroyOnWorldPenetrate=True
         bDoSafetime=True
         KFriction=0.500000
         KImpactThreshold=700.000000
         KMaxSpeed=65000.000000
     End Object
     KParams=KarmaParamsRBFull'ONSRV_BS.KParams1'

     VehiclePositionString="in a Scorpion GTS HD"
     VehicleNameString="2009 Scorpion GTS HD w/ AWD and AWS"
     VehicleMass=5.000000

     StartUpSound=Sound'ONSVehicleSounds-S.PRV.PRVStart01'
     ShutDownSound=Sound'ONSVehicleSounds-S.PRV.PRVStop01'
     IdleSound=Sound'ONSVehicleSounds-S.PRV.PRVEng01'

     // 4 wheel steering

//     MaxSteerAngleCurve=(Points=((OutVal=18.000000),(InVal=1500.000000,OutVal=6.000000),(InVal=1000000000.000000,OutVal=6.000000)))
     AWS_4SteeringCurve=(Points=((OutVal=45.000000),(InVal=400.000000,OutVal=45.000000),(InVal=500.000000,OutVal=8.000000),(InVal=900.000000,OutVal=2.2500000),(InVal=2000.000000,OutVal=1.750000),(InVal=1000000000.000000,OutVal=1.500000)))
     AWS_2SteeringCurve=(Points=((OutVal=25.000000),(InVal=1500.000000,OutVal=11.000000),(InVal=1000000000.000000,OutVal=11.000000)));
//     MaxSteerAngleCurve=AWS_4SteeringCurve
//     SteerSpeed=90.000000
     awsOn=true;
     awsOnClient=awsOn;
     SteerSpeed=300.000000

     Begin Object Class=SVehicleWheel Name=RRWheel
         bPoweredWheel=True
         SteerType=VST_Inverted
         bHandbrakeWheel=True
         BoneName="tire02"
         BoneRollAxis=AXIS_Y
         BoneOffset=(Y=7.000000)
         WheelRadius=24.000000
         SupportBoneName="RrearStrut"
         SupportBoneAxis=AXIS_X
     End Object
     Wheels(0)=SVehicleWheel'BSONS.ONSRV_BSbaf.RRWheel'

     Begin Object Class=SVehicleWheel Name=LRWheel
         bPoweredWheel=True
         SteerType=VST_Inverted
         bHandbrakeWheel=True
         BoneName="tire04"
         BoneRollAxis=AXIS_Y
         BoneOffset=(Y=-7.000000)
         WheelRadius=24.000000
         SupportBoneName="LrearStrut"
         SupportBoneAxis=AXIS_X
     End Object
     Wheels(1)=SVehicleWheel'BSONS.ONSRV_BSbaf.LRWheel'

     Begin Object Class=SVehicleWheel Name=RFWheel
         bPoweredWheel=True
         SteerType=VST_Steered
         BoneName="tire"
         BoneRollAxis=AXIS_Y
         BoneOffset=(Y=7.000000)
         WheelRadius=24.000000
         SupportBoneName="RFrontStrut"
         SupportBoneAxis=AXIS_X
     End Object
     Wheels(2)=SVehicleWheel'BSONS.ONSRV_BSbaf.RFWheel'

     Begin Object Class=SVehicleWheel Name=LFWheel
         bPoweredWheel=True
         SteerType=VST_Steered
         BoneName="tire03"
         BoneRollAxis=AXIS_Y
         BoneOffset=(Y=-7.000000)
         WheelRadius=24.000000
         SupportBoneName="LfrontStrut"
         SupportBoneAxis=AXIS_X
     End Object
     Wheels(3)=SVehicleWheel'BSONS.ONSRV_BSbaf.LFWheel'
}
