//=============================================================================
// Http://ut2004.BSsoft.com
// Created: 11-06-04
// BAF
// Manta Vehicle Onslaught
//=============================================================================
class ONSHoverBike_BS extends ONSHoverBike;

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

	if (HoverMPH > 55)
	{
		B.SetDrawColor(255,0,0,0);
	}

	B.SetPos(B.ClipX * 0.425, B.ClipY * 0.9);
	B.DrawText("MPH: " $ HoverMPH);
}

defaultproperties
{
     JumpDelay=2.000000
     DriverWeapons(0)=(WeaponClass=Class'bsons.ONSHoverBikePlasmaGun_BS')
     EntryRadius=200.000000
     TPCamDistance=1100.000000
     ObjectiveGetOutDist=130.000000
     HealthMax=250.000000
     Health=250
}
