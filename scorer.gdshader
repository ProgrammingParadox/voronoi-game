shader_type canvas_item;

uniform int   points = 100;
uniform float p_x[100];
uniform float p_y[100];
uniform float colors[100 * 4];

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	float min_dist = 100000.0;
	int   index    = -1;
	for(int i = 0; i < points; i++){
		float dist = distance(
			vec2(p_x[i], p_y[i]),
			UV
		);
		if(dist < min_dist) {
			min_dist = dist;
			index = i;
		}
	}
	
	// index = 1;
	
	COLOR = vec4(colors[index + 0], colors[index + 1], colors[index + 2], colors[index + 3]);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
