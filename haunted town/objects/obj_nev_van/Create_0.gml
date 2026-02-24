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

function goto_new_dest() {
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
	
	show_debug_message("obj_nev_van CREATE: goto_new_dest(): target: "+string(_target.node_id)+" | node route:\n"+_debug_node_list);
}
	