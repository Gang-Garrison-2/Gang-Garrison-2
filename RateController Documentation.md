This file documents the behavior of the variables set in RateController.

global.delta_factor =
=====================
This variable controls the rate at which continuous simulation functions run.

For example, if you have a bullet moving at speed S, then each frame, it needs to move a certain distance Y. delta_factor controls the relationship between S and Y.

    Y=S*delta_factor

When used on alarms, we can't alter the rate at which they decrease (it's always 1 per frame) so we alter the values that they count down from instead.

    alarm[0] = alarm_initial_countdown_value/delta_factor

However, delta_factor is only accurate when used to scale individual operations; a set of additions/subtractions each frame, or a set of multiplications/divisions. When you do both, accuracy breaks down. That leads us to:

global.frameskip =
==================
This variable controls the number of times that certain continuous simulation functions run each frame. From the physics' point of view, the effect is like frameskipping, but only for that specific function. This improves accuracy without significantly affecting performance. It's used in places that absolutely have to be as accurate as possible, such as player acceleration and deacceleration.

It's used like this:

    repeat(frameskip)
    {
        speed += acceleration;
        speed *= friction;
    }

global.skip_delta_factor =
==========================
For flexibility's sake, the ability to use delta time on frameskipped functions is available. This way, you never need to use a delta factor outside of the 0.75 to 1.5 range, which prevents snowballing inaccuracy as framerate deviates further from what it's expected to be. skip_delta_factor should be equal to delta_factor divided by frameskip.

It's used like this:

    repeat(frameskip)
    {
        speed += acceleration * global.skip_delta_factor;
        speed *= skip_delta_factor(friction);
    }

...Where skip_delta_factor is a function that returns a value based on friction and skip_delta_factor; in GG2's case, it returns a friction which will always result in a stable maximum speed when running acceleration and friction in one self-dependent continuous function like this.

global.ticks_per_virtual =
==========================
This is the number of actual frames that execute for a "virtual" frame -- that is, it's the deviation from the game's internal framerate (ticks) to the actual framerate. It's the opposite of frameskip. It's used along with a frame counter to tell certain functions whether or not to execute during a given frame.