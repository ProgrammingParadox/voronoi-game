extends CharacterBody2D

@export var speed = 400
@export var acceleration: float = 1.0;

var screen_size 

func resize():
	screen_size = get_viewport_rect().size

func _ready():
	screen_size = get_viewport_rect().size
	
	get_tree().get_root().size_changed.connect(resize)

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("ui_right"):
		velocity.x += acceleration
	if Input.is_action_pressed("ui_left"):
		velocity.x += -acceleration
	if Input.is_action_pressed("ui_down"):
		velocity.y += acceleration
	if Input.is_action_pressed("ui_up"):
		velocity.y += -acceleration
		
		
	#
		
	position += velocity * speed * delta
	
	var clamped = position.clamp(Vector2.ZERO, screen_size)
	if clamped != position:
		velocity *= -1
		
		position = clamped
	
	velocity *= 0.9;
