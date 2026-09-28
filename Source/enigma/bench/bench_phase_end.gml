// bench_phase_end(): append the phase's frame and logic times (ms) to the report.
var n;
n = max(global.bench_frames, 1);
global.bench_out += global.bench_phase + ": frames=" + string(global.bench_frames)
    + " frame_avg_ms=" + string(global.bench_sum / n / 1000)
    + " frame_max_ms=" + string(global.bench_max / 1000)
    + " logic_avg_ms=" + string(global.bench_logic / n / 1000) + chr(10);
global.bench_phase = "";
