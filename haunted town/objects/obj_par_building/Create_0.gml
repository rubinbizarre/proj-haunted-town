stats = {
    //fear: 0,
    infamy: 0.0,
    //danger: 0,
    owned: false,
    cost: 1,
};

//inside = {
//	so: [obj_so_phone],		// scary object(s)
//	occupants: []			// npcs currently inside
//}

occupants = [];
scary_objects = [
	{ obj: obj_so_phone, xpos: 27, ypos: 33 },
];

infamy_gain = 0.1;

// define clickable area around house
// entice_radius can be used in point_in_circle() function
entice_radius = sprite_width * 0.75;

// flag to track whether building was clicked on last
// when true, displays the building's resource levels
building_selected = noone;

mouse_confirmed = false;
mouse_clicked = false;
mouse_hover = false;

// animcurve parameters for animated look/feel
// the animcurve values go into scale modifications etc
ac_channel_hover = animcurve_get_channel(anim_building_hover, 0);
ac_time_hover = 0;
ac_speed_hover = 0.02;//0.01;

shrink_speed = 0.05;

// direction to access. essentially in what direction is the building accessed from.
// could think of it as "what direction does the building face the pavement?"
dir_to_access = "down"; // up, down, left or right. str because i can't deal with indexed values or 0-360 degrees on this one. i just can't.

sprite_interior = spr_inside_0_shack;
// for npc movement calcs while inside
interior_width = 320;
interior_height = 180;
//interior_x = 20000 + (building_index * 2000); 
interior_x = 20000; // assigned in obj_master ROOM_START event
interior_y = 0;
interior_obj = noone;
// assign each building a unique slot in the 'void'
building_index = 0; // assigned in obj_master ROOM_START event

// determine haunt difficulty rating based on which sprite
switch (sprite_index) {
	case spr_building_0_shack: {
		stats.cost = 1;
		sprite_interior = spr_inside_0_shack;
	} break;
	case spr_building_1_house: {
		stats.cost = 5;
		//sprite_interior = spr_inside_0_shack;
	} break;
	case spr_building_2_manor: {
		stats.cost = 10;
		//sprite_interior = spr_inside_0_shack;
	} break;
	case spr_building_church: {
		stats.cost = 50;
		//sprite_interior = spr_inside_0_shack;
	} break;
	case spr_building_hotel: {
		stats.cost = 30;
		//sprite_interior = spr_inside_0_shack;
	} break;
}

function spawn_scary_objects() {
	for (var i = 0; i < array_length(scary_objects); i++) {
	    var _so = scary_objects[i];
		var _x = interior_obj.x + _so.xpos;
		var _y = interior_obj.y - _so.ypos;
		var _obj = _so.obj;
		with instance_create_layer(_x, _y, "Scary_Objects", _obj) {
			current_building = id;
		}
	}
}