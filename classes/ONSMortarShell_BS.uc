//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ONSMortarShell_BS extends ONSMortarShell;

defaultproperties
{
     ExplosionEffectClass=Class'OnslaughtBP.ONSArtilleryGroundExplosion'
     AirExplosionEffectClass=Class'Onslaught.ONSSmallVehicleExplosionEffect'
     Speed=4000.000000
     MaxSpeed=4000.000000
     Damage=250.000000
     DamageRadius=660.000000
     MomentumTransfer=575000.000000
     MyDamageType=Class'OnslaughtBP.DamTypeArtilleryShell'
     ExplosionDecal=Class'XEffects.ShockAltDecal'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'ONS-BPJW1.Meshes.LargeShell'
     CullDistance=10000.000000
     bNetTemporary=False
     Physics=PHYS_Falling
     AmbientSound=Sound'ONSBPSounds.Artillery.ShellAmbient'
     LifeSpan=8000.000000

}
