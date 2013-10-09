// damageGenerator( sourcePlayer, damagedObject, damageDealt )
var object;
object = argument1.object_index;

if(object_is_ancestor(object, Character) or object == Character )
    damageCharacter( argument0, argument1, argument2 );
else if(object_is_ancestor(object, Sentry) or object == Sentry )
    damageSentry( argument0, argument1, argument2 );
else if(object_is_ancestor(object, Generator) or object == Generator )
    damageGenerator( argument0, argument1, argument2 );
else // This is probably a mistake, error
    show_message("ERROR: Tried to apply damage to an entity that#"+
                 "probably doesn't have health. Please report this error.##"+
                 "Technical information for debuggers: "
                    + string(argument0.class) + " "
                    + string(argument1.object_index)+ " "
                    + string(argument2));

