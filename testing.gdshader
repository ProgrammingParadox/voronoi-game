shader_type canvas_item;

uniform float player_x = 0.0;
uniform float player_y = 0.0;

uniform int points = 100;
uniform float p_x[100];
uniform float p_y[100];
uniform float colors[100 * 4];

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment(){
    //COLOR = vec4(UV, player_y, player_x);

	float dmin = 100000.0;
	int j = -1;
	for(int i = 0; i < points; i++){
		vec2 pos = vec2(p_x[i], p_y[i]);

		float dist = distance(pos, UV);

		if(dist < dmin){
			dmin = dist;

			j = i;
		}
	}

	if(dmin < 0.01){
		COLOR = vec4(0.5, 0.5, 0.5, 1.0);
	} else {
		int ci = j * 4;
		COLOR = vec4(colors[ci + 0], colors[ci + 1], colors[ci + 2], 1.0);
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
