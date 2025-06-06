extends TextureRect

@export var percent = 0.5;
@export var filled_color: Color = Color(0, 0, 0);
@export var unfilled_color: Color = Color(255, 255, 255);
@export var bottom_border_size: float = 0.1;
@export var animate_smooth: bool = true;
@export var animation_speed: float = 0.05;

enum Direction {
	left_to_right,
	right_to_left
}

@export var direction: Direction = Direction.left_to_right;

var value = 0;
	
func _ready():
	filled_color   = Global.COLOR_PALETTE[1].darkened(0.2);
	unfilled_color = Global.COLOR_PALETTE[0].darkened(0.2);

func color_to_array(color: Color) -> Array[float]:
	return [color.r, color.g, color.b, color.a];

func _process(delta: float) -> void:
	if animate_smooth:
		value = value * (1 - animation_speed) + percent * animation_speed;
	else:
		value = percent
	
	#if direction == Direction.right_to_left:
		#material.set_shader_parameter("direction", 1);
	#else:
		#material.set_shader_parameter("direction", 0);
		
	material.set_shader_parameter("bottom_border_size", bottom_border_size);
	material.set_shader_parameter("percent", value);
	material.set_shader_parameter("filled_color", color_to_array(filled_color));
	material.set_shader_parameter("unfilled_color", color_to_array(unfilled_color));
	
	
