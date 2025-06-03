extends Sprite2D

@export var player_color: Color;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	material.set_shader_parameter("player_color", [
		player_color.r,
		player_color.g,
		player_color.b,
		player_color.a
	]);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	material.set_shader_parameter("player_color", [
		player_color.r,
		player_color.g,
		player_color.b,
		player_color.a
	]);
