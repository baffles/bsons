class ONSShockTankCannon_BSa extends ONSlaughtBP.ONSShockTankCannon;

var float MaxLockRange, LockAim;

function Projectile SpawnProjectileX(class<Projectile> ProjClass, bool bAltFire, Controller Q)
{
    local Projectile A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P;
    local ONSWeaponPawn WeaponPawn;
    local vector StartLocation, HitLocation, HitNormal, Extent;

    if (bDoOffsetTrace)
    {
       	Extent = ProjClass.default.CollisionRadius * vect(1,1,0);
        Extent.Z = ProjClass.default.CollisionHeight;
       	WeaponPawn = ONSWeaponPawn(Owner);
    	if (WeaponPawn != None && WeaponPawn.VehicleBase != None)
    	{
    		if (!WeaponPawn.VehicleBase.TraceThisActor(HitLocation, HitNormal, WeaponFireLocation, WeaponFireLocation + vector(WeaponFireRotation) * (WeaponPawn.VehicleBase.CollisionRadius * 1.5), Extent))
			StartLocation = HitLocation;
		else
			StartLocation = WeaponFireLocation + vector(WeaponFireRotation) * (ProjClass.default.CollisionRadius * 1.1);
	}
	else
	{
		if (!Owner.TraceThisActor(HitLocation, HitNormal, WeaponFireLocation, WeaponFireLocation + vector(WeaponFireRotation) * (Owner.CollisionRadius * 1.5), Extent))
			StartLocation = HitLocation;
		else
			StartLocation = WeaponFireLocation + vector(WeaponFireRotation) * (ProjClass.default.CollisionRadius * 1.1);
	}
    }
    else
    	StartLocation = WeaponFireLocation;

    A = spawn(ProjClass, self, , StartLocation+vect(-75,-75,0), WeaponFireRotation);
    LockOn(Q, ONSMASRocketProjectile_BS(A));
    /*
    B = spawn(ProjClass, self, , StartLocation+vect(-25,-75,0), WeaponFireRotation);
    LockOn(Q, ONSMASRocketProjectile_BS(B));
    C = spawn(ProjClass, self, , StartLocation+vect(25,-75,0), WeaponFireRotation);
    LockOn(Q, ONSMASRocketProjectile_BS(C));
    D = spawn(ProjClass, self, , StartLocation+vect(75,-75,0), WeaponFireRotation);
    LockOn(Q, ONSMASRocketProjectile_BS(D));
    E = spawn(ProjClass, self, , StartLocation+vect(-75,-25,0), WeaponFireRotation);
    LockOn(Q, ONSMASRocketProjectile_BS(E));
    F = spawn(ProjClass, self, , StartLocation+vect(-25,-25,0), WeaponFireRotation);
    LockOn(Q, ONSMASRocketProjectile_BS(F));
    G = spawn(ProjClass, self, , StartLocation+vect(25,-25,0), WeaponFireRotation);
    LockOn(Q, ONSMASRocketProjectile_BS(G));
    H = spawn(ProjClass, self, , StartLocation+vect(75,-25,0), WeaponFireRotation);
    LockOn(Q, ONSMASRocketProjectile_BS(H));
    I = spawn(ProjClass, self, , StartLocation+vect(-75,25,0), WeaponFireRotation);
    LockOn(Q, ONSMASRocketProjectile_BS(I));
    J = spawn(ProjClass, self, , StartLocation+vect(-25,25,0), WeaponFireRotation);
    LockOn(Q, ONSMASRocketProjectile_BS(J));
    K = spawn(ProjClass, self, , StartLocation+vect(25,25,0), WeaponFireRotation);
    LockOn(Q, ONSMASRocketProjectile_BS(K));
    L = spawn(ProjClass, self, , StartLocation+vect(75,25,0), WeaponFireRotation);
    LockOn(Q, ONSMASRocketProjectile_BS(L));
    M = spawn(ProjClass, self, , StartLocation+vect(-75,75,0), WeaponFireRotation);
    LockOn(Q, ONSMASRocketProjectile_BS(M));
    N = spawn(ProjClass, self, , StartLocation+vect(-25,75,0), WeaponFireRotation);
    LockOn(Q, ONSMASRocketProjectile_BS(N));
    O = spawn(ProjClass, self, , StartLocation+vect(25,75,0), WeaponFireRotation);
    LockOn(Q, ONSMASRocketProjectile_BS(O));
    P = spawn(ProjClass, self, , StartLocation+vect(75,75,0), WeaponFireRotation);
    LockOn(Q, ONSMASRocketProjectile_BS(P));
    */


    if (A != None)
    {
        if (bInheritVelocity)
            A.Velocity = Instigator.Velocity;

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
    }

    return P;
}

function LockOn(Controller C, ONSMASRocketProjectile_BS R) {
		local float BestAim, BestDist;

		if (R != None)
		{
			if (AIController(C) != None)
				R.HomingTarget = C.Enemy;
			else
			{
				BestAim = LockAim;
				R.HomingTarget = C.PickTarget(BestAim, BestDist, vector(WeaponFireRotation), WeaponFireLocation, MaxLockRange);
			}
		}
}


state ProjectileFireMode
{
	function Fire(Controller C)
	{
		local ONSMASRocketProjectile R;
		local float BestAim, BestDist;

		R = ONSMASRocketProjectile(SpawnProjectileX(ProjectileClass, False, C));
		/*
		if (R != None)
		{
			if (AIController(C) != None)
				R.HomingTarget = C.Enemy;
			else
			{
				BestAim = LockAim;
				R.HomingTarget = C.PickTarget(BestAim, BestDist, vector(WeaponFireRotation), WeaponFireLocation, MaxLockRange);
			}
		}
		*/
	}
}

defaultproperties
{
     MaxLockRange=300000.000000
     LockAim=0.975000
     FireInterval=0.150000
     ProjectileClass=Class'bsons.ONSMASRocketProjectile_BS'
}
