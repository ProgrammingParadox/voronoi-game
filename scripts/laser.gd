extends TextureRect

# 0 = searching, 1 = locked, 2 = firing
var state = 0;
var laser_progress = 0.0;

var color = Color(1.0, 0.0, 0.0, 1.0);

var target_ref;
var target_pos;
var shooter_ref;

@onready var tween = create_tween()

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
	
	for body in bodies:
		if body == target_ref:
			print("got 'em")
			
		var dir = shooter_ref.position.direction_to(target_pos);
		body.velocity += dir * 1000;

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
