currentDate = date_current_date();
if date_get_month(currentDate) == 4 && date_get_day(currentDate) == 1 {
    global.aFirst = true;
    sprite_assign(BubblesS, BubbleFaceS);
}
else global.aFirst = false;
