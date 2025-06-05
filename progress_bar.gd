extends ProgressBar

@onready var screen_size = DisplayServer.screen_get_size()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if get_parent().is_in_group("1st"):
		global_position = Vector2(0.0,43.0)
	else:
		global_position = Vector2(screen_size.x - size.x, 43.0)
