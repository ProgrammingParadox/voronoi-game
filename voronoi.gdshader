shader_type canvas_item;

uniform float player_x = 0.0;
uniform float player_y = 0.0;

uniform int   points = 1;
uniform float p_x[100];
uniform float p_y[100];
uniform float colors[100 * 4];

const bool aa = false;

const float border_width = 0.002;
const float aa_width     = 0.0005;

void vertex() {
	// Called for every vertex the material is visible on.
}

vec2 getPoint(int i){
	return vec2(p_x[i], p_y[i]);
}

vec3 getColor(int i){
	int color_index = i * 4;
	return vec3(colors[color_index + 0], colors[color_index + 1], colors[color_index + 2]);
}

void findTwoClosest(vec2 pos, out int closest, out int second_closest){
	float nearest_1 = 10000000.0;
	closest = -1;
	float nearest_2 = 10000000.0;
	second_closest = -1;
	for(int i = 0; i < points; i++){
		vec2 cur = getPoint(i);

		float dist = distance(cur, pos);

		if(dist < nearest_1){
			nearest_2 = nearest_1;
			nearest_1 = dist;

			second_closest = closest;
			closest = i;
		} else if(dist < nearest_2) {
			nearest_2 = dist;
			second_closest = i;
		}
	}
}

void fragment(){
	// find two closest points... seeds?
	int closest, second_closest;
	findTwoClosest(UV, closest, second_closest);

	// write out their positions as vectors
	vec2 nearest_point      = getPoint(closest);
	vec2 next_nearest_point = getPoint(second_closest);

	// mid point, slope
	vec2 mid = (nearest_point + next_nearest_point) / 2.0;
	vec2 p = UV;
	float slope = (nearest_point.y - next_nearest_point.y) / (nearest_point.x - next_nearest_point.x);

	// prevent slope from being 0
	if(abs(slope) < 0.00001){
		slope = 0.00001;
	}

	// find the closest point to the border
	// tears were shed over these two lines
	float x = ((slope * ((slope*p.x) - p.y + mid.y)) + mid.x) / ((slope*slope) + 1.0);
	vec2 o = vec2(x, (x * slope) - (slope * p.x) + p.y);

	// get the colors of the two closest seeds
	vec3 color_1 = getColor(closest);
	vec3 color_2 = getColor(second_closest);

	float dist = distance(p, o);

	if(dist < border_width && color_1 == color_2){
		// COLOR = vec4(mix(color_1 * 0.6, color_1, dist / border_width), 1.0);
		COLOR = vec4(color_1 * 0.6, 1.0);
	} else if(aa && dist < aa_width){
		vec3 borderColor = mix(color_1, color_2, 0.5);

		COLOR = vec4(mix(borderColor, color_1, dist / aa_width), 1.0);
	} else {
		COLOR = vec4(color_1, 1.0);
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
