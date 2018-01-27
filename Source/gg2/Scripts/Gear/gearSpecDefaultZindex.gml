// Sets the z-index which will be used in all animation frames unless overridden.
// The z-index determines whern the gear will be drawn in relation to the base sprite and the other overlays.
// See draw_sprite_ext_overlay. Default is -20 to draw the gear in front of overlays and base sprite.

_gearSpecSet(argument0, _gearSpecDefaultTeamContext(TEAM_RED), "zindex", argument1);
_gearSpecSet(argument0, _gearSpecDefaultTeamContext(TEAM_BLUE), "zindex", argument1);
