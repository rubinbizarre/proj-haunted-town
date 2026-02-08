global.week_counter = 1;
global.minutes_per_day = 1440;				// 1,440 mins = 24 hours = 1 day
global.total_cycle_minutes = 10080;			// 10,080 mins = 68 hours = 7 days = 1 week
global.current_time_ = 450;//0;				// 480 mins / 60 mins = 8 hours = 8:00 AM

#region time_speed determines the speed at which time passes

// assuming that it is being multiplied by delta_time:
// --------------------------------------------------------------------------
// if time_speed = 5, current_time_ is incremented by ~0.75 every step
//	meaning that at 60fps it would take roughly 1 min to have 2700 mins in game = 45 hours in game = almost 2 full days in game
// if time_speed = 10, current_time_ is incremented by ~1.5 every step
//	meaning that at 60fps it would take roughly 1 min to have 5400 mins in game = 90 hours in game = almost 4 full days in game
// if time_speed = 20, current_time_ is incremented by ~3 every step
//	meaning that at 60fps it would take roughly 1 min to have 10800 mins in game = 180 hours in game = 7.5 days in game
// if time_speed = 40, current_time_ is incremented by ~6 every step
//	meaning that at 60fps it would take roughly 1 min to have 21600 mins in game = 360 hours in game = 15 days in game

//time_speed = 320; //80; //40; //5; //1;

// assuming that it is being multiplied by gamespeed_microseconds:
// --------------------------------------------------------------------------
// if time_speed = 1, current_time_ is incremented by 0.17 every step
//	@ 60fps: 1 sec real time = 10.2 mins in game
//			 1 min real time = 612 mins in game = 10.2 hours in game
//			 1 hour real time = 36720 mins in game = 612 hours in game = 25.5 days in game = 3.6 weeks

time_speed = 1;//40;
#endregion

// give us a value to modify during debugging that affects time_speed
time_speed_multiplier = 1;
time_speed_multiplier_init = time_speed_multiplier;