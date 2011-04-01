currentDate = date_current_date();
global.aFirst = false;
global.gg_birthday = false;

if(date_get_month(currentDate) == 4 and date_get_day(currentDate) == 1)
{
    if(date_get_year(currentDate) != 2011) // April fools bubble disabled this year because of big release
        global.aFirst = true;
    else
        global.gg_birthday = true;
}

if(date_get_month(currentDate) == 9 && date_get_day(currentDate) == 7)
    global.gg_birthday = true;

if(global.aFirst)
    sprite_assign(BubblesS, BubbleFaceS);
    
if(global.gg_birthday)
    partyTime();
