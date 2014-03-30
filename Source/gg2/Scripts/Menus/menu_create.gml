// argument0 - x position
// argument1 - y position
// argument2 - width
// argument3 - valueoffset
// argument4 - spacing
// argument5 - tab offset (upwards) [thanks GM for making unset args default to 0!!!11]
// argument6 - tab spacing
// argument7 - tab margin

virtualitem = -1;
xbegin = argument0;
ybegin = argument1;
width = argument2;
valueoffset = argument3;
spacing = argument4;
taboffset = argument5;
tabspacing = argument6;
tabmargin = argument7;
items = 0;
tabs = 0;
editing = -1;
dimmed = false;
stepHasRun = false;
drawbg = false;
getsHighlight = true;
bgtabs = false;
menumode = false;
screenheight = 600;

// Hack: The back button should usually appear last in the menu, even if plugins
// add new items later, so we treat it separately.
menu_script_back = "";
menu_text_back = "";
