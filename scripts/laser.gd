extends TextureRect

@export var wall_tscn: PackedScene;

# 0 = searching, 1 = locked, 2 = firing
var state = 0;
var laser_progress = 0.0;

var color = Color(1.0, 0.0, 0.0, 1.0);

var target_ref;
var target_pos;
var shooter_ref;

@onready var tween = create_tween()

# more math from Claude. I don't understand where he gets all the info,
# but I understand usually how it works
func get_shape(size_scale = 1.0):
	scale = scale * size_scale;
	var shape = get_node("Area2D/CollisionShape2D").shape;
	scale = scale / size_scale;
	
	return shape

func get_edges(size_scale = 1.0):
	var shape = get_node("Area2D/CollisionShape2D").shape
	
	#scale = scale * size_scale
	var transform = get_global_transform() 
	#scale = scale / size_scale
	
	var half_size = (shape.size / 2) * size_scale
	var corners = [
		transform * Vector2(-half_size.x, -half_size.y),
		transform * Vector2(half_size.x, -half_size.y),
		transform * Vector2(half_size.x, half_size.y),
		transform * Vector2(-half_size.x, half_size.y)
	]
	
	return [
		[corners[0], corners[1]],  # Top edge
		[corners[1], corners[2]],  # Right edge
		[corners[2], corners[3]],  # Bottom edge
		[corners[3], corners[0]]   # Left edge
	]

func searching():
	pass

func lock():
	laser_progress = 0.0;
	state = 1;
	
func fire():
	laser_progress = 0.0;
	state = 2;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tween.tween_callback(lock).set_delay(3);
	tween.chain().tween_callback(fire).set_delay(1);
	
func handle_collision():
	var area = get_node("Area2D");
	
	var bodies = area.get_overlapping_bodies();
	bodies = bodies.filter(func(x): return x != shooter_ref);
	
	var dir = shooter_ref.position.direction_to(target_pos);
	for body in bodies:
		if body == target_ref:
			#print("got 'em")
			pass
		
		if !body is StaticBody2D:
			body.velocity += dir * 1000;

		if body.get_parent().get_groups().has("wall") && body.get_parent().built:
			body.get_parent().split(self);
			
	shooter_ref.velocity -= dir * 50;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state == 0:
		target_pos = target_ref.position;
	
	position = shooter_ref.position;
	position.x -= size.x / 2.0;
	
	var dirv = target_pos - shooter_ref.position;
	rotation = atan2(dirv.y, dirv.x) - PI / 2;
	
	pivot_offset = Vector2(size.x / 2.0, 0.0);
	
	laser_progress += delta;
	
	if laser_progress >= 1.0:
		laser_progress = 0.0;
		
	if state == 2 && laser_progress >= 0.25:
			queue_free();
		
	material.set_shader_parameter("laser_color", [color.r, color.g, color.b, color.a]);
	material.set_shader_parameter("laser_state", state);
	material.set_shader_parameter("laser_progress", laser_progress);
	
	if state == 2:
		handle_collision()
	
	# print(laser_progress);
