//=============================================================================
// Http://ut2004.BSsoft.com
// Created: 11-06-04
// BS
// Leviathon Onslaught Vehicle
//=============================================================================
class ONSMobileAssaultStation_BS extends ONSMobileAssaultStation;

simulated function DrawHUD(Canvas B)
{
	local PlayerController PC;

	PC = PlayerController(Controller);
	// Don't draw if we are dead, scoreboard is visible, etc
	if (!bAllowChargingJump || Health < 1 || PC == None || PC.myHUD == None || PC.MyHUD.bShowScoreboard)
	{
		return;
	}
	super.DrawHUD(B);
	B.SetDrawColor(0,255,0,0);
	B.Style = ERenderStyle.STY_Alpha;
	B.Font = PC.MyHUD.GetFontSizeIndex(B, -1);

	if (EngineRPM > 1800) {
		B.SetDrawColor(255,0,0,0);
	}
	B.SetPos(B.ClipX * 0.3, B.ClipY * 0.9);
	B.DrawText("RPMs: " $ EngineRPM);

	//resetting default HUD color as green
	B.SetDrawColor(0,255,0,0);

	if (CarMPH > 35)
	{
		B.SetDrawColor(255,0,0,0);
	}

	B.SetPos(B.ClipX * 0.485, B.ClipY * 0.9);
	B.DrawText("MPH: " $ CarMPH);

	//resetting default HUD color as green
	B.SetDrawColor(0,255,0,0);

	B.SetPos(B.ClipX * 0.625, B.ClipY * 0.9);
	B.DrawText("Gear: " $ Gear);
}

defaultproperties
{
    GearRatios(0)=-0.200000
    GearRatios(1)=0.200000
    GearRatios(2)=0.400000
    NumForwardGears=2
    HealthMax=10000.000000
    Health=10000
    PassengerWeapons(0)=(WeaponPawnClass=Class'ONSMASSideGunPawn_BS',WeaponBone="RightFrontgunAttach")
    PassengerWeapons(1)=(WeaponPawnClass=Class'ONSMASSideGunPawn_BS',WeaponBone="LeftFrontGunAttach")
    PassengerWeapons(2)=(WeaponPawnClass=Class'ONSMASSideGunPawn_BS',WeaponBone="RightRearGunAttach")
    PassengerWeapons(3)=(WeaponPawnClass=Class'ONSMASSideGunPawn_BS',WeaponBone="LeftRearGunAttach")
    Begin Object Class=KarmaParamsRBFull Name=KParams0_BS
         KInertiaTensor(0)=1.260000
         KInertiaTensor(3)=3.099998
         KInertiaTensor(5)=4.499996
         KLinearDamping=0.050000
         KAngularDamping=0.050000
         KStartEnabled=True
         bKNonSphericalInertia=True
         KMaxSpeed=6500.000000
         bHighDetailOnly=False
         bClientOnly=False
         bKDoubleTickRate=True
         bDestroyOnWorldPenetrate=True
         bDoSafetime=True
         KFriction=0.500000
         KImpactThreshold=500.000000
     End Object
     KParams=KarmaParamsRBFull'ONSMobileAssaultStation_BS.KParams0_BS'
}
