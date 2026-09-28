// Gib benchmark: GameServer End Step. Uncaps the frame rate while measuring (after
// RateController's Begin Step reset it) and adds this step's logic time.
if (!variable_global_exists("bench_frame")) exit;
if (global.bench_phase == "") exit;
room_speed = 10000;
global.bench_logic += get_timer() - global.bench_logic_start;
