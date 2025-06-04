extends CharacterBody2D

@export var speed = 400
@export var acceleration: float = 1.0;

@export var color: Color = Global.COLOR_PALETTE[0];

@export var seed_tscn : PackedScene

@export var controls_up    : String; 
@export var controls_down  : String; 
@export var controls_left  : String; 
@export var controls_right : String; 
@export var controls_plant : String;

var screen_size 

@onready var parent = get_node("/root/Node2D"); 

func resize():
	screen_size = get_viewport_rect().size

func _ready():
	screen_size = get_viewport_rect().size
	process_mode = Node.PROCESS_MODE_PAUSABLE
	
	resize()
	get_tree().get_root().size_changed.connect(resize)
	
	parent.add_point(self);

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed(controls_right):
		velocity.x += acceleration
	if Input.is_action_pressed(controls_left):
		velocity.x += -acceleration
	if Input.is_action_pressed(controls_down):
		velocity.y += acceleration
	if Input.is_action_pressed(controls_up):
		velocity.y += -acceleration
		
	if Input.is_action_just_pressed(controls_plant):
		var new_seed = seed_tscn.instantiate()
		add_sibling(new_seed)
		
		new_seed.position = self.position
		new_seed.color = color;
		
		parent.add_point(new_seed);
	
		
	position += velocity * speed * delta
	
	var clamped = position.clamp(Vector2.ZERO, screen_size)
	if clamped != position:
		velocity *= -1
		
		position = clamped
	
	velocity *= 0.9;
