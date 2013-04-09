/// Compare two Server objects by compatibility and ping

if(argument0.compatible and not (argument1.compatible))
    return -1;
if(argument1.compatible and not (argument0.compatible))
    return 1;

if(argument0.ping != -1 and argument1.ping == -1) {
    return -1;
}
if(argument1.ping != -1 and argument0.ping == -1) {
    return 1;
}

if(argument0.ping < argument1.ping)
    return -1;
if(argument0.ping > argument1.ping)
    return 1;
    
return 0;
