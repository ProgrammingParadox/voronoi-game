extends TextureRect

@export var percent = 0.5;
@export var filled_color: Color = Color(0, 0, 0);
@export var unfilled_color: Color = Color(255, 255, 255);
@export var bottom_border_size: float = 0.1;
@export var animate_smooth: bool = true;
@export var animation_speed: float = 0.05;

@export var player_reference: Node;

var value = 0;
	
func _ready():
	pass

func color_to_array(color: Color) -> Array[float]:
	return [color.r, color.g, color.b, color.a];

func _process(delta: float) -> void:
	value = value * (1 - animation_speed) + percent * animation_speed;
		
	material.set_shader_parameter("bottom_border_size", bottom_border_size);
	material.set_shader_parameter("percent", value);
	material.set_shader_parameter("filled_color", color_to_array(filled_color));
	material.set_shader_parameter("unfilled_color", color_to_array(unfilled_color));
	
	
