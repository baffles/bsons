//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ONSBombDropper_BS extends ONSBombDropper;

#exec OBJ LOAD FILE=..\Animations\ONSWeapons-A.ukx

//state ProjectileFireMode
//{
//    function SpawnProjectile(class<Projectile> ProjClass)
//    {
//        local Projectile P;
//
//        P = spawn(ProjClass, self, , WeaponFireLocation, WeaponFireRotation);
//
//    	if (P != None)
//    	{
//            P.Velocity = Instigator.Velocity + (vect(0,0,-1000) << Owner.Rotation);
//
//            // Play firing noise
//            PlaySound(FireSoundClass, SLOT_None, FireSoundVolume/255.0,,,, false);
//        }
//    }
//}

defaultproperties
{
     bAimable=True
     ProjectileClass=Class'RedeemerProjectile_BS'
}
