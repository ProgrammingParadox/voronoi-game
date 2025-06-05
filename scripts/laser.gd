extends TextureRect

# 0 = searching, 1 = locked, 2 = firing
var state = 2;
var laser_progress = 0.0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	laser_progress += delta;
	
	if laser_progress >= 1.0:
		laser_progress = 0.0;
		
	if state > 2:
		state = 0;
		laser_progress = 0.0;
		
	material.set_shader_parameter("laser_state", state);
	material.set_shader_parameter("laser_progress", laser_progress);
	
	# print(laser_progress);
