shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
    vec2 center = vec2(0.5); // Center of the mask
    float radius = 0.5; // Normalized radius (0.5 fills the viewport)

    float dist = distance(UV, center);
    if (dist > radius) {
        discard; // Hide pixels outside the circle
    }
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
