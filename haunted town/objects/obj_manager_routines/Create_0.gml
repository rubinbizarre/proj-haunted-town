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
        { start: 0,    dest: 480,  state: "INSIDE" }, // @ 0000
        { start: 480,  dest: 720,  state: "WANDER_TOWN" }, // @ 0800
        { start: 720,  dest: 840,  state: "PLAY_PARK" }, // @ 1200
        { start: 840,  dest: 1140, state: "WANDER_TOWN" }, // @ 1400
        { start: 1140, dest: 1440, state: "RETURN_HOME" } // @ 1900
    ],
	adult: [
        { start: 0,    dest: 510,  state: "INSIDE" }, // @ 0000
        { start: 510,  dest: 780,  state: "WANDER_TOWN" }, // @ 0830
        { start: 780,  dest: 1140, state: "WANDER_TOWN_AGAIN" }, // @ 1300
        { start: 1140, dest: 1440, state: "RETURN_HOME" } // @ 1900
    ],
	elderly: [
		{ start: 0,    dest: 600,  state: "INSIDE" }, // @ 0000
		{ start: 600,  dest: 720,  state: "WANDER_TOWN" }, // @ 1000
		{ start: 720 , dest: 900,  state: "RETURN_HOME" }, // @ 1200
		{ start: 900,  dest: 1080, state: "WANDER_TOWN" }, // @ 1500
		{ start: 1080, dest: 1440, state: "RETURN_HOME" } // @ 1800
	],
	tourist: [
		{ start: 0,	   dest: 360,  state: "VISIT_HAUNTED" }, // continue visit_haunted
		{ start: 360,  dest: 480,  state: "RETURN_HOME" }, // @ 0600
		{ start: 480,  dest: 1200, state: "INSIDE" }, // @ 0800
        { start: 1200, dest: 1260, state: "CIRCUIT" }, // @ 2000
		{ start: 1260, dest: 1800, state: "VISIT_HAUNTED" } // @ 2100
    ],
};

/* NOTE ABOUT TIME
maybe a solution to these crazy numbers is to limit time values to 1440, the # mins in a day.
when time reaches 1441, it resets to 0, but also a counter is incremented to recognise that we
are on a new day. in this way, routines can be the same for each npc for 6 days of the week,
and then on Sunday the routine can change because it can look to the day_counter to see that the
routine should be different. for example

	if (day_counter == Sunday) {
		// sunday routine
		adult = [
			{ ... }
		],
		etc ...
	} else {
		// normal routine
		adult = [
			{ ... }
		],
		etc ...
	}
*/