/**
 * Script that checks the extra added data, plugins can load their own metadata using global.metadataFunction
 * Argument0: The metadata
*/

var background, i, controller;

controller = instance_create(0, 0, ParallaxController);

// The map background color
background = readProperty(argument0, "background", HEX, $000000);
background_color = make_color_rgb((background&$ff0000)>>16, (background&$00ff00)>>8, background&$0000ff);

// Load parallax backgrounds
for(i=0;i<6;i += 1)
{
    background = readProperty(argument0, "layer" + string(i), STRING, "");
    if (background != "")
    {
        controller.num_bgs = i+1;
        background_index[i] = stringToResource(background, true);
        background_xscale[i] = 6;
        background_yscale[i] = 6;
        background_htiled[i] = 6;
        background_visible[i] = true;
    }
}

// Load a foreground
background = readProperty(argument0, "foreground", STRING, "");
if (background != "")
    controller.foreground = stringToResource(background, true);

execute_string(global.metadataFunction, argument0);
