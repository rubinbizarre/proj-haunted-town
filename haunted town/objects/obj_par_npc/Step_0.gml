// periodic routine check
if (check_timer-- <= 0) {
    check_timer = check_interval;
    event_user(0); // trigger routine logic
}

// animation & sprite flipping logic
if (path_index != -1) {
    // if moving, face the direction of movement
    image_xscale = (direction > 90 && direction < 270) ? -1 : 1;
    //sprite_index = spr_npc_walk;
} else {
    //sprite_index = spr_npc_idle;
}