//=============================================================================
// Http://ut2004.BSsoft.com
// Created: 11-06-04
// BS
// Main Mutator class
//=============================================================================
class BSONS extends Mutator;

var config float MaxForce;
var config float MaxSpin;
var config float JumpChargeTime;
var config float Health;
var config float HealthMax;
var int TankCounter;
var int MantaCounter;

// key binding stuff
var bool bAffectSpectators; // If this is set to true, an interaction will be created for spectators
var bool bAffectPlayers; // If this is set to true, an interaction will be created for players
var bool bHasInteraction;

var config int AutoDestroy, RegenPerSec;
var config float VehicleEjectMult;
var config float FallSpeedMult;
var config bool EnableBeserk, DoEjection, EnableRegen, UseBSVehics, UnlockVehics;
var localized string ADText, ADHelp, EBText, EBHelp, DoEjText, DoEjHelp, ERText, ERHelp, RPSText, RPSHelp, MultText, MultHelp, FallSpeedText, FallSpeedHelp, UBVText, UBVHelp, UVText, UVHelp;

// main onslaught stuff

event PreBeginPlay()
{
//	SetTimer(2.0,true);
    SetTimer(1.0, true);
	TankCounter = 0;
	MantaCounter = 0;
}

function PostBeginPlay()
{
	local ONSVehicleFactory Factory;
	local WeaponLocker WL;
	local int i;
	//local ONSPowerCore PC;

	if(default.UseBSVehics)
	{
		foreach AllActors( class 'ONSVehicleFactory', Factory )
		{
			// Use BS Scorpion
			if(Factory.VehicleClass == class'ONSRV')
			{
				Factory.VehicleClass = class'ONSRV_BS';
			}
			// Use BS Manta
			if(Factory.VehicleClass == class'ONSHoverBike')
			{
				Factory.VehicleClass = class'ONSHoverBike_BS';
			}
			// Use BS Hell bender
/*			if(Factory.VehicleClass == class'ONSPRV')
			{
				Factory.VehicleClass = class'ONSPRV_BS';
			}*/

  			// Use Denali Hellbender
            if(Factory.VehicleClass == class'ONSPRV')
			{
				Factory.VehicleClass = class'ONSPRV_BS';
			}
			// Use BS Tank
			if(Factory.VehicleClass == class'ONSHoverTank')
			{
				Factory.VehicleClass = class'ONSHoverTank_BS';
			}
			// Use BS Raptor
			if(Factory.VehicleClass == class'ONSAttackCraft')
			{
				Factory.VehicleClass = class'ONSAttackCraft_BS';
			}
			// Use BS Lavaiathen
			if(Factory.VehicleClass == class'ONSMobileAssaultStation')
			{
				Factory.VehicleClass = class'ONSMobileAssaultStation_BS';
			}
			// Use BS Ion Tank
			if(Factory.VehicleClass == class'ONSHoverTank_IonPlasma')
			{
				Factory.VehicleClass = class'ONSHoverTank_IonPlasma_BS';
			}
			// Use BS TC-1200
			if(Factory.VehicleClass == class'ONSGenericSD')
			{
				Factory.VehicleClass = class'ONSGenericSD_BS';
			}
			// Use BS Cicada
			if(Factory.VehicleClass == class'ONSDualAttackCraft')
			{
		        Factory.VehicleClass = class'ONSDualAttackCraft_BS';
            }
            // Use BS SPMA
            if(Factory.VehicleClass == class'ONSArtillery')
            {
                Factory.VehicleClass = class'ONSArtillery_BS';
            }
            // Use BS Shock Tank
            if(Factory.VehicleClass == class'ONSShockTank')
            {
                Factory.VehicleClass = class'ONSShockTank_BS';
            }
		}
	}
	Level.Game.bAllowVehicles = true;

    foreach AllActors(class'WeaponLocker', WL)
    {
        for(i = 0; i < WL.Weapons.Length; i++)
        {
            if(WL.Weapons[i].WeaponClass == class'LinkGun')
                WL.Weapons[i].WeaponClass = class'W_LinkGun_BS';
            if(WL.Weapons[i].WeaponClass == class'FlakCannon')
                WL.Weapons[i].WeaponClass = class'W_FlakCannon_BS';
            if(WL.Weapons[i].WeaponClass == class'ONSAVRiL')
                WL.Weapons[i].WeaponClass = class'W_ONSAVRiL_BS';
        }
    }

	Super.PostBeginPlay();
}

function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
	local ONSWheeledCraft     V;
	local ONSVehicle          HC;
	local ONSPowerNode        PN;
