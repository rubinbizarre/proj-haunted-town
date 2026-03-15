function scr_draw_infamy(infamy, radius){
	var _subimage = 0;
	if (infamy == 0) _subimage = 0;
	else if (infamy > 0) and (infamy <= 0.5) _subimage = 1;
	else if (infamy > 0.5) and (infamy < 1.0) _subimage = 2;
	else if (infamy >= 1.0) _subimage = 3;
	draw_sprite(spr_infamy, _subimage, x, y - (radius + 30));
}