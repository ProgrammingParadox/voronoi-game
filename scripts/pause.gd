extends Control

var is_paused = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		toggle_pause()

func toggle_pause():
	is_paused = !is_paused
	
	if is_paused:
		show()
		get_tree().paused = true
	else:
		hide()
		get_tree().paused = false

func _on_resume_pressed() -> void:
	toggle_pause()

func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/home.tscn");
