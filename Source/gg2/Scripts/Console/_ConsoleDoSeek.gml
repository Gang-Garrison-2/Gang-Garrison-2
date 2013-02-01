// argument0 - seek

seek = argument0;

var visible_string_width, full_string_width, visible_string;
visible_string = string_copy(text, 0, seek);
visible_string_width = string_width(visible_string);
full_string_width = string_width(text);

if (visible_string_width - viewport_x > console_width) {
    viewport_x = visible_string_width - console_width;
} else if (visible_string_width - viewport_x < 0) {
    viewport_x = visible_string_width;
} else if (full_string_width < console_width) {
    viewport_x = 0;
}
