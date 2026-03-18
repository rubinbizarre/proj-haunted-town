#region create daily breakdown textbox
//var _tb = instance_create_layer(0, 0, "Master", obj_textbox);

//// lock it to read-only — no cursor, no input
//_tb.config.read_only = true;
////_tb.config.active    = false;

//// build and inject the summary text
//_tb.input_string = obj_textbox.build_summary_text();
//_tb.rebuild_lines();

//// store the reference so you can destroy it later
//global.tb = _tb;

//global.summary_box = instance_create_layer(0, 0, "Master", obj_summary_box);
////global.summary_box.load();

global.summary_box.toggle_display();
#endregion

