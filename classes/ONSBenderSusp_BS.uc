class ONSBenderSusp_BS extends Onslaught.ONSPRV;

simulated function Tick(float Delta)
{
    Super.Tick(Delta);

    //Wheels[2].SuspensionOffset = -5.000000;
    //Wheels[3].SuspensionOffset = -5.000000;

}

defaultproperties
{
     WheelPenScale=4.500000
     WheelRestitution=0.050000
     VehicleMass=32.000000
}
