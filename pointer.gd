extends Label

@onready var thing1 = $"../VBoxContainer/Thing1"
@onready var thing2 = $"../VBoxContainer/Thing2"
@onready var thing3 = $"../VBoxContainer/Thing3"

var curr_selection := 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = thing1.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if curr_selection == 1:
		get_node("../VBoxContainer/Thing1").position.x = 10
		get_node("../VBoxContainer/Thing2").position.x = 0
		get_node("../VBoxContainer/Thing3").position.x = 0
		position = thing1.position
	elif curr_selection == 2:
		get_node("../VBoxContainer/Thing1").position.x = 0
		get_node("../VBoxContainer/Thing2").position.x = 10
		get_node("../VBoxContainer/Thing3").position.x = 0
		position = thing2.position
	else:
		get_node("../VBoxContainer/Thing1").position.x = 0
		get_node("../VBoxContainer/Thing2").position.x = 0
		get_node("../VBoxContainer/Thing3").position.x = 10
		position = thing3.position
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
