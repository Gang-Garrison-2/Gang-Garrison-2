//If we've reached this stage, then we are good to go. Let's start the entity creation!
var ret;
ret = "{ENTITIES}" + chr(10)
with(LevelEntity){
    ret += type + chr(10)
    ret += string(x) + chr(10)
    ret += string(y) + chr(10)
}
return ret + "{END ENTITIES}";
