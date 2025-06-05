extends Label

var display_num : String
var minutes : int
var seconds : int
@onready var timer = $Timer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start()
	seconds = Global.game_time


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	text = sec_to_cool(Global.game_time)

func _on_timer_timeout() -> void:
	Global.game_time -= 1

func sec_to_cool(seconds):
	var minutes := 0
	while seconds > 59:
		seconds -= 60
		minutes += 1
	if seconds > 9:
		return str(int(minutes))+":"+str(int(seconds))
	else:
		return str(int(minutes))+":0"+str(int(seconds))
		
