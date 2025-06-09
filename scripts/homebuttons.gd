extends CenterContainer

@onready var pointer =  $Homepointer
@onready var play =     $Play
@onready var buttons =  [play]
@onready var pos = buttons.map(func(x): return x.global_position);
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
	pointer.position = pos[curr_selection] + Vector2(-50 + 5 * sin(timer*0.8), 0)
	
	#var mv = Vector2(20, 0);
	#for i in range(buttons.size()):
		#if i == curr_selection:
			#buttons[i].position = pos[i] + mv;
		#else:
			#buttons[i].position = pos[i]
	
func _on_play_mouse_entered() -> void:
	curr_selection = 0

func _on_play_pressed() -> void:
	Global.game_time = original_game_time
	get_tree().paused = false
	#get_tree().change_scene_to_file("res://scenes/Game.tscn")
	
	Global.set_scene(Global.SCENES.CHAR_SELECT);
