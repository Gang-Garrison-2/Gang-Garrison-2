
var i, player;

player = ds_list_find_value(global.players, global.playerID);

if (player.team != TEAM_SPECTATOR)
{
    var existed;
    
    existed = 0;
    
    if (instance_exists(BubbleMenuZ)) with (BubbleMenuZ) instance_destroy();
    if (instance_exists(BubbleMenuC)) with (BubbleMenuC) instance_destroy();
    if (instance_exists(BubbleMenuX))
    {
        BubbleMenuX.done = true;
        existed = 1;        
    }
    if (existed == 0)
    {
        instance_create(x,y,BubbleMenuX);    
    }         
    else
    {
        BubbleMenuX.done = true;    
    }
}
