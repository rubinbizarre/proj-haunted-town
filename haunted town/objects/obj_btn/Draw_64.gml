if (room != rm_main) exit;

var _x = room_width/2;
var _y = room_height/2;
//var _x = display_get_width()/2;
//var _y = display_get_height()/2;

var _scale = 4;

if (clicked) {
	//draw_sprite_ext(sprite_index, image_index, x, y, _scale, _scale, image_angle, c_white, 0.5);
	draw_sprite_ext(sprite_index, image_index, _x, _y, _scale, _scale, image_angle, c_white, 0.5);
} else {
	//draw_sprite_ext(sprite_index, image_index, x, y, _scale, _scale, image_angle, c_white, 1);
	draw_sprite_ext(sprite_index, image_index, _x, _y, _scale, _scale, image_angle, c_white, 1);
}