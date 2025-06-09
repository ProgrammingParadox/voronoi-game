extends Control


func set_game_time(seconds):
	Global.game_time = seconds;
	
func start_game():
	get_tree().paused = false
	Global.curr_game_time = Global.game_time
	Global.set_scene(Global.SCENES.BATTLE);

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var m = get_node("music")
	m.set_cur(m.audio.OVER);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
