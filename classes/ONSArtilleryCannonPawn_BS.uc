class ONSArtilleryCannonPawn_BS extends ONSPRVRearGunPawn;


function bool KDriverLeave( bool bForceLeave ) {
Gun.CurrentAim = VehicleBase.Rotation;
return Super.KDriverLeave(bForceLeave);
}


defaultproperties {
     CameraBone="REARgunTURRET"
     GunClass=Class'ONSArtilleryCannon_BS'
     bHasAltFire=False
}
