//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ONSArtillery_BS extends ONSArtillery;


// Locked differentials

function PostBeginPlay() {
//SetWheelsScale(1.65);
}
simulated function Tick( float Delta )
{
  local int i;
  local float tl,ts;
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
  if (Health < 1 || PC == None || PC.myHUD == None || PC.MyHUD.bShowScoreboard)
  {
    return;
  }
  super.DrawHUD(B);
  B.SetDrawColor(0,255,0,0);
  B.Style = ERenderStyle.STY_Alpha;
  B.Font = PC.MyHUD.GetFontSizeIndex(B, -1);

  if (EngineRPM > 2000)
  {
    B.SetDrawColor(255,0,0,0);
  }
  B.SetPos(B.ClipX * 0.3, B.ClipY * 0.9);
  B.DrawText("RPMs: " $ EngineRPM);

  //resetting default HUD color as green
  B.SetDrawColor(0,255,0,0);

  if (CarMPH > 30)
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
     WheelLongFrictionScale=1.700000
     ChassisTorqueScale=0.250000
     TorqueCurve=(Points=((OutVal=22.000000),(InVal=0.000000,OutVal=23.000000),(InVal=0.000000,OutVal=24.000000),(InVal=3500.000000)))
     TPCamDistance=875.000000
}
