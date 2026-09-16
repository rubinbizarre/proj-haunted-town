part_sys_sweat = part_system_create(ps_sweat);
part_sys_spirals = part_system_create(ps_spirals);

// Get system info (only once)
var info_gain = part_system_get_info(part_sys_sweat);
var info_loss = part_system_get_info(part_sys_spirals);

//var _readable = json_stringify(info, true);
//show_message(_readable);

// Store emitter + parttype
em_sweat_1 = info_gain.emitters[0].ind;               // this is @ref particle_emitter(0)
pt_sweat_1 = info_gain.emitters[0].parttype.ind;      // this is @ref particle_type(3)
em_sweat_2 = info_gain.emitters[1].ind;
pt_sweat_2 = info_gain.emitters[1].parttype.ind;

em_spirals = info_loss.emitters[0].ind;               // this is @ref particle_emitter(0)
pt_spirals = info_loss.emitters[0].parttype.ind;

// set initial position
part_system_position(part_sys_gain, 0, 0);
part_system_position(part_sys_spirals, 0, 0);

// start disabled (0 particles per step)
part_emitter_stream(part_sys_sweat, em_sweat_1, pt_sweat_1, 0);
part_emitter_stream(part_sys_sweat, em_sweat_2, pt_sweat_2, 0);
part_emitter_stream(part_sys_spirals, em_spirals, pt_spirals, 0);

// start emitting
function start_sweat() {
	part_emitter_stream(part_sys_sweat, em_sweat_1, pt_sweat_1, 1);
	part_emitter_stream(part_sys_sweat, em_sweat_2, pt_sweat_2, 1);
}
function start_spirals() {
	part_emitter_stream(part_sys_spirals, em_spirals, pt_spirals, 1);
}

// stop emitting
function stop_sweat() {
    part_emitter_stream(part_sys_sweat, em_sweat_1, pt_sweat_1, 0);
	part_emitter_stream(part_sys_sweat, em_sweat_2, pt_sweat_2, 0);
}

function stop_spirals() {
	part_emitter_stream(part_sys_spirals, em_spirals, pt_spirals, 0);
}
