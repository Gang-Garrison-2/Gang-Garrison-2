// creates game objects per the list in the entity data

// argument0: entity data

{

var currentPos, entityType, entityX, entityY, wordLength, DIVIDER, DIVREPLACEMENT;
DIVIDER = chr(10);
DIVREPLACEMENT = " ";

argument0+=DIVIDER;

currentPos = 1;

while(string_pos(DIVIDER, argument0) != 0) { // continue until there are no more entities left
  // grab the entity type
  wordLength = string_pos(DIVIDER, argument0) - currentPos;
  entityType = string_copy(argument0, currentPos, wordLength);
  argument0 = string_replace(argument0, DIVIDER, DIVREPLACEMENT);
  currentPos += wordLength + string_length(DIVREPLACEMENT);
  // grab the x coordinate
  wordLength = string_pos(DIVIDER, argument0) - currentPos;
  entityX = real(string_copy(argument0, currentPos, wordLength));
  argument0 = string_replace(argument0, DIVIDER, DIVREPLACEMENT);
  currentPos += wordLength + string_length(DIVREPLACEMENT);
  // grab the y coordinate
  wordLength = string_pos(DIVIDER, argument0) - currentPos;
  entityY = real(string_copy(argument0, currentPos, wordLength));
  argument0 = string_replace(argument0, DIVIDER, DIVREPLACEMENT);
  currentPos += wordLength + string_length(DIVREPLACEMENT);
  
  // This is where the magic happens:
  // Based on what type of entity we just parsed, we create
  // the corresponding game object.  If the particular entity
  // has extra parameters, we should read them here
  // (note: no entities have extra parameters so far, so there's
  // no standard or precedent for how that should happen.  Anyone
  // who implements that should document it clearly for
  // others)
  
  switch(entityType) {
    case "spawnroom":
      instance_create(entityX, entityY, SpawnRoom);
    break;
/*REMINDER: Get Leiche or Cspot to add 8 new spawn entities to Garrison Builder or 
 *get Garrison Builder source to try out for self. In GB, aesthetics are as follows:
 * 0=Runner, 1=Firebug, 2=Rocketman, 3=Overweight, 4=Detonator*/
    case "redspawn":
      instance_create(entityX, entityY, SpawnPointRed);
    break;
    case "redspawn1":
      instance_create(entityX, entityY, SpawnPointRed1);
    break;
    case "redspawn2":
      instance_create(entityX, entityY, SpawnPointRed2);
    break;
    case "redspawn3":
      instance_create(entityX, entityY, SpawnPointRed3);
    break;
    case "redspawn4":
      instance_create(entityX, entityY, SpawnPointRed4);
    break;
    case "bluespawn":
      instance_create(entityX, entityY, SpawnPointBlue);
    break;
    case "bluespawn1":
      instance_create(entityX, entityY, SpawnPointBlue1);
    break;
    case "bluespawn2":
      instance_create(entityX, entityY, SpawnPointBlue2);
    break;
    case "bluespawn3":
      instance_create(entityX, entityY, SpawnPointBlue3);
    break;
    case "bluespawn4":
      instance_create(entityX, entityY, SpawnPointBlue4);
    break;
    case "redintel":
      instance_create(entityX, entityY, IntelligenceBaseRed);
    break;
    case "blueintel":
      instance_create(entityX, entityY, IntelligenceBaseBlue);
    break;
    case "redteamgate":
      instance_create(entityX, entityY, RedTeamGate);
    break;
    case "blueteamgate":
      instance_create(entityX, entityY, BlueTeamGate);
    break;
    case "redteamgate2":
      instance_create(entityX, entityY, RedTeamGate2);
    break;
    case "blueteamgate2":
      instance_create(entityX, entityY, BlueTeamGate2);
    break;
    case "redintelgate":
      instance_create(entityX, entityY, RedIntelGate);
    break;
    case "blueintelgate":
      instance_create(entityX, entityY, BlueIntelGate);
    break;
    case "redintelgate2":
      instance_create(entityX, entityY, RedIntelGate2);
    break;
    case "blueintelgate2":
      instance_create(entityX, entityY, BlueIntelGate2);
    break;
    case "intelgatehorizontal":
      instance_create(entityX, entityY, IntelGateHorizontal);
    break;
    case "intelgatevertical":
      instance_create(entityX, entityY, IntelGateVertical);
    break;
    case "medCabinet":
      instance_create(entityX, entityY, HealingCabinet);
    break;
    case "killbox":
      instance_create(entityX, entityY, KillBox);
    break;
    case "pitfall":
      instance_create(entityX, entityY, PitFall);
    break;
    case "fragbox":
      instance_create(entityX, entityY, FragBox);
    break;
    case "playerwall":
      instance_create(entityX, entityY, PlayerWall);
    break; 
    case "bulletwall":
      instance_create(entityX, entityY, BulletWall);
    break; 
    case "playerwall_horizontal":
      instance_create(entityX, entityY, PlayerWallHorizontal);
    break; 
    case "bulletwall_horizontal":
      instance_create(entityX, entityY, BulletWallHorizontal);
    break;
    case "rightdoor":
      instance_create(entityX, entityY, RightDoor);
    break;
    case "leftdoor":
      instance_create(entityX, entityY, LeftDoor);
    break;
    case "controlPoint5":
      instance_create(entityX, entityY, ControlPoint5);
    break;   
    case "controlPoint4":
      instance_create(entityX, entityY, ControlPoint4);
    break;
    case "controlPoint3":
      instance_create(entityX, entityY, ControlPoint3);
    break;
    case "controlPoint2":
      instance_create(entityX, entityY, ControlPoint2);
    break;
    case "controlPoint1":
      instance_create(entityX, entityY, ControlPoint1);
    break;
    case "NextAreaO":
      instance_create(entityX, entityY, NextAreaO);
    break;
    case "PreviousAreaO":
      instance_create(entityX, entityY, PreviousAreaO);
    break;
    case "CapturePoint":
      instance_create(entityX, entityY, CaptureZone);
    break;
    case "SetupGate":
      instance_create(entityX, entityY, ControlPointSetupGate);
    break;
    case "ArenaControlPoint":
      instance_create(entityX, entityY, ArenaControlPoint);
    break;
    case "GeneratorRed":
      instance_create(entityX, entityY, GeneratorRed);
    break;
    case "GeneratorBlue":
      instance_create(entityX, entityY, GeneratorBlue);
    break;
    case "MoveBoxUp":
      instance_create(entityX, entityY, MoveBoxUp);
    break;
    case "MoveBoxDown":
      instance_create(entityX, entityY, MoveBoxDown);
    break;
    case "MoveBoxLeft":
      instance_create(entityX, entityY, MoveBoxLeft);
    break;
    case "MoveBoxRight":
      instance_create(entityX, entityY, MoveBoxRight);
    break;     
    case "KothControlPoint":
      instance_create(entityX, entityY, KothControlPoint);
    break;
    case "KothRedControlPoint":
      instance_create(entityX, entityY, KothRedControlPoint);
    break;
    case "KothBlueControlPoint":
      instance_create(entityX, entityY, KothBlueControlPoint);
    break;
    
    /* 
    
    Code from this point on is for experimental objects that aren't added yet, like teleports and map logics
    Shit also needs to be fixed/cleaned up/done better before implementing.  
    
    case "teleport_1_point_1":
      if (instance_exists(teleport_1_point_1))
      {
            break;
      }
      else
      {
            instance_create(entityX, entityY, teleport_1_point_1);
      }
    break; 
    case "teleport_1_point_2":
      if (instance_exists(teleport_1_point_2))
      {
            break;
      }    
      else
      {
            instance_create(entityX, entityY, teleport_1_point_2);
      }
    case "teleport_2_point_1":
      if (instance_exists(teleport_2_point_1))
      {
            break;
      }
      else
      {
            instance_create(entityX, entityY, teleport_2_point_1);
      }
    break; 
    case "teleport_2_point_2":
      if (instance_exists(teleport_2_point_2))
      {
            break;
      }    
      else
      {
            instance_create(entityX, entityY, teleport_2_point_2);
      }      
    break; 
    case "teleport_3_point_1":
      if (instance_exists(teleport_3_point_1))
      {
            break;
      }
      else
      {
            instance_create(entityX, entityY, teleport_3_point_1);
      }
    break; 
    case "teleport_3_point_2":
      if (instance_exists(teleport_3_point_2))
      {
            break;
      }    
      else
      {
            instance_create(entityX, entityY, teleport_3_point_2);
      }      
    break; 
    case "teleport_4_point_1":
      if (instance_exists(teleport_4_point_1))
      {
            break;
      }
      else
      {
            instance_create(entityX, entityY, teleport_4_point_1);
      }
    break; 
    case "teleport_4_point_2":
      if (instance_exists(teleport_4_point_2))
      {
            break;
      }    
      else
      {
            instance_create(entityX, entityY, teleport_4_point_2);
      }      
    break; 
    case "teleport_5_point_1":
      if (instance_exists(teleport_5_point_1))
      {
            break;
      }
      else
      {
            instance_create(entityX, entityY, teleport_5_point_1);
      }
    break; 
    case "teleport_5_point_2":
      if (instance_exists(teleport_5_point_2))
      {
            break;
      }    
      else
      {
            instance_create(entityX, entityY, teleport_5_point_2);
      }      
    break; 
    case "teleport_6_point_1":
      if (instance_exists(teleport_6_point_1))
      {
            break;
      }
      else
      {
            instance_create(entityX, entityY, teleport_6_point_1);
      }
    break; 
    case "teleport_6_point_2":
      if (instance_exists(teleport_6_point_2))
      {
            break;
      }    
      else
      {
            instance_create(entityX, entityY, teleport_6_point_2);
      }      
    break; 
    case "teleport_7_point_1":
      if (instance_exists(teleport_7_point_1))
      {
            break;
      }
      else
      {
            instance_create(entityX, entityY, teleport_7_point_1);
      }
    break; 
    case "teleport_7_point_2":
      if (instance_exists(teleport_7_point_2))
      {
            break;
      }    
      else
      {
            instance_create(entityX, entityY, teleport_7_point_2);
      }      
    break;
    case "teleport_8_point_1":
      if (instance_exists(teleport_8_point_1))
      {
            break;
      }
      else
      {
            instance_create(entityX, entityY, teleport_8_point_1);
      }
    break; 
    case "teleport_8_point_2":
      if (instance_exists(teleport_8_point_2))
      {
            break;
      }    
      else
      {
            instance_create(entityX, entityY, teleport_8_point_2);
      }      
    break;     
    case "teleport_9_point_1":
      if (instance_exists(teleport_9_point_1))
      {
            break;
      }
      else
      {
            instance_create(entityX, entityY, teleport_9_point_1);
      }
    break; 
    case "teleport_9_point_2":
      if (instance_exists(teleport_9_point_2))
      {
            break;
      }    
      else
      {
            instance_create(entityX, entityY, teleport_9_point_2);
      }      
    break; 
    case "teleport_10_point_1":
      if (instance_exists(teleport_10_point_1))
      {
            break;
      }
      else
      {
            instance_create(entityX, entityY, teleport_10_point_1);
      }
    break; 
    case "teleport_10_point_2":
      if (instance_exists(teleport_10_point_2))
      {
            break;
      }    
      else
      {
            instance_create(entityX, entityY, teleport_10_point_2);
      }      
    break;
    case "gameMode_ctf":
      // in the future with new gametypes, make sure to include more instance_exists checks, each for a gametype.
      if (instance_exists(gameMode_VIP_Logic))
      {
            break;
      }
      else
      {
            instance_create(entityX, entityY, gameMode_CTF_Logic);
            global.gameMode = GAMEMODE_CTF;
      }
    break;   
    case "gameMode_vip":
    {
      if (instance_exists(gameMode_CTF_Logic))
      {
            break;
      }
      else
      {
            instance_create(entityX, entityY, gameMode_VIP_Logic);
            global.gameMode = GAMEMODE_VIP;
      }
    break;                                                 
    }
    case "vip_start":
    {
      if (instance_exists(courierStart))
      {
            break;
      }
      else
      {
            instance_create(entityX, entityY, courierStart);
      }
    break;                                                 
    }    
    case "vip_end":
    {
      if (instance_exists(courierGoal))
      {
            break;
      }
      else
      {
            instance_create(entityX, entityY, courierGoal);
      }
    break;                                                 
    }    
    */    
  }
}
}
