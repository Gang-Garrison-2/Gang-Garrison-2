// Gib benchmark (build.sh --bench; run with -dedicated -map <map> [-benchplayers N]).
// Called at the start of GameServer's Begin Step. Spawns N soldiers near the view,
// kills them all by rocket (gibs), and writes frame timings to bench.txt.
var t, k, p, cx, cy, n;
t = get_timer();
if (!variable_global_exists("bench_frame"))
{
    global.bench_frame = 0;
    global.bench_n = 16;
    for (k = 1; k <= parameter_count(); k += 1)
        if (parameter_string(k) == "-benchplayers")
            global.bench_n = real(parameter_string(k + 1));
    global.bench_last = t;
    global.bench_list = ds_list_create();
    global.bench_out = "players=" + string(global.bench_n) + chr(10);
    global.bench_phase = "";
}
global.bench_frame += 1;

// Frame time of the previous frame (Begin Step to Begin Step, uncapped).
if (global.bench_phase != "")
{
    global.bench_sum += t - global.bench_last;
    global.bench_max = max(global.bench_max, t - global.bench_last);
    global.bench_frames += 1;
}
global.bench_last = t;

if (global.bench_frame == 60)
{
    // Spawn around the view centre: gibs only spawn within 900 px of it.
    cx = view_xview[0] + view_wview[0] / 2;
    cy = view_yview[0] + view_hview[0] / 2;
    if (view_wview[0] == 0) { cx = room_width / 2; cy = room_height / 2; }
    n = global.bench_n;
    for (k = 0; k < n; k += 1)
    {
        p = instance_create(0, 0, Player);
        p.name = "bench" + string(k);
        p.team = k mod 2;
        p.class = CLASS_SOLDIER;
        with (p) PlayerSpawn();
        if (p.object != -1) { p.object.x = cx + (k - n / 2) * 12; p.object.y = cy; }
        ds_list_add(global.bench_list, p);
    }
}

if (global.bench_frame == 90) bench_phase_start("idle");
if (global.bench_frame == 210)
{
    bench_phase_end();
    global.bench_out += "gibs_before=" + string(instance_number(Gib)) + chr(10);
    for (k = 0; k < ds_list_size(global.bench_list); k += 1)
    {
        p = ds_list_find_value(global.bench_list, k);
        if (p.object != -1) doEventPlayerDeath(p, noone, noone, DAMAGE_SOURCE_ROCKETLAUNCHER);
    }
    global.bench_out += "gibs=" + string(instance_number(Gib)) + " blood=" + string(instance_number(BloodDrop))
        + " instances=" + string(instance_count) + chr(10);
    bench_phase_start("gibs");
}
if (global.bench_frame == 510)
{
    bench_phase_end();
    var f;
    f = file_text_open_write(working_directory + "/bench.txt");
    file_text_write_string(f, global.bench_out);
    file_text_close(f);
    game_end();
}
global.bench_logic_start = get_timer();
