shader_type canvas_item;


uniform float[4] player_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.

	COLOR = vec4(player_color[0] * 0.6, player_color[1] * 0.6, player_color[2] * 0.6, player_color[3] * 0.6);
	COLOR.a = texture(TEXTURE, UV).a;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
