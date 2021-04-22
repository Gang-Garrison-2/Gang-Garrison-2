if (global.run_virtual_ticks)
{
    if (global.setupTimer > 0)
        global.setupTimer -= 1;
    if (global.setupTimer == 90 or global.setupTimer == 120
        or global.setupTimer == 150 or global.setupTimer == 180)
        sound_play(CountDown1Snd);
    else if (global.setupTimer == 60)
        sound_play(CountDown2Snd);
    else if (global.setupTimer == 30)
    {
        timer = timeLimit;
        sound_play(SirenSnd);
    }
}
