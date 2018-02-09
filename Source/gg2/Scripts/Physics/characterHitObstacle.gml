// When a Character hits a wall, box, impassable door, or anything else solid,
// this handles movement, climbing stairs, stopping at walls, etc.
// Originally meant to be run in collision, but we moved it; now run in step.

{
    hspeed *= global.delta_factor;
    vspeed *= global.delta_factor;
    
    var oldx, oldy, oldhspeed, oldvspeed, distleft, hleft, vleft, bboxheight, bboxwidth, collideDropdownBoxes, charColBottom;
    oldx=x;
    oldy=y;
    oldhspeed=hspeed;
    oldvspeed=vspeed;
    bboxheight = bottom_bound_offset-top_bound_offset;
    bboxwidth = right_bound_offset-left_bound_offset;
    collideDropdownPlatforms = !(keyState & $02) and instance_exists(DropdownPlatform);
    
    // For now, let dropdown platforms not collide while we move out of walls
    // since being inside a dropdown platform is perfectly acceptable
    with(DropdownPlatform)
        solid = false;
    
    // slide in an appropriate direction to get outside of walls
    if(!place_free(x, y))
    {
        var uy, dy, lx, rx, distu, distd, distl, distr;
        
        move_outside_solid(90, bboxheight/2);
        distu = oldy - y;
        uy = y;
        y = oldy;
        
        move_outside_solid(270, bboxheight/2);
        distd = y - oldy;
        dy = y;
        y = oldy;
        
        move_outside_solid(0, bboxwidth/2);
        distr = x - oldx;
        rx = x;
        x = oldx;
        
        move_outside_solid(180, bboxwidth/2);
        distl = oldx - x;
        lx = x;
        x = oldx;
        
        if(distu < distd and distu < distr and distu < distl)
            y = uy;
        else if(distd < distr and distd < distl)
            y = dy;
        else if(distr < distl)
            x = rx;
        else
            x = lx;
        
        if(!place_free(x, y))
        {
            x = oldx;
            y = oldy;
        }
    }

    hleft = hspeed;
    vleft = vspeed;

    // Set dropdown platforms to solid if they are below us
    if(collideDropdownPlatforms)
    {
        charColBottom = bottom_bound_offset + y;
        if(frac(charColBottom) == 0.5)
            charColBottom = floor(charColBottom);
        else
            charColBottom = round(charColBottom);
            
        with(DropdownPlatform)
            solid = (charColBottom < round(y));
    }
    
    var loopCounter, stuck;
    loopCounter = 0;
    stuck = 0;
    while((abs(hleft) > 0.1 || abs(vleft) > 0.1) && stuck = 0){ // while we still have distance to travel
        loopCounter += 1;
        if(loopCounter > 10) {
            // debugging stuff.
            //show_message("x = " + string(x) + "#y = " + string(y) + "#oldx = " + string(oldx) + "#oldy = " + string(oldy) + "#hspeed = " + string(hspeed) + "#vspeed = " + string(vspeed) + "#hleft = " + string(hleft) + "#vleft = " + string(vleft) + "#hdirection = " + string(hdirection) + "#vdirection = " + string(vdirection));
            //game_end();

            // After 10 loops, it's assumed we're stuck.  Will eliminating vertical movement fix the problem?
            //vspeed = 0;
            //vleft = 0;
            // note that we should instead be checking the collisionRectified variable instead of waiting
            // some arbitrary number of iterations
            stuck = 1;
        }

        var prevX, prevY, collisionRectified, repeatMotion;
        collisionRectified = false; // set this to true when we fix a collision problem
        // (eg. detect hitting the ceiling and setting vspeed = 0)
        // if, after checking for all our possible collisions, we realize that we haven't
        // been able to fix a collision problem, then we probably hit a corner or something,
        // and we should try to fix that
        
        do {
            prevX = x;
            prevY = y;
            // move as far as we can without hitting something
            good_move_contact_solid(point_direction(x, y, x + hleft, y + vleft), point_distance(x, y, x + hleft, y + vleft));
            // deduct that movement from our remaining movement
            hleft -= x - prevX;
            vleft -= y - prevY;
            
            // Due to the movement, some dropdown platforms which were below us may now be above us (or vice versa).
            if(collideDropdownPlatforms)
            {
                charColBottom = bottom_bound_offset + y;
                if(frac(charColBottom) == 0.5)
                    charColBottom = floor(charColBottom);
                else
                    charColBottom = round(charColBottom);
                    
                with(DropdownPlatform)
                    solid = charColBottom < round(y);   
            }
            repeatMotion = false;
            if(global.lastCollisionHappened)
                if(place_free(global.lastCollisionX, global.lastCollisionY))
                    repeatMotion = true;
        } until (!repeatMotion);
            
        // determine what we hit, and act accordingly
        if(vleft != 0 && !place_free(x, y + sign(vleft))) { // we hit a ceiling or floor
            if(vleft > 0) { // floors, not ceilings, reset moveStatus
                if(collideDropdownPlatforms)
                {
                    // Now we need to find out whether we *only* collided with a surfing dropdown
                    // To do that, we temporarily remove those from the solids, and then check if we would still collide
                    var unsolidifiedDropdowns;
                    unsolidifiedDropdowns = ds_list_create();
                    with(DropdownPlatform)
                    {
                        if(solid and !resetMoveStatus)
                        {
                            solid = false;
                            ds_list_add(unsolidifiedDropdowns, id);
                        }
                    }
                    
                    if(!place_free(x, y + sign(vleft)))
                        moveStatus = 0; // There is something other than a surfing platform below us
                    
                    var i;
                    for(i=0; i < ds_list_size(unsolidifiedDropdowns); i+=1)
                    {
                        (ds_list_find_value(unsolidifiedDropdowns, i)).solid = true;
                    }
                        
                    ds_list_destroy(unsolidifiedDropdowns);
                }
                else
                    moveStatus = 0;
            }
            vleft = 0; // don't go up or down anymore
            vspeed = 0; // don't try it next frame, either
            collisionRectified = true;
        }

        if(hleft != 0 && !place_free(x + sign(hleft), y)) { // we hit a wall on the left or right
            if(place_free(x + sign(hleft), y - 6)) // if we could just walk up the step
            {
                y -= 6; // hop up the step.
                moveStatus = 0;
            }
            else if(place_free(x + sign(hleft), y + 6) and abs(hspeed) >= abs(vspeed)) // ceiling sloping
            {
                y += 6;
                moveStatus = 0;
            }
            else // it's not just a step, we've actually gotta stop
            {
                hleft = 0; // don't go left or right anymore
                hspeed = 0; // don't try it next frame, either
            }
            collisionRectified = true;
        }
        
        if(!collisionRectified && (abs(hleft) >= 1 || abs(vleft) >= 1)) {
            // uh-oh, no collisions fixed, try stopping all vertical movement and see what happens
            // (common case: falling sideways onto a corner)
            vspeed = 0;
            vleft = 0;
        }
    }
    
    hspeed /= global.delta_factor;
    vspeed /= global.delta_factor;
}
