if (!global.paused) {
	// when not hovering over, disable clicked if it was active
	if (!mouse_hover) mouse_clicked = false;
}

if (mouse_hover) and ui_click_pressed() and !ui_over_any() {
	mouse_clicked = true;
	// play sound (mat pressed/clicked)
	//...
}

if (mouse_hover) and (mouse_clicked) and ui_click_released() {
	mouse_clicked = false;
	mouse_confirmed = true;
	// play sound (mat released/confirmed)
	//...
}

if (mouse_confirmed) {
	mouse_confirmed = false;
	if (global.building_view_inside) obj_master.toggle_view_inside();
}