move_speed = 3;//2*2;
move_speed_init = move_speed;

// set home_obj to home node id
if (instance_exists(obj_node_nev_home)) {
	home_obj = obj_node_nev_home;
} else {
	if (global.debug) show_message("obj_nev_van CREATE:\nhome node not found");
}

// when created, set x,ypos to home_obj x,y
x = home_obj.x;
y = home_obj.y;

my_path = path_add();
path_set_kind(my_path, 0);
path_set_closed(my_path, false);

current_state = "RETURN_HOME";//"PARKED";

target_x = 0;
target_y = 0;

scale_init = image_xscale;

check_timer = irandom(30);//(360);//(60); // stagger routine checks
check_interval = 30;//360;//60; // check routine every 1 sec at 60 fps

current_node = instance_nearest(x, y, obj_node_road);

target_stop_node = noone;

timer_deploy_nev_max = 1.25;
timer_deploy_nev_cur = -1;
timer_new_dest_max = 1;
timer_new_dest_cur = -1;

//image_alpha = 0.2;

// FUNCTIONS
// -----------------------
function goto_new_dest() {
	current_state = "DRIVE_AND_STOP";
	
	current_node = instance_nearest(x, y, obj_node_road); // necessary??? also assigned later differently
	
	#region find a destination, random obj_node_road inst that is not the nearest-node/current_node, working (commented)
	//var _target = noone;
	//do {
	//	_target = instance_find(obj_node_road, irandom(instance_number(obj_node_road) - 1));
	//} until (_target != current_node);
	#endregion
	
	#region //// find destination that is exclusively an intersection (commented)
	//var _target = noone;
	//var _count = array_length(global.intersections);
	//show_message("obj_nev_van CREATE: goto_new_dest():\naccessed global.intersections: "+string(_count)+" entries");
	//if (_count > 1) {
	//    // pick any intersection road node
	//    var _rand_index = irandom(_count - 1);
	//    _target = global.intersections[_rand_index];
	//    // if we accidentally picked the one we are sitting on, 
	//    // just move to the next index in the array (wrapping around)
	//    if (_target == current_node) {
	//        _rand_index = (_rand_index + 1) % _count;
	//        _target = global.intersections[_rand_index];
	//    }
	//	show_debug_message("obj_nev_van CREATE: goto_new_dest(): found destination intersection: "+string(_target.node_id));
	//}
	#endregion
	
	#region determine destination node considering infamous world objects as well as current_node
	/*
	find destination: a random obj_node_road that is not the nearest-node/current_node
	and also take into consideration the objects with infamy currently
	
	if there are objects with infamy
		put them into an array, sorted by infamy level
	*/
	
	// update the current node position
	current_node = instance_nearest(x, y, obj_node_road);

	// find all world objects with infamy and calculate the total sum
	var _total_infamy = 0;
	var _infamous_objects = [];

	with (obj_par_world_objects) { // works for world objects
	    if (infamy > 0) {
	        _total_infamy += infamy;
	        array_push(_infamous_objects, id);
	    }
	}
	with (obj_par_building) {
	    if (infamy > 0) {
	        _total_infamy += infamy;
	        array_push(_infamous_objects, id);
	    }
	}

	var _target = noone;
	//var _wander_chance = 0.10; // 10% chance to ignore infamy and just drive randomly

	// determine if the van should follow the infamy or wander
	if (_total_infamy > 0) {// and (random(1) > _wander_chance) {
	    // roulette wheel selection: higher infamy equals higher weight
	    var _roll = random(_total_infamy);
	    var _chosen_world_obj = noone;
    
	    for (var i = 0; i < array_length(_infamous_objects); i++) {
	        var _inst = _infamous_objects[i];
	        _roll -= _inst.infamy;
	        if (_roll <= 0) {
	            _chosen_world_obj = _inst;
	            break;
	        }
	    }
    
	    // find the road node closest to our selected high-infamy object
	    if (_chosen_world_obj != noone) {
	        _target = instance_nearest(_chosen_world_obj.x, _chosen_world_obj.y, obj_node_road);
			// play sound (nev detected some infamy)
			//...
			// visual feedback
			//...
			show_debug_message("obj_nev_van CREATE: goto_new_dest(): infamy found. targeting node closest to high-infamy object, node_id: "+string(_target.node_id));
	    }
	}

	// fallback: if there is no infamy, we rolled a wander, or the target node is where we already are
	if (_target == noone || _target == current_node) {
	    do {
	        _target = instance_find(obj_node_road, irandom(instance_number(obj_node_road) - 1));
	    } until (_target != current_node);
		show_debug_message("obj_nev_van CREATE: goto_new_dest(): no infamy found. targeting random node, node_id: "+string(_target.node_id));
	}

	//// apply the final destination node to the van navigation
	//target_node = _target;
	#endregion
	
	// get the node array which is the route to the destination from where we are (current_node)
	var _node_list = scr_find_path_nodes(current_node, _target);
	
	var _debug_node_list = "";
	
	if (array_length(_node_list) > 0) {
	    path_clear_points(my_path);
		
		// add each node in route to the target sequentially to the path
		// and provide debug output list of nodes in string format
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
	with instance_create_layer(_nev_x, _nev_y, "Master", obj_nev) {
		depth = _nev_depth;
		return_van_x = _nev_x;
		return_van_y = _nev_y;
	}
	show_debug_message("obj_nev_van CREATE: deploy_nev(): deployed nev.");
}

function redirect(_inst) {
	#region start a new path which goes from (current pos) -> (pivot node) -> (stop node)
	var _stop_node = instance_nearest(_inst.x, _inst.y, obj_node_road);
    
	// 1. find the (pivot node): which node was the van heading towards?
	// find this by looking at the road node nearest node in front of van (direction)
	var _pivot_node = instance_nearest(x + lengthdir_x(32, direction), y + lengthdir_y(32, direction), obj_node_road);

	// 2. build the new route from pivot to stop node
	var _nodes_to_stop = scr_find_path_nodes(_pivot_node, _stop_node);
				
	var _debug_node_list = "";
				
	if (array_length(_nodes_to_stop) > 0) {
		path_clear_points(my_path);
        
		// POINT 0: the anchor - current exact position prevents the JUMP
		path_add_point(my_path, x, y, 100);
        
		// POINT 1: the pivot - the node we were already heading toward
		path_add_point(my_path, _pivot_node.x, _pivot_node.y, 100);
        
		// POINTS 2+: the rest of the road nodes to the stop node
		for (var j = 1; j < array_length(_nodes_to_stop); j++) {
			path_add_point(my_path, _nodes_to_stop[j].x, _nodes_to_stop[j].y, 100);
			// provide debug output list of nodes/route in string format
			_debug_node_list += string(_nodes_to_stop[j].node_id) + ", ";
		}
        
		path_set_closed(my_path, false);
		path_set_kind(my_path, 0);
        
		// restart the path - because point 0 is current xypos, there is NO JUMP
		path_start(my_path, move_speed, path_action_stop, true);
        
		current_state = "DRIVE_AND_STOP";
		target_stop_node = _stop_node;
	}
	#endregion
}

function check_for_paranormal_van() {
	#region check for all detectable objects
	var _list = ds_list_create();
	var _num = collision_circle_list(x, y, global.nev_detect_radius, obj_par_detectable, false, true, _list, false);
		
	for (var i = 0; i < _num; i++) {
		var _inst = _list[| i];
		var _should_add = false;
			
		// now determine if the detected object should be added to the todo_queue
			
		// check for haunted world-objects
		if (object_is_ancestor(_inst.object_index, obj_par_world_objects)) {
			if (variable_instance_exists(_inst, "haunted")) {
				if (_inst.haunted) and (!array_contains(global.nev_todo_queue, _inst)) and (_inst != global.nev_current_target) and (!_inst.locked) {
					_should_add = true;
					show_debug_message("obj_nev_van CREATE: check_for_paranormal_van(): "+current_state+": adding haunted world-object: "+string(_inst.id));
				}
			}
		}
		// check for haunted buildings
		if (object_is_ancestor(_inst.object_index, obj_par_building)) {
			if (variable_instance_exists(_inst, "haunted")) {
				if (_inst.haunted) and (!array_contains(global.nev_todo_queue, _inst)) and (_inst != global.nev_current_target) and (_inst.stats.owned) {
					_should_add = true;
					show_debug_message("obj_nev_van CREATE: check_for_paranormal_van(): "+current_state+": adding haunted building: "+string(_inst.id));
				}
			}
		}
		// check for haunted scary-objects
		if (object_is_ancestor(_inst.object_index, obj_par_scary_objects)) {
			if (variable_instance_exists(_inst, "haunted")) {
				if (_inst.haunted) and (!array_contains(global.nev_todo_queue, _inst)) and (_inst != global.nev_current_target) and (!_inst.locked) {
					_should_add = true;
					show_debug_message("obj_nev_van CREATE: check_for_paranormal_van(): "+current_state+": adding haunted scary-object: "+string(_inst.id));
				}
			}
		}
		// check for possessed npcs
		if (object_is_ancestor(_inst.object_index, obj_par_npc)) {
			if (variable_instance_exists(_inst, "possessed")) {
				if (_inst.possessed) and (!array_contains(global.nev_todo_queue, _inst)) and (_inst != global.nev_current_target) {
					_should_add = true;
					show_debug_message("obj_nev_van CREATE: check_for_paranormal_van(): "+current_state+": adding possessed-npc: "+string(_inst.id));
				}
			}
		}
			
		/// if should add this object inst to the todo_queue, add it
		if (_should_add) {
			array_push(global.nev_todo_queue, _inst);
			redirect(_inst);
			show_debug_message("obj_nev_van CREATE: check_for_paranormal_van(): "+current_state+": pushed inst to todo_queue ("+string(array_length(global.nev_todo_queue))+" total): "+string(_inst.id));
		}
	}
	ds_list_destroy(_list);
	#endregion
}