currentDate = date_current_date();
if date_get_month(currentDate) == 4 && date_get_day(currentDate) == 1 {
    global.aFirst = true;
    sprite_assign(BubblesS, BubbleFaceS);
}
else global.aFirst = false;
if date_get_month(currentDate) == 9 && date_get_day(currentDate) == 7 {
    global.gg_birthday = true;
    partyTime();
}
else global.gg_birthday = false;
