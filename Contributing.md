Reporting Issues
================

When you find a problem with the game, it is understandable that you want to tell us about the problem as quickly as possible.
However, please make sure that you actually include enough information for us to understand the problem and to figure out what
exactly went wrong:

- Describe what happened in detail. For example, "The game crashed" doesn't tell us much. "The game froze and Windows showed an "application not responding" screen" gives us a much better idea of what happened and can help us narrow down the possible causes. Likewise, "someone was shooting through walls" is a lot less helpful than "A blue pyro was shooting flares through the red spawn doors on the first stage of cp_dirtbowl".
- Please copypaste the text of all error messages that you encounter
- Screenshots or GIFs of the issue are often invaluable

Contributing code
=================

Game Maker
----------

Gang Garrison 2 is built with Game Maker 8.0 Pro, so you will need that for most development tasks. Newer versions of Game Maker will unfortunately not work at this time, since they introduced incompatible changes. The "lite" / free version of Game Maker 8 is also not sufficient.

Git Setup
---------

This repository requires you to have `core.autocrlf` set to `false`, so make sure you do this when you first clone it:

    git config --local core.autocrlf false

Otherwise, you'll screw up the line endings.

GmkSplitter
-----------

The source code as committed to git is in the `Source/gg2` directory. It is stored in "split" form. To reassemble the source code into a .gmk file, you'll need MedO's [GmkSplitter](https://github.com/Medo42/Gmk-Splitter), and to run `gmksplit gg2 gg2.gmk`, or `gmksplit gg2 gg2.gmk` to split the .gmk file into the format stored in git. If you have gmksplit.exe in your PATH or your `Source` directory, there are handy `gg2GmkToGit` and `gg2GitToGmk` convenience scripts that will delete the output file if it already exists and do the splitting/reassembling for you.

Readme
------

If you add to the settings or change the gameplay, it is a good idea to update `Readme.txt`.

Coding Style
------------

GG2 follows the following coding style:

Semicolons are *always* required at the ends of statements.

    x = x + hspeed;

Parens are *always* required around conditionals [and their sister blocks: with(), switch(), and repeat()].

    if (mode == 2)
        draw_sprite_ext(TimerOutlineS, 0, xoffset+xsize/2, yoffset, 2, 2, 0, c_white, 1);

Spacing between parens, if, and conditionals is so inconsistent in the codebase that we don't have a standard for it. Go with what looks good. Same with operations, go with what makes the expression easily readable. However, it "should" always be symmetrical.

    if(variable);
    if( variable );
    if (variable);

Unless there's a good reason not to, space out the set statement sides from eachother.

    x = 5/7;

When crossing order-of-operations boundries *without* parens, usually space the later operation away from the earlier operation. However, depending on the arithmetic being performed, a different spacing may be appropriate.

    x = 3 + 4/8;
    y = 5*(x+2);

Block braces should be on a new line and indentation is four spaces.

    if(something_is_true)
    {
        werunablock = true;
        something();
    }

You may skip using braces on single-line statements under certain situations.

    if(variable)
        thing;
    else
        other_thing;

You may NOT skip braces on conditions with other conditions inside of them.

    while(1)
    {
        if(x > n)
            break;
        else
            x += 1;
    }

    if (x/y > 5)
    {
        if(amOnFire)
            hp -= damage;
        else
            . . .
    }

You may skip braces with VERY simple series-es of single blocks, but not ones with multiple children blocks.

    with (BladeB)
        if (ownerPlayer == other.ownerPlayer)
            instance_destroy();

    loopsoundstop(MedigunSnd);
    if(instance_exists(healTarget))
        if(healTarget.object != noone)
            healTarget.object.healer = noone;

    with (Player)
    {
        if (object == global.myself)
            . . .
        else
            . . .
    }


Don't indent switch blocks; but do indent case blocks.

    switch(player.commandReceiveCommand)
    {
    case PLAYER_LEAVE:
        socket_destroy(player.socket);
        player.socket = -1;
        break;
       
    . . .
    }


*Always* use english versions of boolean operators. The symbol versions play well with neither gmksplit nor GM's build in code editor.

    if (intel and (ubered or global.mapchanging) and global.isHost)
        . . .


Use newlines to seperate logically distinct segments of code.

    // drop intel if ubered or round is over
    if (intel and (ubered or global.mapchanging) and global.isHost)
    {
        sendEventDropIntel(player);
        doEventDropIntel(player);
    }

    //gotta regenerate some nuts
    nutsNBolts = min(nutsNBolts+0.1, maxNutsNBolts);


Boolean expressions should always be encased in parentheses.

    if (global.myself != -1)
    {
        teamoffset = (global.myself.team == TEAM_BLUE);
        . . .
    }


Variable names should start with a lowercase letter, with subsequent words capitalized (intercapping). Shorthand words in non-state or local algorithm variables (such as adhoc logic variables) can fuzz this rule a little, and so can variables which pretend to be part of a GM variable family, but there's a limit.

    thisIsAVariable
    teamoffset
    yoffset
    timerPos
    menu_script_back
    stepHasRun

Object names should always start with a capital letter and be intercapped after that.

    DeathCam

Sprite names should, when applicable, be the name of their associate object with a capital S "kind" suffix. Otherwise, they still need the S, unless they have an exceptional reason not to.

    ScoutRedS

Script names should start with a lowercase letter and be intercapped after that, unless they're pretending to be like GM's built-in functions.

    setChatBubble
    gotoInternalMapRoom
    createGib
    ds_list_sorted_insert
    game_init
    draw_roundtimer

Constants are always all capital letters, with underscores to separate words.

    PROTOCOL_UUID
    CHANGE_MAP
