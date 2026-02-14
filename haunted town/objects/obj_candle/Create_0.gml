//candle_frame = irandom_range(0, 2);
image_index = irandom_range(0, 2);//candle_frame;
image_xscale = 5;
image_yscale = 5;

// determine flame height based on image_index
flame_height = 0;
switch (image_index) {
	case 0: { flame_height = y - sprite_height - (1 * image_xscale);	} break;
	case 1: { flame_height = (y - sprite_height + (1 * image_xscale)); } break;
	case 2: { flame_height = (y - sprite_height + (3 * image_xscale)); } break;
}

flame_inst = instance_create_layer(x, flame_height, "Candles", obj_flame);
flame_inst.image_xscale = image_xscale;
flame_inst.image_yscale = image_yscale;