//	local WeaponLocker L ;
//    local int a ;

	//unlock all vehicles
	HC = ONSVehicle(Other);
	if(HC != none && default.UnlockVehics)
	{
		HC.default.bTeamLocked = false;
	}
	if(SVehicle(Other) != None && default.UnlockVehics)
	{
         Vehicle(Other).bTeamLocked = false;
    }
	// ejection stuff
	if(default.DoEjection)
	{
		if(Vehicle(Other) != None)
		{
			Vehicle(Other).bEjectDriver = true;
			Vehicle(Other).EjectMomentum *= VehicleEjectMult;
		}
	}

  V = ONSWheeledCraft(Other);
  /*
	if(V != None)
	{
		V.bAllowChargingJump = true;
		V.bAllowAirControl = true;

    // Jumping properties
    V.MaxJumpForce = 500000.000000;
		V.MaxJumpSpin = 150.000000;
		V.JumpChargeTime = 1;

		// Use BS HUD display
		V.bSpecialHUD = true;

		//V.bScriptedRise = true;

		// Colors for jump meter
		V.JumpMeterColor.R = 255;
		V.SpinMeterColor.B = 255;
	}*/

	PN = ONSPowerNode(Other);

	if(PN != none)
	{
		// Fast node construction and repair
		PN.ConstructionTime = 30;
		PN.LinkHealMult = 3;
	}

	// beserk
	if (default.EnableBeserk && Vehicle(Other) != None)
	{
		Vehicle(Other).Health *= 2;
		Vehicle(Other).HealthMax *= 2;
	}

	// new weapons
    if(xWeaponBase(Other) == class'ONSAVRiL')
    {
        xWeaponBase(Other).WeaponType = class'W_ONSAVRiL_BS';
    }
    else if(xWeaponBase(Other) == class'FlakCannon')
    {
        xWeaponBase(Other).WeaponType = class'W_FlakCannon_BS';
    }

	return true;
}


function DriverLeftVehicle(Vehicle V, Pawn P)
{
	//if(V.ParentFactory.VehicleClass != class'ASTurret_Minigun')
	//{
	if(!V.bDefensive)
	{
		V.Lifespan = default.AutoDestroy;
	}
	//}

	if( NextMutator != None )
	{
		NextMutator.DriverLeftVehicle(V, P);
	}
}

// Spawn a new vehicle when someone enters one
function DriverEnteredVehicle(Vehicle V, Pawn P)
{
	// ifsomeone gets back in the car within the 15 seconds do not detroy the car
	V.Lifespan = 0;

	//Make sure its not one of these vehicles, ifit is then don't respawn it until the original explodes
	//if((V.ParentFactory.VehicleClass != class'BSVeh.ONSHoverTank_BS') && (V.ParentFactory.VehicleClass != class'ONSMobileAssaultStation_BS') && (V.ParentFactory.VehicleClass != class'ONSHoverTank_IonPlasma') && (V.ParentFactory.VehicleClass != class'ASTurret_Minigun') && (V.ParentFactory.VehicleClass != class'ONSStationaryWeaponPawn'))
	//{
		//if(V.ParentFactory.VehicleClass != none)
		//{
			//V.ParentFactory.VehicleDestroyed(V);
			//V.ParentFactory = none;
		//}
	//}

	if(NextMutator != None)
	{
		NextMutator.DriverEnteredVehicle(V, P);
	}
}

// ejection + beserk stuff
function ModifyPlayer(Pawn Other)
{
	local xPawn x;
	x = xPawn(Other);

	if(x != None)
	{
		if (FallSpeedMult == 0)
			x.MaxFallSpeed = 99999999;
		else
			x.MaxFallSpeed *= FallSpeedMult;
	}

	if(default.EnableBeserk)
	{
         if (Other.ShieldStrength < 100)
		      Other.AddShieldStrength(100 - Other.ShieldStrength);
    }

	Super.ModifyPlayer(Other);
}

// regen stuff
function Timer()
{
     local Controller C;
     if(default.EnableRegen)
     {
          for(C = Level.ControllerList; C != None; C = C.NextController)
          {
               if(C.Pawn != None && C.Pawn.Health < C.Pawn.HealthMax)
               {
                    C.Pawn.Health = Min(C.Pawn.Health + default.RegenPerSec, C.Pawn.HealthMax);
               }
          }
     }
}

