///@desc path to nearest circuit node

//current_state = "LEAVING_VAN";

// add our origin point to the path as a starting point
// paths need at least two points in order for the obj to move along it
path_add_point(my_path, x, y, 100);

// find nearest path circuit node to nev
var _node = instance_nearest(x, y, obj_node_circuit);

// add this nearest path circuit node pos to path
target_x = _node.x;
target_y = _node.y;
path_add_point(my_path, target_x, target_y, 100);

// store this node's x,y pos for later when pathing back to van
return_path_x = _node.x;
return_path_y = _node.y;

// modify path properties
path_set_closed(my_path, false);
path_set_kind(my_path, 0);

// start moving along the path
path_start(my_path, move_speed, path_action_stop, true);

show_debug_message("obj_nev ALARM[1]: started path to nearest circuit node. total points: "+string(path_get_number(my_path)));