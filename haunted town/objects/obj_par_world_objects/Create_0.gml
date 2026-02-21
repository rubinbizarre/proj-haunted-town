depth = y;

// button vars
mouse_hover = false;
clicked = false;
btn_confirmed = false;

// specific vars related to hauntable world objects
cooldown_active = false;
locked = false;
haunted = false;

// assign normal & haunted sprites for this world object
sprite_normal = spr_wo_trashcan;
sprite_haunted = spr_wo_trashcan_haunted;

// after untapping the object, how long to wait until player can tap it again
cooldown_timer = 360;
cooldown_timer_init = cooldown_timer;
// price (in HP) to unlock the object after Nev has locked it
unlock_price = 10;

// radius in which npcs are spooked by the object while haunted
haunt_radius = 50;

// pie wheel config
pie_r1 = 4;
pie_r2 = 6;