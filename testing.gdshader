shader_type canvas_item;

uniform float player_x = 0.0;
uniform float player_y = 0.0;

uniform int points = 100;
uniform float p_x[100];
uniform float p_y[100];
uniform float colors[100 * 4];

uniform float width = 0.001;

bool in_range(float a, float b, float range) {
	return a - range < b && a + range > b;
}

void vertex() {
	// Called for every vertex the material is visible on.
}

vec3 getColor(int i) {
	int color_index = i * 4;
	return vec3(colors[color_index + 0], colors[color_index + 1], colors[color_index + 2]);
}

void fragment(){
    //COLOR = vec4(UV, player_y, player_x);

	float nearest_1 = 100000.0;
	int   index_1 = -1;
	float nearest_2 = 100000.0;
	int   index_2 = -1;
	for(int i = 0; i < points; i++){
		vec2 pos = vec2(p_x[i], p_y[i]);

		float dist = distance(pos, UV);

		if(dist < nearest_1){
			nearest_2 = nearest_1;
			nearest_1 = dist;

			index_2 = index_1;
			index_1 = i;
		} else if(dist < nearest_2) {
			nearest_2 = dist;
			index_2 = i;
		}	
	}
	
	vec2 nearest_point = vec2(p_x[index_1], p_y[index_1]);
	vec2 next_nearest_point = vec2(p_x[index_2], p_y[index_2]);
	vec2 mid = (nearest_point + next_nearest_point) / 2.0;
	vec2 p = UV;
	float slope = (nearest_point.y - next_nearest_point.y) / (nearest_point.x - next_nearest_point.x);
	
	if(abs(slope) < 0.00001){
		slope = 0.00001;
	}
	
	// tears were shed over these two lines
	float x = ((slope * ((slope*p.x) - p.y + mid.y)) + mid.x) / ((slope*slope) + 1.0);
	vec2 o = vec2(x, (x * slope) - (slope * p.x) + p.y);
	
	//int ci_1 = index_1 * 4;
	//vec3 color_1 = vec3(colors[ci_1 + 0], colors[ci_1 + 1], colors[ci_1 + 2]);
	//int ci_2 = index_2 * 4;
	//vec3 color_2 = vec3(colors[ci_2 + 0], colors[ci_2 + 1], colors[ci_2 + 2]);
	
	vec3 color_1 = getColor(index_1);
	vec3 color_2 = getColor(index_2);
	
	if(distance(p, o) < 0.001 && color_1 == color_2){
		COLOR = vec4(color_1*0.8, 1.0);
	} else {
		COLOR = vec4(color_1, 1.0);
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
