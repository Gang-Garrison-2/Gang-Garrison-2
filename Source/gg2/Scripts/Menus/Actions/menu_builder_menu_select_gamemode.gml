// BuilderMenuController: menu_addlink
var builder;
if (!instance_exists(Builder)) builder = instance_create(0,0, Builder);
else builder = Builder.id;

builder.gamemode = power(2, virtualitem);
builder.name = item_name[virtualitem];

if (room != BuilderRoom) room_goto_fix(BuilderRoom);
else {
    with(Builder) event_user(0);
    instance_destroy();
}
