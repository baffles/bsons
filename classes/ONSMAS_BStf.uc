class ONSMAS_BStf extends ONSMobileAssaultStation;

var () float MaxTrans;
var () float MinTrans;
var () float PerCH;
var () float MaxRPM;
var () float MinRPM;
var () float ts,tl,tr;
var () float fl,fr,bl,br,frontr,backr,endfr,endbr, MaxAxle, MaxWheel;

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    SetWheelsScale(1.5);
}

simulated function Tick( float Delta )
{
    local float TCH;
    local int i;
    Super.Tick(Delta);
    if (EngineRPM < MinRPM && TransRatio > MinTrans)
        TransRatio -= PerCH;
    if (EngineRPM > MaxRPM && TransRatio < MaxTrans)
        TransRatio += PerCH;


   tr = 0.0;
   for (i=0;i<Wheels.Length;i++) {
       tr += Wheels[i].SpinVel;
   }
   if (tr > 0) {
   if ((Wheels[0].SpinVel+Wheels[1].SpinVel) > 0) fl = Wheels[0].SpinVel/(Wheels[0].SpinVel+Wheels[1].SpinVel);
   else fl = 0.0;
   if ((Wheels[0].SpinVel+Wheels[1].SpinVel) > 0) fr = Wheels[1].SpinVel/(Wheels[0].SpinVel+Wheels[1].SpinVel);
   else fr = 0.0;

   if ((Wheels[2].SpinVel+Wheels[3].SpinVel) > 0) bl = Wheels[2].SpinVel/(Wheels[2].SpinVel+Wheels[3].SpinVel);
   else bl = 0.0;
   if ((Wheels[2].SpinVel+Wheels[3].SpinVel) > 0) br = Wheels[3].SpinVel/(Wheels[2].SpinVel+Wheels[3].SpinVel);
   else br = 0.0;

   frontr = (Wheels[0].SpinVel + Wheels[1].SpinVel)/tr;
   backr = (Wheels[2].SpinVel + Wheels[3].SpinVel)/tr;

   if ((backr*100.0) < MaxAxle && (frontr*100.0) < MaxAxle) {
       endbr = tr*backr;
       endfr = tr*frontr;
   }
   else if ((frontr*100.0) > MaxAxle) {
       endfr = tr*(MaxAxle*0.010000);
       endbr = tr*((100.000000-MaxAxle)*0.010000);
   }
   else if ((backr*100.0) > MaxAxle) {
       endbr = tr*(MaxAxle*0.010000);
       endfr = tr*((100.000000-MaxAxle)*0.010000);
   }

   if ((fl*100.0) < MaxWheel && (fr*100.0) < MaxWheel) {
       fl = (fl)*endfr;
       fr = (fr)*endfr;
   }
   else if ((fl*100.0) > MaxWheel) {
   fl = (MaxWheel*0.010000)*endfr;
   fr = (((100.000000-MaxWheel)*0.010000)*endfr);
   }
   else if ((fr*100.0) > MaxWheel) {
   fr = (MaxWheel*0.010000)*endfr;
   fl = (((100.000000-MaxWheel)*0.010000)*endfr);
   }

   if ((bl*100.0) < MaxWheel && (br*100.0) < MaxWheel) {
       bl = (bl)*endbr;
       br = (br)*endbr;
   }
   else if ((bl*100.0) > MaxWheel) {
   bl = (MaxWheel*0.010000)*endbr;
   br = (((100.000000-MaxWheel)*0.010000)*endbr);
   }
   else if ((br*100.0) > MaxWheel) {
   br = (MaxWheel*0.010000)*endbr;
   bl = (((100.000000-MaxWheel)*0.010000)*endbr);
   }

   Wheels[0].SpinVel = fl;
   Wheels[1].SpinVel = fr;
   Wheels[2].SpinVel = bl;
   Wheels[3].SpinVel = br;

   }
}

simulated function DrawHUD(Canvas B)
{
	local PlayerController PC;

	PC = PlayerController(Controller);
	// Don't draw if we are dead, scoreboard is visible, etc
	if (Health < 1 || PC == None || PC.myHUD == None || PC.MyHUD.bShowScoreboard) {
		return;
          }
	super.DrawHUD(B);
        B.SetDrawColor(0,255,0,0);
	B.Style = ERenderStyle.STY_Alpha;
        B.Font = PC.MyHUD.GetFontSizeIndex(B, -1);

       B.SetPos(B.ClipX * 0.1, B.ClipY * 0.860);
       B.SetDrawColor(255,0,0,0);
       B.DrawText("A: " $ endfr $ " B: " $ endbr $ " " $ bl/(bl+br) $ " " $ br/(bl+br) $ " TR " $ tr $ " fr br " $ frontr $ " " $ backr $ " DAMNIT " $ Wheels[0].SpinVel $ " " $ Wheels[1].SpinVel);
}

defaultproperties
{
     MaxTrans=1.500000
     MinTrans=0.010000
     PerCH=0.010000
     MaxRPM=1600.000000
     MinRPM=1400.000000
     MaxAxle=60.000000
     MaxWheel=75.000000
     WheelPenOffset=0.160000
     WheelLongFrictionScale=2.300000
     WheelLatFrictionScale=3.700000
     ChassisTorqueScale=0.000000
     MaxSteerAngleCurve=(Points=((OutVal=25.000000),(InVal=0.000000,OutVal=11.000000),(InVal=0.000000,OutVal=11.000000)))
     GearRatios(0)=-0.850000
     GearRatios(1)=0.850000
     GearRatios(2)=0.850000
     GearRatios(3)=0.850000
     GearRatios(4)=0.850000
     IdleSound=Sound'ONSVehicleSounds-S.PRV.PRVEng01'
     Begin Object Class=SVehicleWheel Name=RightRearTIRe
         bPoweredWheel=True
         bHandbrakeWheel=True
         BoneName="RightRearTIRe"
         BoneRollAxis=AXIS_Y
         WheelRadius=148.500000
     End Object
     Wheels(0)=SVehicleWheel'bsons.ONSMAS_BStf.RightRearTIRe'

     Begin Object Class=SVehicleWheel Name=LeftRearTIRE
         bPoweredWheel=True
         bHandbrakeWheel=True
         BoneName="LeftRearTIRE"
         BoneRollAxis=AXIS_Y
         WheelRadius=148.500000
     End Object
     Wheels(1)=SVehicleWheel'bsons.ONSMAS_BStf.LeftRearTIRE'

     Begin Object Class=SVehicleWheel Name=RightFrontTIRE
         bPoweredWheel=True
         SteerType=VST_Steered
         BoneName="RightFrontTIRE"
         BoneRollAxis=AXIS_Y
         WheelRadius=148.500000
     End Object
     Wheels(2)=SVehicleWheel'bsons.ONSMAS_BStf.RightFrontTIRE'

     Begin Object Class=SVehicleWheel Name=LeftFrontTIRE
         bPoweredWheel=True
         SteerType=VST_Steered
         BoneName="LeftFrontTIRE"
         BoneRollAxis=AXIS_Y
         WheelRadius=148.500000
     End Object
     Wheels(3)=SVehicleWheel'bsons.ONSMAS_BStf.LeftFrontTIRE'

     TPCamDistance=780.000000
     Begin Object Class=KarmaParamsRBFull Name=KParamsX
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
     KParams=KarmaParamsRBFull'bsons.ONSMAS_BStf.KParamsX'

}
