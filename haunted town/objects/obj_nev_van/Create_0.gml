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

check_timer = irandom(360);//(60); // stagger routine checks
check_interval = 360;//60; // check routine every 1 sec at 60 fps

////image_alpha = 0.3;