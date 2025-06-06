extends CharacterBody2D

@export var speed = 400
@export var acceleration: float = 1.0;

@export var color: Color = Global.COLOR_PALETTE[0];

@export var energy_regen = 20.0;

@export_category("references")
@export var seed_tscn : PackedScene
@export var laser_tscn : PackedScene
@export var wall_tscn : PackedScene

@export_category("controls")
@export var controls_up    : String; 
@export var controls_down  : String; 
@export var controls_left  : String; 
@export var controls_right : String; 
@export var controls_plant : String;
@export var controls_melee : String;
@export var controls_ranged: String = "player_1_shoot";
@export var build_wall     : String;

var max_energy: float = 100.0
var energy := 10.0

var screen_size 

var is_building_wall = false
var wall_start_pos = Vector2.ZERO
var current_wall = null
var wall_a = 0.2

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
	
func plant():
	var new_seed = seed_tscn.instantiate()
	add_sibling(new_seed)
	
	new_seed.position = self.position
	new_seed.color = color;
	
	parent.add_point(new_seed);

func wall_state(collision: bool, transperancy: float):
	var collision_shape = current_wall.get_child(0).get_child(0)
	var sprite = current_wall.get_child(0).get_child(1)
	var matter = sprite.get_material()
	matter.set_shader_parameter("wall_color", Global.COLOR_PALETTE[4])
	matter.set_shader_parameter("transp", transperancy)
	collision_shape.disabled = not collision

var initial_wall_energy = 0.0; # the energy the player has when they start building the wall
func start_wall_building():
	energy -= 20
	is_building_wall = true
	wall_start_pos = global_position
	current_wall = wall_tscn.instantiate()
	add_sibling(current_wall)
	wall_state(false, 0.5)
	
	current_wall.add_to_group("wall");
	
	current_wall.global_position = wall_start_pos
	
	initial_wall_energy = energy;

func finish_wall_building():
	wall_state(true, 1.0)
	is_building_wall = false
	current_wall = null
	wall_start_pos = Vector2.ZERO
	
func wall_update():
	var start_pos = current_wall.global_position
	# var distance = sqrt(((global_position.y - current_wall.global_position.y)**2)+((global_position.x - current_wall.global_position.x)**2))/6
	var distance = start_pos.distance_to(position)/6 # this does the same thing. Also, why 6?
	var angle = start_pos.angle_to_point(global_position)
	current_wall.rotation = angle
	current_wall.scale.x = distance
	
	energy = initial_wall_energy - distance / 3;
	
	if current_wall.scale.x < 2:
		current_wall.scale.x = 2
	


func dash(delta):
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
	
func shoot():
	var entities = get_tree().get_nodes_in_group("players");
		
	var min_dist = INF;
	var ref = null;
	for entity in entities:
		if entity == self:
			continue;
			
		var dist = entity.position.distance_to(position);
		if dist < min_dist:
			min_dist = dist;
			ref = entity;
			
	# var dir = position.direction_to(ref.position);
	
	var new_laser = laser_tscn.instantiate()
	add_sibling(new_laser)
	
	new_laser.shooter_ref = self;
	new_laser.target_ref = ref;
	
	new_laser.color = color.darkened(0.4);
	
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
		
		if !collider is StaticBody2D:
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
	
	energy += delta * energy_regen;
	if energy >= max_energy:
		energy = max_energy
		
	if Input.is_action_just_pressed(build_wall) and energy > 20 or (is_building_wall and (energy <= 0 or Input.is_action_just_pressed(build_wall))):
		if not is_building_wall:
			start_wall_building()
		else:
			finish_wall_building()
	
	if is_building_wall:
		wall_update()
	
	if Input.is_action_just_pressed(controls_plant) && energy > 20:
		plant()
		energy -= 20
	
	if Input.is_action_just_pressed(controls_melee) && energy > 10:
		dash(delta)
		energy -= 10
		
	if Input.is_action_just_pressed(controls_ranged) && energy > 80:
		shoot()
		energy -= 80
		
		


	
