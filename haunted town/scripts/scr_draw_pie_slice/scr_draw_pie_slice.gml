/// @function					draw_pie_slice(cx, cy, r1, r2, angle1, angle2, col);
/// @param {real} cx            X position of the centre of the pie slice
/// @param {real} cy            Y position of the centre of the pie slice
/// @param {real} r1            Inner radius (0 for a full pie slice, >0 for a ring segment)
/// @param {real} r2            Outer radius of the pie slice
/// @param {real} angle1        Starting angle in degrees
/// @param {real} angle2        Ending angle in degrees
/// @param {int}  col           Colour used to draw the pie slice
/// @description
/// Draws a filled pie or ring slice using a triangle strip primitive.
/// The slice is drawn from angle1 to angle2 in degrees, between the
/// inner radius r1 and outer radius r2, allowing for doughnut-style
/// segments as well as full pie wedges.

function draw_pie_slice(cx, cy, r1, r2, angle1, angle2, col) {
	// Calculate how many segments to use to approximate the curve.
    // More steps = smoother curve.
    // The slice span is divided roughly into 4-degree chunks,
    // with a minimum of 6 steps to avoid sharp edges.
    var steps = max(6, (angle2 - angle1) div 4);
	
	// Amount to increment the angle per step
    var angle_step = (angle2 - angle1) / steps;
	
	// Begin drawing a triangle strip primitive, which allows us
    // to efficiently build a filled curved shape using paired vertices
    draw_primitive_begin(pr_trianglestrip);
	
	// Set the drawing colour for all vertices in this primitive
    draw_set_color(col);
	
	// Loop through each step along the arc
    for (var i = 0; i <= steps; i++) {
		// Current angle in degrees for this step
        var a = angle1 + i * angle_step;
		
		// --- ANGLE ADJUSTMENT ---
        // GameMaker's 0° points to the right (3 o'clock).
        // Add 90° so that 0° points upward (12 o'clock),
        // which is more intuitive for pie charts and UI elements.
        var adj_angle = a + 90;

		// Calculate cosine and sine for the adjusted angle
        // dcos and dsin expect degrees
		var cos_a = dcos(adj_angle);
		var sin_a = -dsin(adj_angle);

        // Outer vertex: point on the outer radius of the slice
        draw_vertex(cx + cos_a * r2, cy + sin_a * r2);
        // Inner vertex: point on the inner radius
        // If r1 is 0, this collapses to the centre point, creating a solid pie wedge
        draw_vertex(cx + cos_a * r1, cy + sin_a * r1);
    }
	
	// Finish the primitive and send it to the GPU
    draw_primitive_end();
}