// config stuff
static function FillPlayInfo(PlayInfo PlayInfo)
{
	Super.FillPlayInfo(PlayInfo);

	PlayInfo.AddSetting(default.RulesGroup, "AutoDestroy", default.ADText, 0, 1, "Text", "3;0");
	PlayInfo.AddSetting(default.RulesGroup, "EnableBeserk", default.EBText, 0, 1, "Check", "");
	PlayInfo.AddSetting(default.RulesGroup, "EnableRegen", default.ERText, 0, 1, "Check", "");
	PlayInfo.AddSetting(default.RulesGroup, "RegenPerSec", default.RPSText, 0, 1, "Text", "3;0");
	PlayInfo.AddSetting(default.RulesGroup, "DoEjection", default.DoEjText, 0, 1, "Check", "");
	PlayInfo.AddSetting(default.RulesGroup, "VehicleEjectMult", default.MultText, 0, 1, "Text", "1;1:25");
	PlayInfo.AddSetting(default.RulesGroup, "FallSpeedMult", default.FallSpeedText, 0, 1, "Text", "1;0:10");
	PlayInfo.AddSetting(default.RulesGroup, "UseBSVehics", default.UBVText, 0, 1, "Check", "");
	PlayInfo.AddSetting(default.RulesGroup, "UnlockVehics", default.UVText, 0, 1, "Check", "");
}

static event string GetDescriptionText(string PropName)
{
	switch (PropName)
	{
		case "AutoDestroy": return default.ADHelp;
		case "EnableBeserk": return default.EBHelp;
		case "DoEjection": return default.DoEjHelp;
		case "EnableRegen": return default.ERHelp;
		case "RegenPerSec": return default.RPSHelp;
		case "VehicleEjectMult":	return default.MultHelp;
		case "FallSpeedMult":		return default.FallSpeedHelp;
		case "UBV": return default.UBVHelp;
	}
	return Super.GetDescriptionText(PropName);
}

// two beserk states
//auto state startup
//{
  //  	function tick(float deltatime)
	//    {
      //       local Weapon W;
        //     local Ammunition A;
		  //   local Vehicle V;
//
  //   		Level.GRI.WeaponBerserk = 3;
	//     	ForEach DynamicActors(class'Weapon', W)
	//	     	W.CheckSuperBerserk();
     //		ForEach DynamicActors(class'Vehicle', V)
	   //  		V.CheckSuperBerserk();
     	//	ForEach DynamicActors(class'Ammunition', A)
	     //		A.AddAmmo(1);
     	//	GotoState('BegunPlay');
//     	}

//}

//state BegunPlay
//{
  //	ignores tick;
//}

// default properties

simulated function Tick(float DeltaTime)
{
    local PlayerController PC;

    // If the player has an interaction already, exit function.
    if (bHasInteraction)
        Return;
    PC = Level.GetLocalPlayerController();

    // Run a check to see whether this mutator should create an interaction for the player
    if ( PC != None && ((PC.PlayerReplicationInfo.bIsSpectator && bAffectSpectators) || (bAffectPlayers && !PC.PlayerReplicationInfo.bIsSpectator)) )
    {
        PC.Player.InteractionMaster.AddInteraction("BSONS.BSONS_Interaction", PC.Player); // Create the interaction
        bHasInteraction = True; // Set the variable so this lot isn't called again
    }
}

defaultproperties
{
     EnableBeserk=false
     VehicleEjectMult=1.000000
     FallSpeedMult=1.000000
     RegenPerSec=5.000000
     DoEjection=True
     EnableRegen=True
     UseBSVehics=True
     UnlockVehics=True
     ADText="Autodestroy Vehicle (0=dont)"
     ADHelp="Time (in seconds) until a vehicle is destroyed after everyone gets out of it (0 = disable)"
     EBText="Enable Beserk Mode";
     EBHelp="Makes weapons insanely fast and powerful";
     DoEjText="Enable Ejection"
     DoEjHelp="Should automatic ejection be enabled?"
     RPSText="Health Regen Per Second"
     RPSHelp="How much health to recover per second (if regen is enabled)";
     ERText="Enable Health Regeneration";
     ERHelp="Should automatic health regeneration be enabled?";
     MultText="Eject Momentum Multiplier"
     MultHelp="Multiplier to increase the velocity of players when ejecting."
     FallSpeedText="Fall Speed Multiplier (0 = no fall damage)"
     FallSpeedHelp="Multiplier for the fall speed of players, set to 0 for no falling damage at all."
     UBVText="Use BS Vehicles"
     UBVHelp="Substitute regular vehicles with BS's Modified Vehicles."
     UVText="Unlock all vehicles"
     UVHelp="Unlock all vehicles on the map, so anybody can use any vehicle."
     bAddToServerPackages=True
     FriendlyName="BS Onslaught V0.5"
     Description="Onslaught, BS Style. Mutator Created by BAF and Sevalecan."

     bAffectSpectators=false
     bAffectPlayers=true
     RemoteRole=ROLE_SimulatedProxy
     bAlwaysRelevant=true
}
