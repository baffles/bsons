//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ONSShockTank_BS extends ONSShockTank;


var() float tl,ts;


// Locked differentials

simulated function Tick( float Delta )
{
  local int i;
  tl = 0.0;
  ts = 0.0;
  Super.Tick( Delta );

  for(i=0;i<Wheels.Length;i++) {
      tl += Wheels[i].SpinVel;
      ts += Wheels[i].SlipVel;
  }
  tl = tl/Wheels.Length;
  ts = ts/Wheels.Length;
  if (ts > 35.0) ts = 35;
  for(i=0;i<Wheels.Length;i++) {
     Wheels[i].SpinVel = tl;
     Wheels[i].SlipVel = ts;
  }

}


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

  if (EngineRPM > 2700)
  {
    B.SetDrawColor(255,0,0,0);
  }
  B.SetPos(B.ClipX * 0.3, B.ClipY * 0.9);
  B.DrawText("RPMs: " $ EngineRPM);

  //resetting default HUD color as green
  B.SetDrawColor(0,255,0,0);

  if (CarMPH > 10)
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
     TPCamDistance=775.000000
}
