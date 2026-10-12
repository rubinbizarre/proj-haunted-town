event_inherited();

// staggered turn-off and turn-on when global.night_light changes
if (light_change_timer > 0) {
    light_change_timer--;    
    if (light_change_timer == 0) {
        event_user(1);
    }
}