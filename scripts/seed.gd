extends Sprite2D

@export var color: Color;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	material.set_shader_parameter("player_color", [
		color.r,
		color.g,
		color.b,
		color.a
	]);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	material.set_shader_parameter("player_color", [
		color.r,
		color.g,
		color.b,
		color.a
	]);
