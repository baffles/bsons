//-----------------------------------------------------------
//
//-----------------------------------------------------------
class BSONS_Interaction extends Interaction;

var int LastKey;
var bool suspchange;
var bool suspup;

/*Function Initialize()
{
    Log("Interaction Initialized");
}

function bool KeyEvent(EInputKey Key, EInputAction Action, FLOAT Delta )
{
    local string tmp;

    // if the zoom key that is currently being held is released, end the zoom
    if(Action == IST_Release && suspchange == true)
    {
        suspchange=false;
        return True;
        // a key has been pressed
    }
    else if (Action == IST_Press)
    {
     // big ugliness here, we use console commands to get the name of the numeric
         // key, and then the alias bound to that keyname
        tmp = ViewportOwner.Actor.ConsoleCommand("KEYNAME"@Key);
        tmp = ViewportOwner.Actor.ConsoleCommand("KEYBINDING"@tmp);
        // if it's one of our two aliases (which don't actually exist), set the zoom
        // direction, save the key that started the zoom, and eat the event
        if (tmp == "dsup")
        {
            suspchange=true;
            suspup=true;
            return True;
        }
        else if (tmp == "dsdown")
        {
            suspchange=true;
            suspup=false;
            return True;
        }
    }
    // this event doesn't matter to us, so we pass it on for further processing
    return False;
}

function bool KeyType( EInputKey Key, optional string Unicode )
{
    if (bIgnoreKeys)
        return true;

    if( Key>=0x20 )
    {
        if( Unicode != "" )
            TypedStr = TypedStr $ Unicode;
        else
            TypedStr = TypedStr $ Chr(Key);
           return( true );
    }
}

function bool KeyEvent(EInputKey Key, EInputAction Action, FLOAT Delta )
{
    if ((Action == IST_Press) && (Key == IK_PageUp))
        bDrawEnemy = True;
    if ((Action == IST_Release) && (Key == IK_PageUp))
        bDrawEnemy = False;

    if ((Action == IST_Press) && (Key == IK_PageDown))
        bDrawFriendly = True;
    if ((Action == IST_Release) && (Key == IK_PageDown))
        bDrawFriendly = False;

    return false;
}

simulated function PostRender( canvas Canvas )
{
    local Pawn P;
    local vector CameraLocation, dir, ScreenLocation;
    local rotator CameraRotation;
    local float dist, draw_scale;

        foreach ViewportOwner.Actor.DynamicActors(class'Pawn', P)
            {
            if (ViewportOwner.Actor.Pawn == None || P == None)
                Return;

            //A trace to tell if you can see this thing
            If ((Canvas.Viewport.Actor.FastTrace(P.Location, ViewportOwner.Actor.Pawn.Location)) && (P != ViewportOwner.Actor.Pawn) && (P.PlayerReplicationInfo != None) && (P.Health > 0))
                {
                //Convert 3d location to 2d for display on the Canvas
                ScreenLocation = WorldToScreen(P.location);
                Canvas.GetCameraLocation(CameraLocation, CameraRotation);
                dir = P.Location - CameraLocation;
                dist = VSize(dir); //Distance between me and them

                if (dir dot vector(CameraRotation) > 0)
                    {
                    draw_scale = 512 / dist; //Calculate the drawscale, 512 is the "1:1" distance.
                    //Set drawing params
                    Canvas.SetPos(ScreenLocation.X - (32 * draw_scale), ScreenLocation.Y - (32 * draw_scale));
                    Canvas.Style = 3;
                    Canvas.SetDrawColor(255,255,255);
                    if (bDrawEnemy) //If PageUp is depressed (bDrawEnemy is true), see if the pawn is an enemy, if so, draw him!
                        if ((P.PlayerReplicationInfo.Team.TeamIndex != ViewportOwner.Actor.Pawn.PlayerReplicationInfo.Team.TeamIndex) || (!GRI.bTeamGame))
                            Canvas.DrawIcon(texture'red', draw_scale);
                    if (bDrawFriendly) //If PageDown is depressed (bDrawFriendly is true), see if the pawn is an friendly, if so, draw him!
                        if (P.PlayerReplicationInfo.Team.TeamIndex == ViewportOwner.Actor.Pawn.PlayerReplicationInfo.Team.TeamIndex)
                            Canvas.DrawIcon(texture'green', draw_scale);
                    }
                }
            }
        }
}
*/

defaultproperties
{
     bVisible=True
}
