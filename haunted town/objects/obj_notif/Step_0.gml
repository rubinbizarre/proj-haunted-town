//ascend
y -= ascent_speed;

////determine color
//if (amount == 100) {
//	c = c_aqua;
//} else {
//	c = c_yellow;
//}

//fade out
if (fading) {
	if (alpha > 0) {
		alpha -= fade_speed;
	} else {
		instance_destroy();
	}
}