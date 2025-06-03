extends CharacterBody2D

@export var speed = 400
@export var acceleration: float = 1.0;

@export var seed_tscn : PackedScene

var screen_size 

func resize():
	screen_size = get_viewport_rect().size

func _ready():
	screen_size = get_viewport_rect().size
	
	get_tree().get_root().size_changed.connect(resize)

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("player_1_right"):
		velocity.x += acceleration
	if Input.is_action_pressed("player_1_left"):
		velocity.x += -acceleration
	if Input.is_action_pressed("player_1_down"):
		velocity.y += acceleration
	if Input.is_action_pressed("player_1_up"):
		velocity.y += -acceleration
		
	if Input.is_action_just_pressed("player_1_plant"):
		var new_seed = seed_tscn.instantiate()
		add_sibling(new_seed)
		new_seed.position = self.position
	#
		
	position += velocity * speed * delta
	
	var clamped = position.clamp(Vector2.ZERO, screen_size)
	if clamped != position:
		velocity *= -1
		
		position = clamped
	
	velocity *= 0.9;
