class ONSArtilleryCannon_BS extends ONSArtilleryCannon;

function Projectile SpawnProjectile(class<Projectile> ProjClass, bool bAltFire)
{
    local Projectile P;
    local vector StartLocation, HitLocation, HitNormal, Extent, TargetLoc;
    local ONSIncomingShellSound ShellSoundMarker;
    local Controller C;
	local bool bFailed;

    for ( C=Level.ControllerList; C!=None; C=C.nextController )
		if ( PlayerController(C)!=None )
			PlayerController(C).ClientPlaySound(sound'DistantBooms.DistantSPMA',true,1);

	if ( AIController(Instigator.Controller) != None )
	{
		if ( Instigator.Controller.Target == None )
		{
			if ( Instigator.Controller.Enemy != None )
				TargetLoc = Instigator.Controller.Enemy.Location;
			else
				TargetLoc = Instigator.Controller.FocalPoint;
		}
		else
			TargetLoc = Instigator.Controller.Target.Location;

		if ( !bAltFire && ((MortarCamera == None) || MortarCamera.bShotDown)
			&& ((VSize(TargetLoc - WeaponFireLocation) > 4000) || !Instigator.Controller.LineOfSightTo(Instigator.Controller.Target)) )
		{
			ProjClass = AltFireProjectileClass;
			bAltFire = true;
		}
	}
    if (bDoOffsetTrace)
    {
       	Extent = ProjClass.default.CollisionRadius * vect(1,1,0);
        Extent.Z = ProjClass.default.CollisionHeight;
        if (!Owner.TraceThisActor(HitLocation, HitNormal, WeaponFireLocation, WeaponFireLocation + vector(WeaponFireRotation) * (Owner.CollisionRadius * 1.5), Extent))
            StartLocation = HitLocation;
		else
			StartLocation = WeaponFireLocation + vector(WeaponFireRotation) * (ProjClass.default.CollisionRadius * 1.1);
    }
    else
    	StartLocation = WeaponFireLocation;

    P = spawn(ProjClass, self, , StartLocation, WeaponFireRotation);

    if (P != None)
    {
 		if ( AIController(Instigator.Controller) == None )
		{
			P.Velocity = Vector(WeaponFireRotation) * P.Speed;
		}
		else
		{
			if ( P.IsA('ONSMortarCamera') )
			{
				P.Velocity = SetMuzzleVelocity(StartLocation, TargetLoc,0.25);
				ONSMortarCamera(P).TargetZ = TargetLoc.Z;
			}
			else
				P.Velocity = SetMuzzleVelocity(StartLocation, TargetLoc,0.5);
			WeaponFireRotation = Rotator(P.Velocity);
			ONSArtillery(Owner).bAltFocalPoint = true;
			ONSArtillery(Owner).AltFocalPoint = StartLocation + P.Velocity;
		}
		if ( !P.IsA('ONSMortarCamera') )
        {
           if (MortarCamera != None)
            {
				if ( AIController(Instigator.Controller) == None )
				{
					MortarSpeed = FClamp(WeaponCharge * (MaxSpeed - MinSpeed) + MinSpeed, MinSpeed, MaxSpeed);
					ONSMortarShell(P).Velocity = Normal(P.Velocity) * MortarSpeed;
				}
				ONSMortarShell(P).StartTimer(3.0 + (WeaponCharge * 2.5));
                ShellSoundMarker = spawn(class'ONSIncomingShellSound',,, PredictedTargetLocation + vect(0,0,400));
                ShellSoundMarker.StartTimer(PredicatedTimeToImpact);
            }
			//else
			//	P.LifeSpan = 2.0;
        }

        FlashMuzzleFlash();

        // Play firing noise
        if (bAltFire)
        {
            if (bAmbientAltFireSound)
                AmbientSound = AltFireSoundClass;
            else
                PlayOwnedSound(AltFireSoundClass, SLOT_None, FireSoundVolume/255.0,, AltFireSoundRadius,, false);
        }
        else
        {
            if (bAmbientFireSound)
                AmbientSound = FireSoundClass;
            else
                PlayOwnedSound(FireSoundClass, SLOT_None, FireSoundVolume/255.0,, FireSoundRadius,, false);
        }

        if (ONSMortarCamera(P) != None)
        {
			CameraAttempts = 0;
			LastCameraLaunch = Level.TimeSeconds;
            MortarCamera = ONSMortarCamera(P);
            if (ONSArtillery(Owner) != None)
                ONSArtillery(Owner).MortarCamera = MortarCamera;
        }
        else
            MortarShell = ONSMortarShell(P);
    }
	else if ( AIController(Instigator.Controller) != None )
	{
		bFailed = ONSMortarCamera(P) == None;
		if ( !bFailed )
		{
			// allow 2 tries
			CameraAttempts++;
			bFailed = ( CameraAttempts > 1 );
		}

		if ( bFailed )
		{
			CameraAttempts = 0;
			LastCameraLaunch = Level.TimeSeconds;
			if ( MortarCamera != None )
			{
				MortarCamera.Destroy();
			}
		}
	}
    return P;
}


defaultproperties {
     WeaponCharge=0.000000
     GunnerAttachmentBone="BigGunBase"
     FireInterval=0.400000
     AltFireInterval=0.400000
     ProjectileClass=Class'ONSMortarShell'
     AltFireProjectileClass=Class'ONSMortarShell'
     RotationsPerSecond=0.380000
}
