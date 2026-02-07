// increment current time by 1 * (1 or close enough to 1 depending on frame rate)
global.current_time_ += (delta_time / 1000000) * time_speed;

// loop the time back to zero after reaching a full week
if (global.current_time_ >= global.total_cycle_minutes) {
    global.current_time_ = 0;
}