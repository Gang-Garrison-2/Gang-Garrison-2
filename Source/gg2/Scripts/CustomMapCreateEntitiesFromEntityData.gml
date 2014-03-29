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
    case "redspawn":
      instance_create(entityX, entityY, SpawnPointRed);
    break;
    case "bluespawn":
      instance_create(entityX, entityY, SpawnPointBlue);    
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
    case "medCabinet":
      instance_create(entityX, entityY, HealingCabinet);
    break;
  }
}
}