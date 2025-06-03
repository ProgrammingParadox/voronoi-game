extends Node2D

@onready var pausemenu = $PauseMenu

func _ready() -> void:
	pausemenu.hide()
	process_mode = Node.PROCESS_MODE_ALWAYS


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pause_menu()
		Global.paused = !Global.paused


func pause_menu():
	if Global.paused:
		pausemenu.hide()
		get_tree().paused = false
		#Engine.time_scale = 1
	if !Global.paused:
		get_tree().paused = true
		pausemenu.show()
		#Engine.time_scale = 0
