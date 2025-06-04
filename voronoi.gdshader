
// based on https://www.shadertoy.com/view/llG3zy
// with help from Claude :/
// (but mostly the code already up there)

shader_type canvas_item;

uniform float player_x = 0.0;
uniform float player_y = 0.0;

uniform int   points = 0;
uniform float p_x[100];
uniform float p_y[100];
uniform float colors[100 * 4];

const float border_width = 0.002;

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

void fragment(){
	vec2 pos = UV;

	// fist pass, voronoi
	vec2 mr;
	int closest = -1;
	float md = 8.0; // (max dist)
	for(int i = 0; i < points; i++){
		vec2 seed_pos = getPoint(i);
		vec2 r = seed_pos - pos;
		float d = dot(r, r); // (squared distance)

		if(d < md){
			md = d;
			mr = r;
			closest = i;
		}
	}

	// second pass, borders
	md = 8.0;
	vec3 closest_color = getColor(closest);

	for(int i = 0; i < points; i++){
		vec2 seed_pos = getPoint(i);
		vec2 r = seed_pos - pos;

		// Skip the same cell (closest seed)
		if(closest != i){
			vec3 other_color = getColor(i);

			// only border the same color
			if(closest_color == other_color){
				// distance to edge
				float border_dist = dot(0.5 * (mr + r), normalize(r - mr));
				md = min(md, border_dist);
			}
		}
	}

	vec3 color = getColor(closest);

	if(md < border_width){
		COLOR = vec4(color * 0.6, 1.0);
	} else {
		COLOR = vec4(color, 1.0);
	}
}

/*
// old, only by one human, and still understood completely by me

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

float distToBorder(vec2 p, vec2 a, vec2 b){
    vec2 mid = (a + b) / 2.0;
    float slope = (a.y - b.y) / (a.x - b.x);

    // prevent slope from being 0
    if(abs(slope) < 0.00001){
        slope = 0.00001;
    }

    // find the closest point to the border
    // tears were shed over these two lines
    float x = ((slope * ((slope*p.x) - p.y + mid.y)) + mid.x) / ((slope*slope) + 1.0);
    vec2 o = vec2(x, (x * slope) - (slope * p.x) + p.y);

    return distance(p, o);
}

vec2 getPoint(int i){
    return vec2(p_x[i], p_y[i]);
}

vec3 getColor(int i){
    int color_index = i * 4;
    return vec3(colors[color_index + 0], colors[color_index + 1], colors[color_index + 2]);
}

void findTwoClosest(vec2 pos, out int closest, out int second_closest, out float closest_boundary){
    float nearest_1 = 10000000.0;
    closest = -1;
    float nearest_2 = 10000000.0;
    second_closest = -1;
    float nearest_b = 10000000.0;
    int b = -1;
    for(int i = 0; i < points; i++){
        vec2 cur = getPoint(i);

        float dist = distance(cur, pos);

        //for(int j = 0; j < points; j++){
            //if(j == i) continue;
//
            //float bdist = distToBorder(pos, getPoint(i), getPoint(j));
            //if(bdist < nearest_b){
                //nearest_b = bdist;
            //}
        //}

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
    float closest_boundary;
    findTwoClosest(UV, closest, second_closest, closest_boundary);

    // write out their positions as vectors
    vec2 nearest_point      = getPoint(closest);
    vec2 next_nearest_point = getPoint(second_closest);

    // get the colors of the two closest seeds
    vec3 color_1 = getColor(closest);
    vec3 color_2 = getColor(second_closest);

    float dist = distToBorder(UV, nearest_point, next_nearest_point);

    // float dist = closest_boundary;

    //float nearest_b = 10000000.0;
    //int b = -1;
    //for(int i = 0; i < points; i++){
        //vec2 cur = getPoint(i);
//
        //for(int j = 0; j < points; j++){
            //if(j == i) continue;
//
            //float bdist = distToBorder(UV, getPoint(i), getPoint(j));
            //if(bdist < nearest_b){
                //nearest_b = bdist;
            //}
        //}
    //}

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
//    // Called for every pixel for every light affecting the CanvasItem.
//    // Uncomment to replace the default light processing function with this one.
//}

*/