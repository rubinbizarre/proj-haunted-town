if (mouse_hover) {
	// when hovering over
	//...
} else {
	// when not hovering over
	//...
	
	// disable clicked if it was active
	if (clicked) clicked = false;
}

if (mouse_hover) and ui_click_pressed() and !ui_over_any() {
	clicked = true;
	// play sound (mouse click button)
	//...
}

if (mouse_hover) and (clicked) and ui_click_released() {
	clicked = false;
	mouse_hover = false;
	// play sound (button released/confirmed)
	//...
	btn_confirmed = true;
}

if (btn_confirmed) {
	//switch (sprite_index) {
		//...
	//}
	btn_confirmed = false;
}