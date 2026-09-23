// No-op graphics/audio functions for headless (None platform/graphics/audio)
// builds. ENIGMA's None backends don't define these, but the game, the
// runtime and the particle extension still reference them.
// Linked in by the g++ wrapper next to this file; see build.sh --headless.
// Signatures must match ENIGMA's declarations exactly (C++ name mangling).

#include <string>

#include "Graphics_Systems/graphics_mandatory.h"
#include "Universal_System/var4.h"

namespace enigma {
int blendMode[2] = {0, 0};
void set_particles_implementation(particles_implementation*) {}
}  // namespace enigma

namespace enigma_user {

// Colors: real math, since game logic may compare or store them.
int make_color_rgb(unsigned char r, unsigned char g, unsigned char b) {
  return r | (g << 8) | (b << 16);
}
int make_color_hsv(int, int, int) { return 0; }
int color_get_red(int c) { return c & 0xFF; }
int color_get_green(int c) { return (c >> 8) & 0xFF; }
int color_get_blue(int c) { return (c >> 16) & 0xFF; }

// Drawing: nothing to draw on.
static float draw_alpha = 1;
void draw_set_alpha(float a) { draw_alpha = a; }
float draw_get_alpha() { return draw_alpha; }
int draw_set_blend_mode(int) { return 0; }
int draw_set_blend_mode_ext(int, int) { return 0; }
void draw_set_font(int) {}
void draw_set_halign(unsigned) {}
void draw_set_valign(unsigned) {}
void draw_background(int, float, float, int, float) {}
void draw_background_ext(int, float, float, float, float, double, int, float) {}
void draw_circle_color(float, float, float, int, int, bool) {}
void draw_line_width_color(float, float, float, float, float, int, int) {}
void draw_rectangle(float, float, float, float, bool) {}
void draw_rectangle_color(float, float, float, float, int, int, int, int, bool) {}
void draw_sprite(int, int, float, float, int, float) {}
void draw_sprite_part_ext(int, int, float, float, float, float, float, float,
                          float, float, int, float) {}
void draw_sprite_stretched_ext(int, int, float, float, float, float, int,
                               float) {}
void draw_text_color(float, float, variant, int, int, int, int, float) {}
void draw_text_ext(float, float, variant, float, float) {}
void draw_text_ext_color(float, float, variant, float, float, int, int, int,
                         int, float) {}
void draw_text_transformed(float, float, variant, float, float, double) {}
void draw_text_transformed_color(float, float, variant, float, float, double,
                                 int, int, int, int, float) {}
unsigned int string_height(variant) { return 0; }
unsigned int string_height_ext(variant, float, float) { return 0; }
int screen_save(std::string) { return -1; }
int screen_save_part(std::string, unsigned int, unsigned int, unsigned int,
                     unsigned int) {
  return -1;
}
int sprite_create_from_surface(int, int, int, int, int, bool, bool, int, int) {
  return -1;
}

// Audio: silent.
bool sound_play(int) { return false; }
bool sound_loop(int) { return false; }
void sound_stop(int) {}
void sound_stop_all() {}
bool sound_isplaying(int) { return false; }
void sound_volume(int, float) {}
void sound_pan(int, float) {}
void sound_global_volume(float) {}

// Input/window: no keyboard or window.
bool keyboard_check_direct(int) { return false; }
int window_get_cursor() { return 0; }

}  // namespace enigma_user
