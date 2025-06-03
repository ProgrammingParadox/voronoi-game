extends Label

@onready var play = $"../VBoxContainer/Play"
@onready var settings = $"../VBoxContainer/Settings"
var curr_selection := 1
var timer := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta
	if curr_selection == 1:
		get_node("../VBoxContainer/Play").position.x = 10
		get_node("../VBoxContainer/Settings").position.x = 0
		position.x = play.position.x + 15 * sin(timer*4)
		position.y = play.position.y
		if Input.is_action_just_pressed("enter"):
			get_tree().change_scene_to_file("res://scenes/Game.tscn")
			
	elif curr_selection == 2:
		get_node("../VBoxContainer/Play").position.x = 0
		get_node("../VBoxContainer/Settings").position.x = 10
		position.x = settings.position.x + 15 * sin(timer*4)
		position.y = settings.position.y
	if Input.is_action_just_pressed("player_1_down") or Input.is_action_just_pressed("player_2_down"):
		curr_selection += 1
	elif Input.is_action_just_pressed("player_1_up") or Input.is_action_just_pressed("player_2_up"):
		curr_selection -= 1
	if curr_selection > 2:
		curr_selection = 1
	elif curr_selection < 1:
		curr_selection = 2


func _on_play_mouse_entered() -> void:
	curr_selection = 1


func _on_settings_mouse_entered() -> void:
	curr_selection = 2
	

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Game.tscn"); # ll need to make character select when char select is made
