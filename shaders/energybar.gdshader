shader_type canvas_item;

uniform float percent = 0.5;
uniform vec4  filled_color   = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4  unfilled_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float bottom_border_size = 0.001;

const float shear = 0.92;

void fragment() {
	if(1.0 - UV.y < bottom_border_size){
		COLOR = vec4(percent < UV.x ? unfilled_color * 0.6 : filled_color * 0.6);

		// COLOR = vec4(0.0, 0.0, 0.0, 0.3);

		// COLOR = vec4(percent < UV.x ? unfilled_color * 0.6 : vec4(0.0, 0.0, 0.0, 0.3));
	} else {
		COLOR = vec4(percent < UV.x ? unfilled_color : filled_color);
	}

	if(UV.x > shear) COLOR.a = ((UV.x - shear) * (11.0) + UV.y) < sqrt(shear) ? COLOR.a : 0.0;
}
