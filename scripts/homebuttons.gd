extends MarginContainer

@onready var pointer =  $Homepointer
@onready var play =     $VBoxContainer/Play
@onready var settings = $VBoxContainer/Settings
@onready var buttons =  $VBoxContainer.get_children()
var timer = 0.0
var curr_selection := 0
var original_game_time = Global.game_time
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	pointer.position = play.position
	print(buttons[0].global_position)
	print(pointer.global_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += 0.1
	pointer.global_position = Vector2(430 + 5 * sin(timer*0.8) ,buttons[curr_selection].global_position.y)
	
	for i in range(buttons.size()):
		if i == curr_selection:
			buttons[i].position.x = 20
		else:
			buttons[i].position.x = 0
	
func _on_play_mouse_entered() -> void:
	curr_selection = 0

func _on_settings_mouse_entered() -> void:
	curr_selection = 1

func _on_play_pressed() -> void:
	Global.game_time = original_game_time
	get_tree().paused = false
	#get_tree().change_scene_to_file("res://scenes/Game.tscn")
	
	Global.set_scene(Global.SCENES.BATTLE);
