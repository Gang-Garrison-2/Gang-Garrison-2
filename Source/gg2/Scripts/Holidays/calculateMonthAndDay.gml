currentDate = date_current_date();
global.gg_birthday = false;
global.xmas = false;

calculateAprilFools();

if(date_get_month(currentDate) == 9 and date_get_day(currentDate) == 7)
    global.gg_birthday = true;

if((date_get_month(currentDate) == 12 and date_get_day(currentDate) > 23) or (date_get_month(currentDate) == 1 and date_get_day(currentDate) < 3)) {
    global.xmas = true;
}

if(global.xmas)
    xmasTime();
