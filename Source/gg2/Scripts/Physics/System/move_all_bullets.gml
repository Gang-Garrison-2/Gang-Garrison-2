gunSetSolids();
with(Shot)
{
    if(!variable_local_exists("firststep"))
        firststep = true;
    
    vspeed += 0.15 * global.delta_factor;
    if(global.particles != PARTICLES_OFF)
    {
        //We don't want it to be almost invisible if it's still "active", so
        //we have it as if 0.3 is its lower limit
        image_alpha = (alarm[0]/lifetime)/2+0.5;
    }
    image_angle = direction;
    
    if(!firststep and global.delta_factor != 1)
    {
        x += hspeed * global.delta_factor;
        y += vspeed * global.delta_factor;
    }
    
    if (!place_free(x, y))
    {
        imp = instance_create(x,y,Impact);
        imp.image_angle=direction;
        instance_destroy();
    }
    
    if(!firststep and global.delta_factor != 1)
    {
        x -= hspeed;
        y -= vspeed;
    }
    else
        firststep = false;
}
with(Rocket)
{
    if(!variable_local_exists("firststep"))
        firststep = true;
    
    if(instance_exists(owner))
    {
        lastknownx = owner.x;
        lastknowny = owner.y;
    }
    travelDistance = point_distance(x, y, lastknownx, lastknowny);
    
    if(travelDistance >= distanceToTravel)
    {
        fade = true;
        alarm[3] = 8 / global.delta_factor;
    }
    
    // It might seem like a good idea to remove this. But it's not.
    speed += 1 * global.delta_factor;
    speed *= delta_mult(0.92);
    image_angle = direction;
    
    if (fade)
        image_alpha -= 0.1 * global.delta_factor;
    if (global.run_virtual_ticks)
    {
        if (image_alpha > 0)
        {
            if(global.particles = PARTICLES_NORMAL)
                effect_create_below(ef_smoke,x-hspeed*1.3,y-vspeed*1.3,0,c_gray);
            else if(global.particles == PARTICLES_ALTERNATIVE)
            {
                if (!variable_local_exists("rocketblurParticleType"))
                {
                    rocketblurParticleType = part_type_create();
                    if team == TEAM_RED rocketParticleSprite = RedRocketS;
                    else rocketParticleSprite = BlueRocketS;
                    part_type_sprite(rocketblurParticleType,rocketParticleSprite,false,true,false);
                    part_type_alpha2(rocketblurParticleType,0.7,0.1);
                    
                    var rocketpartlife;
                    rocketpartlife = 5 / global.delta_factor;
                    part_type_life(rocketblurParticleType, rocketpartlife, rocketpartlife);
                }
                
                if (!variable_global_exists("rocketblurParticleSystem"))
                {
                    global.rocketblurParticleSystem = part_system_create();
                    part_system_depth(global.rocketblurParticleSystem, 10);
                }
                
                part_type_orientation(rocketblurParticleType,direction,direction,0,0,0);
                
                part_particles_create(global.rocketblurParticleSystem, x, y, rocketblurParticleType, 1);
            }
        }
        else
            instance_destroy();
    }
    if(!firststep and global.delta_factor != 1)
    {
        x += hspeed * global.delta_factor;
        y += vspeed * global.delta_factor;
    }
    
    if (!place_free(x, y))
    {
        characterHit = -1;
        if (!fade)
            event_user(5);
        else
            instance_destroy();
    }
    
    if(!firststep and global.delta_factor != 1)
    {
        x -= hspeed;
        y -= vspeed;
    }
    else
        firststep = false;
    
    firststep = false;
}
with(BladeB)
{
    if(!variable_local_exists("firststep"))
        firststep = true;
    
    if(!firststep and global.delta_factor != 1)
    {
        x += hspeed * global.delta_factor;
        y += vspeed * global.delta_factor;
    }
    
    if (!place_free(x, y))
    {
        imp = instance_create(x,y,Impact);
        imp.image_angle=direction;
        instance_destroy();
    }
    
    if(!firststep and global.delta_factor != 1)
    {
        x -= hspeed;
        y -= vspeed;
    }
    else
        firststep = false;
    
    firststep = false;
}
with(BurningProjectile)
{
    if(!variable_local_exists("firststep"))
        firststep = true;
    
    if(object_index == Flame)
        vspeed += 0.15 * global.delta_factor;
    
    if(global.particles == PARTICLES_NORMAL and global.run_virtual_ticks)
    {
        if(random(5) < 1)
            effect_create_below(ef_smokeup, x, y-8, 0, c_gray);
    }
    else if(global.particles == PARTICLES_ALTERNATIVE and global.run_virtual_ticks)
    {
        if(not variable_global_exists("flameParticleType"))
        {
            global.flameParticleType = part_type_create();
            part_type_sprite(global.flameParticleType, FlameS, true, false, true);
            part_type_alpha2(global.flameParticleType, 1, 0.3);
            part_type_life(global.flameParticleType, 4, 7);
        }
        
        if(not variable_global_exists("flameParticleSystem"))
        {
            global.flameParticleSystem = part_system_create();
            part_system_depth(global.flameParticleSystem, 10);
        }
        if(random(8) < 1)
            part_particles_create(global.flameParticleSystem,x,y,global.flameParticleType,1);
    }
    
    if(!firststep and global.delta_factor != 1)
    {
        x += hspeed * global.delta_factor;
        y += vspeed * global.delta_factor;
    }
    
    if (!place_free(x, y))
        instance_destroy();
    
    if(!firststep and global.delta_factor != 1)
    {
        x -= hspeed;
        y -= vspeed;
    }
    else
        firststep = false;
    
    firststep = false;
}
with(Mine)
{
    if(!variable_local_exists("firststep"))
        firststep = true;
    
    if(stickied)
    {
        if (reflector != noone and alarm[0] < 0)
            alarm[0] = 30 / global.delta_factor;
        splashThreshhold = false;
    }
    else
    {
        vspeed += 0.2 * global.delta_factor;
        vspeed = min(vspeed,8);
        splashThreshhold = true;
        if (global.run_virtual_ticks)
        {
            particleCycle = (particleCycle + 1) mod 2;
            if(particleCycle)
                instance_create(x, y, MineTrail);
        }
    }
    
    if(!firststep and global.delta_factor != 1)
    {
        x += hspeed * global.delta_factor;
        y += vspeed * global.delta_factor;
    }
    
    if (instance_exists(ControlPointSetupGate))
    {
        if (place_meeting(x, y, ControlPointSetupGate) and ControlPointSetupGate.solid)
            instance_destroy();
    }
    
    if(!firststep and global.delta_factor != 1)
    {
        x -= hspeed;
        y -= vspeed;
    }
    else
        firststep = false;
    
    firststep = false;
}
with(Needle)
{
    if(!variable_local_exists("firststep"))
        firststep = true;
    
    vspeed += 0.2 * global.delta_factor;
    if(global.particles != PARTICLES_OFF)
        image_alpha = (alarm[0]/lifetime)/2+0.5;
    
    image_angle = direction;
    
    if(!firststep and global.delta_factor != 1)
    {
        x += hspeed * global.delta_factor;
        y += vspeed * global.delta_factor;
    }
    
    if (!place_free(x, y))
    {
        imp = instance_create(x,y,Impact);
        imp.image_angle=direction;
        instance_destroy();
    }
    
    if(!firststep and global.delta_factor != 1)
    {
        x -= hspeed;
        y -= vspeed;
    }
    else
        firststep = false;
    
    firststep = false;
}

gunUnsetSolids();

