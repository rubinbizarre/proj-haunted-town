enum NPC_STATE {
	IDLE,
	WALKING,
}

npc_state = NPC_STATE.WALKING;

state_timer = 0;
delay_idle = 2;
delay_walking = 3;

walk_speed = 0.25;

// parameters used in movement calculation
x_end = 0;
y_end = 0;
dir = 0;
dist = 0;

// movement ranges determine how far the npc moves when walking
// initialised here with default values but can be overwritten by each npc object individually
x_range_min = 20; x_range_max = 50;
y_range_min = 20; y_range_max = 50;

// set shadow parameters if drawing ellipse shadows in draw event
//shadow_width = 20;
//shadow_height = 5;

// set sprites for various states
// note: this may instead be changed to boolean flags, as it looks like
// most of the animation will be done with simple scale changes and tweens
//sprite_idle = sprite_index;
//sprite_walking = sprite_index;

