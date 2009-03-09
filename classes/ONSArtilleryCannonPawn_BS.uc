class ONSArtilleryCannonPawn_BS extends ONSPRVRearGunPawn;


function bool KDriverLeave( bool bForceLeave ) {
Gun.CurrentAim = VehicleBase.Rotation;
return Super.KDriverLeave(bForceLeave);
}

defaultproperties
{
     GunClass=Class'bsons.ONSArtilleryCannon_BS'
     TPCamDistance=350.000000
}
