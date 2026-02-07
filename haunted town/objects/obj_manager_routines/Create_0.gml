global.routines = {
    kid: [
        { start: 0,    dest: 480,  state: "AT_HOME" },
        { start: 480,  dest: 720,  state: "WANDER_VILLAGE" },
        { start: 720,  dest: 840,  state: "PLAY_PARK" },			// midday
        { start: 840,  dest: 1140, state: "WANDER_VILLAGE" },
        { start: 1140, dest: 1440, state: "AT_HOME" }				// before dark
    ],
    tourist: [
        { start: 1200, dest: 360,  state: "VISIT_HAUNTED" },		// night owls
        { start: 360,  dest: 1200, state: "AT_HOTEL" }
    ]
};