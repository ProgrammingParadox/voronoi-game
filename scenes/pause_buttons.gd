extends MarginContainer

@onready var pointer =  $Pointer
@onready var resume =   $VBoxContainer/Resume
@onready var settings = $VBoxContainer/Settings
@onready var quit =     $VBoxContainer/Quit
@onready var buttons = $VBoxContainer.get_children()
var timer = 0.0
var curr_selection := 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	pointer.position = resume.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += 0.1
	pointer.global_position = Vector2(430 + 5 * sin(timer*0.8) ,buttons[curr_selection].global_position.y)
	
	for i in range(buttons.size()):
		if i == curr_selection:
			buttons[i].position.x = 20
		else:
			buttons[i].position.x = 0
	

func _on_resume_mouse_entered() -> void:
	curr_selection = 0

func _on_settings_mouse_entered() -> void:
	curr_selection = 1

func _on_quit_mouse_entered() -> void:
	curr_selection = 2

func _on_resume_pressed() -> void:
	get_tree().paused = false
	get_tree().hide

func _on_settings_pressed() -> void:
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/home.tscn")
