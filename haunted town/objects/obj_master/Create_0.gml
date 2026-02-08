//randomise();

global.debug = true;

global.hud = true;
global.haunt_power = 0;

global.hour_progress_multiplier = 100 / 60; // used in script for finding date and time to convert hour_progression to actual_minutes

//global.town_grid = mp_grid_create(0, 0, 96, 54, 20, 20);
global.town_grid = mp_grid_create(0, 0, 32, 18, 60, 60);