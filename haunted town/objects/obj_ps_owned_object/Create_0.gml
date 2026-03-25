part_sys = part_system_create(ps_owned_object);

// Get system info (only once)
var info_gain = part_system_get_info(part_sys);

//var _readable = json_stringify(info, true);
//show_message(_readable);

// Store emitter + parttype
em = info_gain.emitters[0].ind;               // this is @ref particle_emitter(0)
pt = info_gain.emitters[0].parttype.ind;      // this is @ref particle_type(3)

// Set initial position
part_system_position(part_sys, 0, 0);

// Start disabled (0 particles per step)
part_emitter_stream(part_sys, em, pt, 0);

// start emitting
function start() {
	part_emitter_stream(part_sys, em, pt, 1);
}

// stop emitting
function stop() {
    part_emitter_stream(part_sys, em, pt, 0);
}

function set_pos_depth(_x, _y, _depth) {
	part_system_position(part_sys, _x, _y);
	part_system_depth(part_sys, _depth);
}