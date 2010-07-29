/**
 * Spawn a player. If he already has a character object, destroy it
 * and respawn.
 *
 * argument0: The player who spawned
 * argument1: The spawnpoint ID
 */

var spawner, spawnpointId;
spawner = argument0;
spawnpointId = argument1;

var spawnX, spawnY, character;
if(spawner.team == TEAM_RED) {
    spawnX = ds_list_find_value(global.spawnPointsRedX, spawnpointId);
    spawnY = ds_list_find_value(global.spawnPointsRedY, spawnpointId);
} else {
    spawnX = ds_list_find_value(global.spawnPointsBlueX, spawnpointId);
    spawnY = ds_list_find_value(global.spawnPointsBlueY, spawnpointId);
}

character = getCharacterObject(spawner.team, spawner.class);
if(character == -1) {
    show_message("Spawning a player did not succeed because his class and/or team were invalid.");
    exit;
}

if(spawner.object != -1) {
    with(spawner.object) {
        instance_destroy();
    }
    spawner.object=-1;
}

spawner.object = instance_create(spawnX,spawnY,character);
spawner.object.player = spawner;
spawner.object.team = spawner.team;
with(spawner.object) {
    event_user(0);
}

if (instance_exists(RespawnTimer)) {
    with(RespawnTimer) {
        done = true;
    }
}

playsound(spawnX, spawnY, RespawnSnd);
