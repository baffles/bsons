//-----------------------------------------------------------
// Http://ut2004.BSsoft.com
// Created: 11-06-04
// BAF
// Raptor Vehicle Onslaught
//-----------------------------------------------------------

class ONSAttackCraftSpec_BS extends ONSAttackCraft placeable;

simulated function DrawHUD(Canvas B)
{
	local PlayerController PC;

	PC = PlayerController(Controller);
	//Don't draw if we are dead, scoreboard is visible, etc
	if (Health < 1 || PC == None || PC.myHUD == None || PC.MyHUD.bShowScoreboard)
	{
		return;
	}
	super.DrawHUD(B);
	B.SetDrawColor(0,255,0,0);

	B.Style = ERenderStyle.STY_Alpha;
	B.Font = PC.MyHUD.GetFontSizeIndex(B, -1);

	if (CopterMPH > 55)
	{
		B.SetDrawColor(255,0,0,0);
	}

	B.SetPos(B.ClipX * 0.425, B.ClipY * 0.9);
	B.DrawText("MPH: " $ CopterMPH);
}

defaultproperties
{
     DriverWeapons(0)=(WeaponClass=Class'ONSAttackCraftSpecGun_BS')
     //DriverWeapons(1)=(WeaponClass=Class'ONSAttackCraftGun_BS')
     //DriverWeapons(2)=(WeaponClass=Class'ONSAttackCraftGun_BS')
     //DriverWeapons(3)=(WeaponClass=Class'ONSAttackCraftGun_BS')
     //DriverWeapons(4)=(WeaponClass=Class'ONSAttackCraftGun_BS')
     //DriverWeapons(5)=(WeaponClass=Class'ONSAttackCraftGun_BS')
     VehiclePositionString="in a Valasa Raptor"
     VehicleNameString="Valasa Raptor"
     HealthMax=2000.000000
     Health=2000
}
