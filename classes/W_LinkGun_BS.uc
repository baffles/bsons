//-----------------------------------------------------------
//
//-----------------------------------------------------------
class W_LinkGun_BS extends LinkGun;

DefaultProperties
{
     FireModeClass(0)=Class'W_LinkAltFire_BS' // wtf? Epic must have
     FireModeClass(1)=Class'W_LinkFire_BS' // mixed up the 2 fire modes
                                              // it was reversed in their src
     PickupClass=Class'W_LinkGunPickup_BS'
     ItemName="BS Link Gun"
}
