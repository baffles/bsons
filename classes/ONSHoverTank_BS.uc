//=============================================================================
// Http://ut2004.BSsoft.com
// Created: 11-06-04
// BS
// Tank Vehicle Onslaught
//=============================================================================
class ONSHoverTank_BS extends ONSHoverTank;

simulated function DrawHUD(Canvas B)
{
	local PlayerController PC;

	PC = PlayerController(Controller);
	// Don't draw if we are dead, scoreboard is visible, etc
	if (Health < 1 || PC == None || PC.myHUD == None || PC.MyHUD.bShowScoreboard)
	{
		return;
	}
	super.DrawHUD(B);
	B.SetDrawColor(0,255,0,0);

	B.Style = ERenderStyle.STY_Alpha;
	B.Font = PC.MyHUD.GetFontSizeIndex(B, -1);

	if (BikeMPH > 21)
	{
		B.SetDrawColor(255,0,0,0);
	}

	B.SetPos(B.ClipX * 0.425, B.ClipY * 0.9);
	B.DrawText("MPH: " $ BikeMPH);
}

defaultproperties
{
     MaxThrust=150.000000
     DriverWeapons(0)=(WeaponClass=Class'ONSHoverTankCannon_BS')
     TPCamDistance=1200.000000
     GroundSpeed=900.000000
     HealthMax=1000.000000
     Health=1000
}
