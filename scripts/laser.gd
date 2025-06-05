extends TextureRect

# 0 = searching, 1 = locked, 2 = firing
var state = 0;
var laser_progress = 0.0;

var color = Color(1.0, 0.0, 0.0, 1.0);

var target_ref;
var shooter_ref;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = shooter_ref.position;
	position.x -= size.x / 2.0;
	
	var dirv = target_ref.position - shooter_ref.position;
	rotation = atan2(dirv.y, dirv.x) - PI / 2;
	
	pivot_offset = Vector2(size.x / 2.0, 0.0);
	
	laser_progress += delta;
	
	if laser_progress >= 1.0:
		laser_progress = 0.0;
		
	if state > 2:
		state = 0;
		laser_progress = 0.0;
		
	material.set_shader_parameter("laser_color", [color.r, color.g, color.b, color.a]);
	material.set_shader_parameter("laser_state", state);
	material.set_shader_parameter("laser_progress", laser_progress);
	
	# print(laser_progress);
