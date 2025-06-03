extends Label

@onready var thing1 = $"../VBoxContainer/Thing1"
@onready var thing2 = $"../VBoxContainer/Thing2"
@onready var thing3 = $"../VBoxContainer/Thing3"


var offset = Vector2(-90,-10)
var timer := 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = thing1.global_position + offset


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += 0.1
	self.position.x += sin(timer)
	if Input.is_action_just_pressed("space"):
		var new_seed = seed_tscn.instantiate()


func _on_thing_1_mouse_entered() -> void:
	if !(position.y == thing1.global_position.y-10): 
		position = thing1.global_position + offset
	

func _on_thing_2_mouse_entered() -> void:
	if !(position.y == thing2.global_position.y-10): 
		position = thing2.global_position + offset
	
func _on_thing_3_mouse_entered() -> void:
	if !(position.y == thing3.global_position.y-10): 
		position = thing3.global_position + offset
	
