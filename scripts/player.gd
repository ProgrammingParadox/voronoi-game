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
@export var controls_melee : String;

var screen_size 

@onready var parent = get_node("/root/Node2D"); 

func resize():
	screen_size = get_viewport_rect().size

func _ready():
	add_to_group("entity")
	add_to_group("players")
	
	screen_size = get_viewport_rect().size
	process_mode = Node.PROCESS_MODE_PAUSABLE
	
	resize()
	get_tree().get_root().size_changed.connect(resize)
	
	parent.add_point(self);

func _physics_process(delta: float) -> void:
	get_node("AnimatedSprite2D").material.set_shader_parameter("color", [color.r * 0.6, color.g * 0.6, color.b * 0.6, color.a]);
	
	if Input.is_action_pressed(controls_right):
		velocity.x += acceleration
	if Input.is_action_pressed(controls_left):
		velocity.x += -acceleration
	if Input.is_action_pressed(controls_down):
		velocity.y += acceleration
	if Input.is_action_pressed(controls_up):
		velocity.y += -acceleration
		
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		var collider = collision_info.get_collider();
		
		collider.velocity = velocity;
		
		velocity = velocity.bounce(collision_info.get_normal())
		
	# position += velocity * speed * delta
	
	var clamped = position.clamp(Vector2.ZERO, screen_size)
	if clamped != position:
		var normal = clamped - position;
		normal = normal.normalized();
		
		velocity = velocity - (2 * velocity.dot(normal) * normal)
		
		position = clamped
	
	velocity *= 0.9;
	
	if Input.is_action_just_pressed(controls_plant):
		var new_seed = seed_tscn.instantiate()
		add_sibling(new_seed)
		
		new_seed.position = self.position
		new_seed.color = color;
		
		parent.add_point(new_seed);
		
	if Input.is_action_just_pressed(controls_melee):
		var entities = get_tree().get_nodes_in_group("entity");
		
		var min_dist = INF;
		var ref = null;
		for entity in entities:
			if entity == self:
				continue;
				
			var dist = entity.position.distance_to(position);
			if dist < min_dist:
				min_dist = dist;
				ref = entity;
				
		var dir = position.direction_to(ref.position);
		
		velocity = dir * 1000;
				
			
		var collision = move_and_collide(velocity * delta);
