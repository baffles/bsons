//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ONSArtillery_BS extends ONSArtillery;


// Locked differentials

function PostBeginPlay() {
SetWheelsScale(1.65);
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

DefaultProperties
{
  TorqueCurve=(Points=((OutVal=22.000000),(InVal=200.000000,OutVal=23.000000),(InVal=1500.000000,OutVal=24.000000),(InVal=3500.000000)))
  ChassisTorqueScale=0.250000
  WheelLongFrictionScale=1.700000



    Begin Object Class=SVehicleWheel Name=RWheel6
         bPoweredWheel=True
         bHandbrakeWheel=True
         SteerType=VST_Steered
         BoneName="Wheel_Right01"
         BoneRollAxis=AXIS_Y
         BoneOffset=(X=-15.000000)
         WheelRadius=73.000000
         SupportBoneName="SuspensionRight01"
         SupportBoneAxis=AXIS_X
     End Object
     Wheels(0)=SVehicleWheel'ONSArtillery_BS.RWheel6'

     Begin Object Class=SVehicleWheel Name=LWheel6
         bPoweredWheel=True
         bHandbrakeWheel=True
         SteerType=VST_Steered
         BoneName="Wheel_Left01"
         BoneRollAxis=AXIS_Y
         BoneOffset=(X=15.000000)
         WheelRadius=73.000000
         SupportBoneName="SuspensionLeft01"
         SupportBoneAxis=AXIS_X
     End Object
     Wheels(1)=SVehicleWheel'ONSArtillery_BS.LWheel6'

    Begin Object Class=SVehicleWheel Name=RWheel4
         bPoweredWheel=True
         bHandbrakeWheel=True
         BoneName="Wheel_Right02"
         BoneRollAxis=AXIS_Y
         BoneOffset=(X=-30.000000)
         WheelRadius=73.000000
         SupportBoneName="SuspensionRight02"
         SupportBoneAxis=AXIS_X
     End Object
     Wheels(2)=SVehicleWheel'ONSArtillery_BS.RWheel4'

     Begin Object Class=SVehicleWheel Name=LWheel4
         bPoweredWheel=True
         bHandbrakeWheel=True
         BoneName="Wheel_Left02"
         BoneRollAxis=AXIS_Y
         BoneOffset=(X=30.000000)
         WheelRadius=73.000000
         SupportBoneName="SuspensionLeft02"
         SupportBoneAxis=AXIS_X
     End Object
     Wheels(3)=SVehicleWheel'ONSArtillery_BS.LWheel4'

     Begin Object Class=SVehicleWheel Name=RWheel5
         bPoweredWheel=True
         bHandbrakeWheel=True
         SteerType=VST_Inverted
         BoneName="Wheel_Right03"
         BoneRollAxis=AXIS_Y
         BoneOffset=(X=-30.000000)
         WheelRadius=73.000000
         SupportBoneName="SuspensionRight03"
         SupportBoneAxis=AXIS_X
     End Object
     Wheels(4)=SVehicleWheel'ONSArtillery_BS.RWheel5'

     Begin Object Class=SVehicleWheel Name=LWheel5
         bPoweredWheel=True
         bHandbrakeWheel=True
         SteerType=VST_Inverted
         BoneName="Wheel_Left03"
         BoneRollAxis=AXIS_Y
         BoneOffset=(X=30.000000)
         WheelRadius=73.000000
         SupportBoneName="SuspensionLeft03"
         SupportBoneAxis=AXIS_X
     End Object
     Wheels(5)=SVehicleWheel'ONSArtillery_BS.LWheel5'




}
