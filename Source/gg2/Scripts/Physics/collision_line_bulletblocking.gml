if(collision_line(argument0, argument1, argument2, argument3, Obstacle, 1, 0)) return true;
if(collision_line(argument0, argument1, argument2, argument3, BulletWall, 1, 0)) return true;
if(collision_line(argument0, argument1, argument2, argument3, IntelGate, 1, 0)) return true;
if(not global.mapchanging)
    if(collision_line(argument0, argument1, argument2, argument3, TeamGate, 1, 0)) return true;
if(areSetupGatesClosed())
    if(collision_line(argument0, argument1, argument2, argument3, ControlPointSetupGate, 1, 0)) return true;
return false;
