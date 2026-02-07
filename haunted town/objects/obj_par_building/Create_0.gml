// Inside obj_building_parent Create Event
stats = {
    fear: 0,
    infamy: 0,
    danger: 0,
    is_haunted: false,
    haunt_difficulty: 1
};

// define clickable area around house
// click_radius can be used in point_in_circle() function
click_radius = sprite_width * 1.25;

// flag to track whether building was clicked on last
// when true, displays the building's resource levels
building_selected = noone;

mouse_confirmed = false;
mouse_clicked = false;
mouse_hover = false;

// animcurve parameters for animated look/feel
// the animcurve values go into scale modifications etc
ac_channel_hover = animcurve_get_channel(anim_building_hover, 0);
ac_time_hover = 0;
ac_speed_hover = 0.01;

shrink_speed = 0.05;

// direction to access. essentially in what direction is the building accessed from.
// could think of it as "what direction does the building face the pavement?"
dir_to_access = "down"; // up, down, left or right. str because i can't deal with indexed values or 0-360 degrees on this one. i just can't.