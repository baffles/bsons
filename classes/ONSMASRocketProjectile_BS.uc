class ONSMASRocketProjectile_BS extends ONSRocketProjectile;


var Actor HomingTarget;
var vector InitialDir;

//var Emitter SmokeTrailEffect;
//var Effects Corona;


simulated function PostBeginPlay()
{

	InitialDir = vector(Rotation);
	Velocity = InitialDir * Speed;


	SetTimer(0.1, true);

	Super.PostBeginPlay();
}


simulated function Timer()
{
	local float VelMag;
	local vector ForceDir;

	if (HomingTarget == None)
		return;

	ForceDir = Normal(HomingTarget.Location - Location);
	if (ForceDir dot InitialDir > 0)
	{
	    	// Do normal guidance to target.
	    	VelMag = VSize(Velocity);

	    	ForceDir = Normal(ForceDir * 9.75 * VelMag + Velocity);
		Velocity =  VelMag * ForceDir;
    		Acceleration = 5 * ForceDir;

	    	// Update rocket so it faces in the direction its going.
		SetRotation(rotator(Velocity));
	}
}

defaultproperties
{
     bFullVolume=False
     SoundVolume=26
}
