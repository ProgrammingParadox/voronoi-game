shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}
uniform float transp = 1.0;
uniform vec3 wall_color;

void fragment() {
	COLOR = vec4(wall_color, transp);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
