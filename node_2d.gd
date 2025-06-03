extends Node2D

@onready var pausemenu = $PauseMenu
var paused = false

func _ready() -> void:
	pausemenu.hide()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pause_menu()
		paused = !paused


func pause_menu():
	if paused:
		pausemenu.hide()
		Engine.time_scale = 1
	if !paused:
		pausemenu.show()
		Engine.time_scale = 0
