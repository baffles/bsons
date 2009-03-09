class ONSRV_BSt extends ONSRV;

simulated function Tick(float Delta)
{
    local int a,b;
    Super.Tick(Delta);
    a = (Wheels[0].SlipVel + Wheels[1].SlipVel) / 2;
    b = (Wheels[2].SlipVel + Wheels[3].SlipVel) / 2;
//    Super.Tick(Delta);
}


simulated function DrawHUD(Canvas C)
{
	local PlayerController PC;
	local int a,b;

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

       C.SetDrawColor(255,0,0,0);
       C.DrawText("SpinVel: " $ (Wheels[3].SpinVel + Wheels[2].SpinVel)/2 $ " SlipVel: " $ (Wheels[3].SlipVel + Wheels[2].SlipVel)/2);
	C.SetDrawColor(0,255,0,0);
//	C.DrawLine(3, ((NOCharge / NOChargeMax) * 100));
}

defaultproperties
{
}
