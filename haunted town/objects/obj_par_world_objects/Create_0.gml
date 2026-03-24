depth = -y;

// button vars
mouse_hover = false;
clicked = false;
btn_confirmed = false;

// specific vars related to hauntable world objects
deactivate_active = false;
cooldown_active = false;
locked = true;
haunted = false;
infamy = 0.0;
infamy_gain = 0.1;

// assign normal & haunted sprites for this world object
sprite_normal = spr_wo_trashcan;
sprite_haunted = spr_wo_trashcan_haunted;

// after untapping the object, how long to wait until
//	- it turns off or resets
//	- player can tap it again
cooldown_timer = 360;
cooldown_timer_init = cooldown_timer;
deactivate_timer = cooldown_timer / 2;
deactivate_timer_init = deactivate_timer;

cost = 10; // price (in HP) to unlock the object after Nev has locked it

// radius in which npcs are spooked by the object while haunted
haunt_radius = 50;
// ds_list for storing collided npc ids whilst haunted
current_list = ds_list_create();
last_list = ds_list_create();
// stagger checks for collisions whilst haunted
check_timer = irandom(60);
check_interval = 60;

// pie wheel config
pie_r1 = 4;
pie_r2 = 6;

escrow = 0;
escrow_display = 0;
escrow_display_strength = 0.01;
escrow_stolen = false;

draw_haunt_outline = false;

nev_taking_escrow = false; // flag to use so that escrow is still drawn whilst nev is 'surveying'

disabled = false; // activated when nev has poltergust and interacts

name_str = "unnamed-wo"; // name of obj that appears in daily breakdown
note_str_credit = "note-credit";
note_str_discredit = "note-discredit";

timer_deactivate_max = 3;
timer_deactivate_cur = -1;
timer_cooldown_max = 6;
timer_cooldown_cur = -1;

function gain_infamy() {
	infamy += infamy_gain;
	infamy = clamp(infamy, 0, 1);
	//show_debug_message("infamy: "+string(infamy));
}

function check_for_npcs() {
	// note:	this was previously working inside the if (haunted) {} block in step event
	//			moving it here so that the collision checks are staggered and npcs don't
	//			always get spooked at the edge of the haunt_radius. seems to work for now
	
	var r = haunt_radius;
	
	if (!ds_exists(current_list, ds_type_list)) {
		current_list = ds_list_create();
	}
	if (!ds_exists(last_list, ds_type_list)) {
		last_list = ds_list_create();
	}
	
	// 1 // clear the current list and find who is inside now
	ds_list_clear(current_list);
	
	var _num = collision_circle_list(x, y, r, obj_par_npc, false, true, current_list, false);

	// 2 // find 'new entries' (in current_list ONLY, not in last_list)
	for (var i = 0; i < ds_list_size(current_list); i++) {
	    var _inst = current_list[| i];
    
	    // if they weren't here last frame, they just ENTERED
	    if (ds_list_find_index(last_list, _inst) == -1) {
			// spook the npc if they are visible, i.e. not inside a building
			if (_inst.visible) {
		        _inst.spooked = true;
				// store npc current xscale
				_inst.prev_xscale = image_xscale;
				// make npc face the object
				if (_inst.x > x) {
					_inst.image_xscale = -1;
				} else {
					_inst.image_xscale = 1;
				}
				
				// increment our world object's escrow (+1 HP)
				escrow++;
				// this world object gains infamy
				gain_infamy();
				
				//show_debug_message("Target " + string(_inst) + " Entered!");
			}
	    }
	}
	
	// 3 // find 'exits' (in last_list ONLY, not in current_list)
	for (var i = 0; i < ds_list_size(last_list); i++) {
	    var _inst = last_list[| i];
		
	    // if they were here last frame but aren't now, they just LEFT
	    if (ds_list_find_index(current_list, _inst) == -1) {
	        if (instance_exists(_inst)) {
	            //_inst.spooked = false; // reset the trigger
	            //show_debug_message("Target " + string(_inst) + " Left!");
	        }
	    }
	}
	
	// 4 // update the memory for the next frame
	ds_list_copy(last_list, current_list);
}

function activate() {
	// make the clicked world object haunted
	sprite_index = sprite_haunted;
	haunted = true;
	// play sound (wo turned haunted/activated)
	//...
	// visual feedback
	//...
}

function deactivate() {
	// reset to normal, or deactivate
	sprite_index = sprite_normal;
	haunted = false;

	// avoid memory leaks; forget all ids which entered/left while haunted
	ds_list_destroy(current_list);
	ds_list_destroy(last_list);
	
	// play sound (wo deactivated)
	//...
	// visual feedback
	//...
	
	show_debug_message("obj_par_world_objects CREATE: deactivate(): "+string(id));
}