//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ONSDualAttackCraft_BS extends ONSDualAttackCraft;

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

DefaultProperties
{
     HealthMax=2000.000000
     Health=2000
}
