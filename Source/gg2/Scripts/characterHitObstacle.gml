// When a Character hits a wall, box, impassable door, or anything else solid,
// this handles movement, climbing stairs, stopping at walls, etc.
// Should be run in the collision event.

{
    var oldx, oldy, oldhspeed, oldvspeed, distleft, hleft, vleft;
    oldx=x;
    oldy=y;
    oldhspeed=hspeed;
    oldvspeed=vspeed;

    // slide left and right to get outside of any walls
    move_outside_solid(0, 8);
    move_outside_solid(180, 16);

    hleft = hspeed;
    vleft = vspeed;

    var loopCounter, stuck;
    loopCounter = 0;
    stuck = 0;
    while((abs(hleft) >= 1 || abs(vleft) >= 1) && stuck = 0){ // while we still have distance to travel
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

        var prevX, prevY, collisionRectified;
        collisionRectified = false; // set this to true when we fix a collision problem
        // (eg. detect hitting the ceiling and setting vspeed = 0)
        // if, after checking for all our possible collisions, we realize that we haven't
        // been able to fix a collision problem, then we probably hit a corner or something,
        // and we should try to fix that

        prevX = x;
        prevY = y;
        // move as far as we can without hitting something
        move_contact_solid(point_direction(x, y, x + hleft, y + vleft), point_distance(x, y, x + hleft, y + vleft));
        // deduct that movement from our remaining movement
        hleft -= x - prevX;
        vleft -= y - prevY;

        // determine what we hit, and act accordingly

        if(vleft != 0 && !place_free(x, y + sign(vleft))) { // we hit a ceiling or floor
            if(vleft>0) {
                moveStatus = 0; // floors, not ceilings, reset moveStatus
            }
            vleft = 0; // don't go up or down anymore
            vspeed = 0; // don't try it next frame, either
            collisionRectified = true;
        }

        if(hleft != 0 && !place_free(x + sign(hleft), y)) { // we hit a wall on the left or right
            moveStatus = 0;
            if(place_free(x + sign(hleft), y - 6)) { // if we could just walk up the step
                y -= 6; // hop up the step.
                collisionRectified = true;
            }
            else if(place_free(x + sign(hleft), y + 6) and abs(hspeed) >= abs(vspeed)) // ceiling sloping
            {
                y += 6;
                collisionRectified = true;
            }
            else // it's not just a step, we've actually gotta stop
            {
                hleft = 0; // don't go left or right anymore
                hspeed = 0; // don't try it next frame, either
                collisionRectified = true;
            }
        }
        if(!collisionRectified && (abs(hleft) >= 1 || abs(vleft) >= 1)) {
            // uh-oh, no collisions fixed, try stopping all vertical movement and see what happens
            vspeed = 0;
            vleft = 0;
        }
    }

    x -= hspeed; // gamemaker will += these in a moment, so we compensate for that
    y -= vspeed;
}
