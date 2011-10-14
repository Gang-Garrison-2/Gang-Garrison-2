{
    var currentDate, timestamp;
    currentDate = date_current_datetime();
    timestamp = string(date_get_year(currentDate));
    if (date_get_month(currentDate) < 10) { timestamp = timestamp + "0"; }
    timestamp = timestamp + string(date_get_month(currentDate));
    if (date_get_day(currentDate) < 10) { timestamp = timestamp + "0"; }
    timestamp = timestamp + string(date_get_day(currentDate));
    if (date_get_hour(currentDate) < 10) { timestamp = timestamp + "0"; }
    timestamp = timestamp + string(date_get_hour(currentDate));
    if (date_get_minute(currentDate) < 10) { timestamp = timestamp + "0"; }
    timestamp = timestamp + string(date_get_minute(currentDate));
    if (date_get_second(currentDate) < 10) { timestamp = timestamp + "0"; }
    timestamp = timestamp + string(date_get_second(currentDate));
    while (file_exists("Screenshots/" + timestamp + ".png")) {
        timestamp = timestamp + "0";
    }
    screen_save("Screenshots/" + timestamp + ".png");
}
