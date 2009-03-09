class HellCannon extends FlakCannon;

simulated function bool ConsumeAmmo(int Mode, float load, optional bool bAmountNeededIsMax)
{
    return true;
}

simulated function CheckOutOfAmmo()
{
}

defaultproperties
{
     FireModeClass(0)=Class'bsons.HellCannonFire'
     FireModeClass(1)=Class'bsons.HellAltFire'
     InventoryGroup=12
}
