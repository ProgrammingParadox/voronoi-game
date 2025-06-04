shader_type canvas_item; 
uniform sampler2D t: hint_screen_texture, filter_linear_mipmap;

void fragment(){
	// COLOR = vec4(textureLod(t, SCREEN_UV, 2.0).rgb, 1.0);
	
	COLOR = texture(TEXTURE, UV) * 0.6;
}