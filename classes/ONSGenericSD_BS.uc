//=============================================================================
// Http://ut2004.BSsoft.com
// Created: 11-06-04
// BS
// Toilet Cart Onslaught Random Vehicle
//=============================================================================
class ONSGenericSD_BS extends ONSGenericSD;

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

	if (EngineRPM > 1800)
	{
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
     GearRatios(1)=0.300000
     TransRatio=0.950000
     ChangeUpPoint=2200.000000
     AirTurnTorque=55.000000
     GroundSpeed=2000.000000
     HealthMax=500.000000
     Health=500
     SoundVolume=175
}
