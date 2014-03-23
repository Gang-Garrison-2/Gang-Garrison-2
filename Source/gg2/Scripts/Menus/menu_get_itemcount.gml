// Returns the number of items that should actually be drawn by a menu
// This is different from items because we programmatically add the back button.

if(menu_text_back == "")
    return items;
else
    return items + 1;
