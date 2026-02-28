move_speed = 2;
move_speed_init = move_speed;

// set home_id to home node id
if (instance_exists(obj_node_nev_home)) {
	home_id = obj_node_nev_home;
} else {
	show_message("obj_nev_van CREATE:\nhome node not found");
}

// when created, set x,ypos to home_id x,y
x = home_id.x;
y = home_id.y;

my_path = path_add();
path_set_kind(my_path, 0);

current_state = "RETURN_HOME";//"PARKED";

target_x = 0;
target_y = 0;

scale_init = image_xscale;

check_timer = irandom(60);//(360);//(60); // stagger routine checks
check_interval = 60;//360;//60; // check routine every 1 sec at 60 fps

current_node = instance_nearest(x, y, obj_node_road);

//image_alpha = 0.2;

// FUNCTIONS
// -----------------------
function goto_new_dest() {
	current_state = "DRIVE_AND_STOP";
	
	// find a destination
	var _target = noone;
	do {
		_target = instance_find(obj_node_road, irandom(instance_number(obj_node_road) - 1));
	} until (_target != current_node);

	// get the node array which is the route to the destination from where we are (current_node)
	var _node_list = scr_find_path_nodes(current_node, _target);
	
	var _debug_node_list = "";
	
	if (array_length(_node_list) > 0) {
	    path_clear_points(my_path);
    
	    for (var i = 0; i < array_length(_node_list); i++) {
	        var _node = _node_list[i];
	        path_add_point(my_path, _node.x, _node.y, 100);
			
			_debug_node_list += string(_node.node_id) + ", ";
	    }

	    path_set_kind(my_path, 0); // travel in straight lines
	    path_set_closed(my_path, false); // do not loop back to start
    
	    // start moving
	    path_start(my_path, move_speed, path_action_stop, true);
    
	    // update our record of where we are
	    current_node = _target; 
	}
	
	//var output_node_list = "";
	//var add_to_output_node_list = function() {
	//	output_node_list += string(
	//}
	//array_foreach(_node_list, 
	
	show_debug_message("obj_nev_van CREATE: goto_new_dest(): target: "+string(_target.node_id)+" | node route: "+_debug_node_list);
}

function deploy_nev() {
	// nev's deploy position depends on the van orientation, gets out driver side always
	//	  - because we british innit the driver side will be the right-hand side of the van when
	//		looking at the back side of the van. ig this could change later if need be

	var _nev_x = 0;
	var _nev_y = 0;
	var _nev_depth = depth;
	var _offset_x = 56;//32*2;
	var _offset_y = 24;//16*2;
	
	// determine nev deploy pos and depth
	switch (sprite_index) {
		case spr_nev_van_side: {
			if (direction == 0) { // van facing right
				// nev gets out in front of the van and 'below' it
				_nev_depth = depth - 1;
				_nev_x = x + 25;
				_nev_y = y + 50;
			} else if (direction == 180) { // van facing left
				// nev gets out behind the van and 'above' it
				_nev_depth = depth + 1;
				_nev_x = x - 28;
				_nev_y = y - 12;
			//} else if (direction > 90 and direction < 270) { // van facing left
			//	// nev gets out behind the van and 'above' it
			//	_nev_depth = depth + 1;
			//	_nev_x = x - _offset_x;
			//	_nev_y = y - _offset_y;
			//} else if (direction > 180 and direction < 360) { // van facing right
			//	// nev gets out in front of the van and 'below' it
			//	_nev_depth = depth - 1;
			//	_nev_x = x + _offset_x;
			//	_nev_y = y + _offset_y;
			} else {
				show_message("obj_nev_van CREATE: deploy_nev():\nvan is sideways. direction not found.");
			}
		} break;
		case spr_nev_van_down: { // van facing down
			_nev_depth = depth + 1;
			_nev_x = bbox_left - sprite_get_width(spr_nev);//x - _offset_x;
			_nev_y = y + 40;//32;
		} break;
		case spr_nev_van_up: { // van facing up
			_nev_depth = depth - 1;
			_nev_x = bbox_right + sprite_get_width(spr_nev);//x + _offset_x;
			_nev_y = y;
		} break;
	}
	
	_nev_depth = depth - 1;
	
	// when nev gets out, he records his x,y pos to use later when pathing back to the van
	with instance_create_layer(_nev_x, _nev_y, "Instances", obj_nev) {
		depth = _nev_depth;
		return_van_x = _nev_x;
		return_van_y = _nev_y;
	}
	show_debug_message("obj_nev_van CREATE: deploy_nev(): deployed nev.");
}