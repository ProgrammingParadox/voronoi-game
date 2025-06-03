extends Label

@onready var thing1 = $"../VBoxContainer/Resume"
@onready var thing2 = $"../VBoxContainer/Settings"
@onready var thing3 = $"../VBoxContainer/Quit"
var timer = 0.0
var curr_selection := 1
var bounce = 15 * sin(timer*2) #bounce speed and size
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	position = thing1.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta
	if !get_tree().paused:
		curr_selection = 1
	if curr_selection == 1:
		get_node("../VBoxContainer/Resume").position.x = 10
		get_node("../VBoxContainer/Settings").position.x = 0
		get_node("../VBoxContainer/Quit").position.x = 0
		position.x = thing1.position.x + 15 * sin(timer*4)
		position.y = thing1.position.y
	elif curr_selection == 2:
		get_node("../VBoxContainer/Resume").position.x = 0
		get_node("../VBoxContainer/Settings").position.x = 10
		get_node("../VBoxContainer/Quit").position.x = 0
		position.x = thing2.position.x + 15 * sin(timer*4)
		position.y = thing2.position.y
	else:
		get_node("../VBoxContainer/Resume").position.x = 0
		get_node("../VBoxContainer/Settings").position.x = 0
		get_node("../VBoxContainer/Quit").position.x = 10
		position.x = thing3.position.x + 15 * sin(timer*4)
		position.y = thing3.position.y
	if Input.is_action_just_pressed("player_1_down"):
		curr_selection += 1
	elif Input.is_action_just_pressed("player_1_up"):
		curr_selection -= 1
	if curr_selection > 3:
		curr_selection = 1
	elif curr_selection < 1:
		curr_selection = 3


func _on_thing_1_mouse_entered() -> void:
	curr_selection = 1

func _on_thing_2_mouse_entered() -> void:
	curr_selection = 2

func _on_thing_3_mouse_entered() -> void:
	curr_selection = 3
