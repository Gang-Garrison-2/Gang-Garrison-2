var ret; //The resulting compressed string.
var width, height;
var wm_surface, wm_sprite, wm_collision_dummy;

width = background_get_width(BuilderWMB);
height = background_get_height(BuilderWMB);

//Write the walkmask background to a surface.
wm_surface = surface_create(background_get_width(BuilderWMB), background_get_height(BuilderWMB));

//Draw the walkmask onto the surface.
surface_set_target(wm_surface);
draw_set_color(c_aqua);
draw_rectangle(0,0,width,height,false);
draw_background(BuilderWMB,0,0);
surface_reset_target();

//Write the surface to a sprite,
//Rather than read colours from the surface, we will do collision detection on each pixel of a sprite.
wm_sprite = sprite_create_from_surface(wm_surface,0,0,background_get_width(BuilderWMB),background_get_height(BuilderWMB),true,false,0,0);
surface_free(wm_surface);

//Create a dummy collision object using this sprite for collisions
wm_collision_dummy = instance_create(0,0,CollisionDummy);
wm_collision_dummy.sprite_index = wm_sprite;

//Scan the image, creating a condensed string as we go.
ret = "{WALKMASK}"+chr(10)+string(width)+chr(10)+string(height)+chr(10);
var char_fill, num_value;
char_fill = 0;
num_value = 0;
var a, b;
for(a = 0; a < height; a += 1){
    drawProgressBar(a / height * 100, "Compressing Walkmask");
    screen_refresh();
    for(b = 0; b < width; b += 1){
        //Shift preview bits left.
        num_value = num_value << 1;
        //Set a 1 if this pixel is solid.
        if(collision_point(b,a,CollisionDummy,1,0)) num_value += 1;
        char_fill+=1;
        //If we have maxed out with 6 bits in this num_value, save this character to the result.
        if(char_fill == 6){
            ret+=chr(num_value+32);
            //Reset to the beginning of the next character.
            num_value = 0;
            char_fill = 0;
        }
    }
}
//If we are partway through a character, then finish it out and and save it to the result.
if(char_fill > 0){
    for(char_fill = char_fill; char_fill < 6; char_fill += 1)
    num_value = num_value<<1;
    ret+=chr(num_value+32);
}

with(wm_collision_dummy) instance_destroy();
sprite_delete(wm_sprite);
return ret + chr(10) + "{END WALKMASK}";
