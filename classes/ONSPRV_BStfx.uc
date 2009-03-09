class ONSPRV_BStfx extends ONSPRV;

var () float MaxTrans;
var () float MinTrans;
var () float PerCH;
var () float MaxRPM;
var () float MinRPM;
var() float tl,ts;
var() float expow;
var() float ld,uld,suld;


simulated function Tick( float Delta )
{
    local float TCH;
    local int a,b,i,j,k;
    Super.Tick(Delta);
    if (EngineRPM < MinRPM && TransRatio > MinTrans)
        TransRatio -= PerCH;
    if (EngineRPM > MaxRPM && TransRatio < MaxTrans)
        TransRatio += PerCH;
    tl = 0;
    for(i=0;i<Wheels.Length;i++) {
      tl += Wheels[i].SpinVel;
    }

    tl = tl/(Wheels.Length);

    for(i=0;i<Wheels.Length;i++) {
           Wheels[i].SpinVel = tl;
    }

    if (Wheels[3].TireLoad >= 20.0)
       j = ld;
    else if (Wheels[3].TireLoad <= 10.0)
       j = suld;
    else
       j = uld;

    if (Wheels[2].TireLoad >= 20.0)
       k = ld;
    else if (Wheels[2].TireLoad <= 10.0)
       k = suld;
    else
       k = uld;

    Wheels[0].PenScale = k;
    Wheels[2].PenScale = k;
    Wheels[1].PenScale = j;
    Wheels[3].PenScale = j;

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
       C.DrawText("SpinVel: " $ (Wheels[3].SpinVel + Wheels[2].SpinVel)/2 $ " SlipVel: " $ (Wheels[3].SlipVel + Wheels[2].SlipVel)/2 $ " BRLoad: " $ Wheels[3].TireLoad $ " BLoad: " $ Wheels[2].TireLoad);
	C.SetDrawColor(0,255,0,0);
//	C.DrawLine(3, ((NOCharge / NOChargeMax) * 100));
}

defaultproperties
{
     MaxTrans=1.500000
     MinTrans=0.020000
     PerCH=0.020000
     MaxRPM=1750.000000
     MinRPM=1250.000000
     LD=2.500000
     uld=1.500000
     suld=0.500000
     ChassisTorqueScale=0.000000
     GearRatios(0)=-0.850000
     GearRatios(1)=0.850000
     GearRatios(2)=0.850000
     GearRatios(4)=0.850000
     TPCamDistance=975.000000
}
