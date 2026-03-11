// largely copied from obj_par_world_objects

//depth = y;

// button vars
mouse_hover = false;
clicked = false;
btn_confirmed = false;

// specific vars related to scary objects
cooldown_active = false;
deactivate_active = false;
locked = true;
haunted = false;
infamy = 0.0;
infamy_gain = 0.1;
cost = 10;

// assign normal & haunted sprites for this world object
sprite_normal = spr_so_phone;
sprite_haunted = spr_so_phone_haunted;

// radius in which npcs are scared by the object while haunted
scare_radius = 150;

// amount of fear to apply to scared npc
scare_amount = 1;

current_building = noone;

current_list = ds_list_create();
// for periodic check for collisions whilst haunted
check_interval = 60;
check_timer = check_interval;

cooldown_timer = 360;
cooldown_timer_init = cooldown_timer;
deactivate_timer = cooldown_timer / 2;
deactivate_timer_init = deactivate_timer;

// pie wheel config
pie_r1 = 4;
pie_r2 = 6;

function gain_infamy() {
	infamy += infamy_gain;
	infamy = clamp(infamy, 0, 1);
	//show_debug_message("infamy: "+string(infamy));
}

function check_for_npcs() {
	// note:	this was previously working inside the if (haunted) {} block in step event
	//			moving it here so that the collision checks are staggered and npcs don't
	//			always get spooked at the edge of the haunt_radius. seems to work for now
	
	var r = scare_radius;
	
	if (!ds_exists(current_list, ds_type_list)) {
		current_list = ds_list_create();
	}
	
	// clear the current list and find who is inside now
	ds_list_clear(current_list);
	
	var _num = collision_circle_list(x, y, r, obj_par_npc, false, true, current_list, false);

	// loop through npcs inside scare_radius
	for (var i = 0; i < ds_list_size(current_list); i++) {
	    var _inst = current_list[| i];
		
		if (_inst.visible) {
		    //_inst.scared = true;
				
			// make npc face the object
			if (_inst.x > x) {
				_inst.image_xscale = -1;
			} else {
				_inst.image_xscale = 1;
			}
				
			// this scary object gains infamy
			gain_infamy();
			
			// if the npc is not currently dying
			if (!_inst.dying) and (!_inst.possess_transition) and (!_inst.possessed) {
				// increase npc's fear
				_inst.increase_fear();
				
				//show_debug_message("obj_par_scary_object: "+string(_inst)+" is inside scare_radius and got scared!");
			}
				
			
		}
	}
}

function activate() {
	// make the clicked world object haunted
	sprite_index = sprite_haunted;
	haunted = true;
	// play sound (so turned haunted/activated)
	//...
	// visual feedback
	//...
	// immediate check for npcs inside scare_radius
	check_for_npcs();
}

function deactivate() {
	// reset to normal, or deactivate
	sprite_index = sprite_normal;
	haunted = false;

	// avoid memory leaks; forget all ids which entered/left while haunted
	ds_list_destroy(current_list);
	
	// play sound (so deactivated)
	//...
	// visual feedback
	//...
	
	show_debug_message("obj_par_world_objects CREATE: deactivate(): "+string(id));
}