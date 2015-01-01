/**
 * Script that checks the extra added data, plugins can load their own metadata using global.metadataFunction
 * Argument0: The metadata
 * [Argument1]: true if the script is executed in the builderroom.
*/

var background, voidColor, i, controller, scale;
controller = noone;
with(ParallaxController)
    controller = id;    // Use an existing parallax controller if possible.

// The map background color
background = readProperty(argument0, "background", HEX, $000000);
background_color = make_color_rgb((background&$ff0000)>>16, (background&$00ff00)>>8, background&$0000ff);

voidColor = readProperty(argument0, "void", HEX, $000000);
voidColor = make_color_rgb((voidColor&$ff0000)>>16, (voidColor&$00ff00)>>8, voidColor&$0000ff);

if (voidColor != background)
{
    if (controller == noone)
        controller = instance_create(0, 0, ParallaxController);
    
    controller.voidColor = voidColor;
}

// Set the map scale (for hd maps)
scale = readProperty(argument0, "scale", REAL, 6);
background_xscale[7] = scale;
background_yscale[7] = scale;

// Load parallax backgrounds
for(i=0;i<7;i += 1)
{
    background = readProperty(argument0, "bg_layer" + string(i), STRING, "");
    if (background != "")
    {
        if (controller == noone)
            controller = instance_create(0, 0, ParallaxController);
            
        controller.num_bgs = i+1;
        
        // Layer depth (controls the amount of parallax.
        controller.background_xfactor[i] = readProperty(argument0, "layer" + string(i) + "xfactor", REAL, controller.background_xfactor[i]);
        controller.background_yfactor[i] = readProperty(argument0, "layer" + string(i) + "yfactor", REAL, controller.background_xfactor[i]);
        
        // Unload the previous backgrounds
        if (ds_map_find_value(global.resources, "bg_layer" + string(i)) > 0)
        {
            background_delete(ds_map_find_value(global.resources, "bg_layer" + string(i)));
            ds_map_delete(global.resources, "bg_layer" + string(i));
        }
        ds_map_add(global.resources, "bg_layer" + string(i), stringToResource(background, true));
        
        background_index[i] = ds_map_find_value(global.resources, "bg_layer" + string(i))
        background_xscale[i] = background_xscale[7];
        background_yscale[i] = background_yscale[7];
        background_htiled[i] = true;
        background_visible[i] = true;
    }
    else
    {
        background_visible[i] = false;
    }
}

// Load a foreground
background = readProperty(argument0, "bg_foreground", STRING, "");
if (background != "")
{
    if (controller == noone)
            controller = instance_create(0, 0, ParallaxController);
            
    if (controller.foreground != -1)
        background_delete(controller.foreground);
    controller.foreground = stringToResource(background, true);
}
else if (controller != noone) {
    if (controller.foreground != -1)
        background_delete(controller.foreground);
    controller.foreground = -1;
}

execute_string(global.metadataFunction, argument0, argument1);
