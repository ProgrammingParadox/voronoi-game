shader_type canvas_item;

uniform vec4 laser_color = vec4(1.0, 0.0, 0.0, 1.0);

// 0 = searching, 1 = locked, 2 = firing
uniform int   laser_state = 0;
uniform float laser_progress = 0.0;

const float INV_PI = 1.0 / PI;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR = laser_color;

	if(laser_state == 0){
		COLOR.a = (abs(0.5 - UV.x) < 0.3 + (sin(laser_progress * PI * 2.0) * 0.05)) && (mod(UV.y * 1000.0, 100.0) < 50.0) ? 0.5 : 0.0;
	}
	if(laser_state == 1){
		COLOR.a = (abs(0.5 - UV.x) < 0.3) && (mod(UV.y * 1000.0, 100.0) < 50.0 + (laser_progress * laser_progress * 50.0)) ? 0.5 : 0.0;
	}
	if(laser_state == 2) {
		COLOR.a = abs(0.5 - UV.x) < sin(laser_progress * PI * 8.0) ? 1.0 : 0.0;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
