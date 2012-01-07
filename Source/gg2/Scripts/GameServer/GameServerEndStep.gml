var i;
for(i=1; i<ds_list_size(global.players); i+=1)
{
    var player;
    player = ds_list_find_value(global.players, i);
    write_buffer(player.socket, global.eventBuffer);
    socket_send(player.socket);
}
buffer_clear(global.eventBuffer);
