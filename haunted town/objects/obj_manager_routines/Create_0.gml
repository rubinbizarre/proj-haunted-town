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
		// DAY 1: MONDAY @ 0000
        { start: 0,    dest: 480,  state: "INSIDE" },
		// DAY 1: MONDAY @ 0800
        { start: 480,  dest: 720,  state: "WANDER_TOWN" },
		// DAY 1: MONDAY @ 1200
        { start: 720,  dest: 840,  state: "PLAY_PARK" },
		// DAY 1: MONDAY @ 1400
        { start: 840,  dest: 1140, state: "WANDER_TOWN" },
		// DAY 1: MONDAY @ 1900
        { start: 1140, dest: 1440, state: "RETURN_HOME" }
    ],
	adult: [
		// DAY 1: MONDAY @ 0000
        { start: 0,    dest: 510,  state: "INSIDE" },
		// DAY 1: MONDAY @ 0830
        { start: 510,  dest: 780,  state: "WANDER_TOWN" },
		// DAY 1: MONDAY @ 1300
        { start: 780,  dest: 1140, state: "WANDER_TOWN_AGAIN" },
		// DAY 1: MONDAY @ 1900
        { start: 1140, dest: 1440, state: "RETURN_HOME" }
    ],
    tourist: [
		// DAY 1: MONDAY @ 2000
        { start: 1200, dest: 1260, state: "CIRCUIT" },
		// DAY 1: MONDAY @ 2100
		{ start: 1260, dest: 1800, state: "VISIT_HAUNTED" },
		// DAY 2: TUESDAY @ 0600
        { start: 1800, dest: 2640, state: "RETURN_HOME" },
		// DAY 2: TUESDAY @ 2000
        { start: 2640, dest: 2700, state: "CIRCUIT" },
		// DAY 2: TUESDAY @ 2100
		{ start: 2700, dest: 3240, state: "VISIT_HAUNTED" },
		// DAY 3: WEDNESDAY @ 0600
        { start: 3240, dest: 4080, state: "RETURN_HOME" },
		// DAY 3: WEDNESDAY @ 2000
    ],
	elderly: [
		{ start: 0,    dest: 360,  state: "AT_HOME" },
		{ start: 360,  dest: 1020, state: "WANDER_TOWN" },
		{ start: 1020, dest: 1320, state: "AT_HOME" },
	]
};