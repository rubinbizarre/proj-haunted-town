/*
	NOTES

	there are 1440 minutes in a day. there are 720 minutes in half a day.
	if day_counter is an integer representing the day of the week, with Monday being 0:

		day_counter * 1440 = starting point of any given day (in minutes)

	there are 10,080 minutes in a week. this is the cut off point.
	after this time, current_time_ resets to zero and the routines cycle over again.
*/

global.routines = {
    kid: [
        { start: 0,    dest: 480,  state: "INSIDE" },
        { start: 480,  dest: 720,  state: "WANDER_TOWN" },
        { start: 720,  dest: 840,  state: "PLAY_PARK" },			// midday
        { start: 840,  dest: 1140, state: "WANDER_TOWN" },
        { start: 1140, dest: 1440, state: "RETURN_HOME" }				// before dark
    ],
	adult: [
        { start: 0,    dest: 510,  state: "INSIDE" },
        { start: 510,  dest: 780,  state: "WANDER_TOWN" },
        { start: 780,  dest: 1140, state: "WANDER_TOWN_AGAIN" },
        { start: 1140, dest: 1440, state: "RETURN_HOME" }				// before dark
    ],
    tourist: [ // for quick testing rn:
		{ start: 0,    dest: 480,  state: "INSIDE" },
		{ start: 480,  dest: 1440, state: "CIRCUIT" }
        //{ start: 1200, dest: 360,  state: "VISIT_HAUNTED" },		// night owls
        //{ start: 360,  dest: 1200, state: "AT_HOTEL" }
    ],
	elderly: [
		{ start: 0,    dest: 360,  state: "AT_HOME" },
		{ start: 360,  dest: 1020, state: "WANDER_TOWN" },
		{ start: 1020, dest: 1320, state: "AT_HOME" },
	]
};