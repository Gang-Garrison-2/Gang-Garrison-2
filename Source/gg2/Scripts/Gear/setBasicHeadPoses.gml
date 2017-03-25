// setBasicHeadPoses(className, dxBase, dyBase, bobAmount, tauntPoseString)

// Sets the head poses for all basic animation frames of a character.
// This includes the running, jumping, leaning and standing frames.
// Since these positions can be calculated relative to the "standing" frame for most characters, this helper function
// does just that.

// className must be the class prefix used in the sprite names.
// dxBase is the position of the reference point on the character's head in the standing sprite, relative to its origin.
var className, dxBase, dyBase, bobAmount, tauntPoseString;

className = argument0;
dxBase = argument1;
dyBase = argument2;
bobAmount = argument3;
tauntPoseString = argument4;

var basicAnimations, team, j;

basicAnimations = split("Run,Stand,LeanL,LeanR,Jump,Taunt", ",");

for(team = 0; team < 2; team += 1)
{
    for(j=0; j<ds_list_size(basicAnimations); j+=1)
    {
        var animation, spriteId;
        animation = ds_list_find_value(basicAnimations, j);
        spriteId = getCharacterSpriteId(className, team, animation);
        
        switch(animation)
        {
        case "Run":
            setHeadPose(spriteId, 0, dxBase, dyBase-bobAmount, 0, 1);
            setHeadPose(spriteId, 1, dxBase, dyBase, 0, 1);
            setHeadPose(spriteId, 2, dxBase, dyBase-bobAmount, 0, 1);
            setHeadPose(spriteId, 3, dxBase, dyBase, 0, 1);
            break;
        case "Taunt":
            setHeadPosesFromString(spriteId, dxBase, dyBase, tauntPoseString);
            break;
        default:
            setHeadPose(spriteId, 0, dxBase, dyBase, 0, 1);
            break;
        }
    }
}

ds_list_destroy(basicAnimations);

