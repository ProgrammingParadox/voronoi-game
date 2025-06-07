extends TextureRect;

var built: bool = false;

var builder_ref: Node;

var start_position: Vector2;
var end_position  : Vector2;

@onready var collision_shape = get_node("StaticBody2D/CollisionShape2D");

@export var laser_hole_scale = 1.5;
@export var minimum_wall_length = 5.0;
@export var distance_to_builder = 20.0;

func _ready() -> void:
	add_to_group("wall")
	
	collision_shape.shape = collision_shape.shape.duplicate(DUPLICATE_USE_INSTANTIATION) # because Godot is stupid
	collision_shape.add_to_group("wall")
	
# more math from Claude. I don't understand where he gets all the info,
# but I understand usually how it works
func point_in_rectangle(point: Vector2, shape: RectangleShape2D, transform: Transform2D) -> bool:
	# Transform point to rectangle's local space
	var local_point = transform.affine_inverse() * point
	var half_size = shape.size / 2
	
	# Check if point is within rectangle bounds in local space
	return abs(local_point.x) <= half_size.x and abs(local_point.y) <= half_size.y
	
func line_segment_intersect(p1: Vector2, p2: Vector2, p3: Vector2, p4: Vector2) -> Vector2:
	var x1 = p1.x; var y1 = p1.y
	var x2 = p2.x; var y2 = p2.y
	var x3 = p3.x; var y3 = p3.y
	var x4 = p4.x; var y4 = p4.y
	
	var denom = (x1-x2)*(y3-y4) - (y1-y2)*(x3-x4)
	if abs(denom) < 0.0001:
		return Vector2.INF  # Lines are parallel
	
	var t = ((x1-x3)*(y3-y4) - (y1-y3)*(x3-x4)) / denom
	var u = -((x1-x2)*(y1-y3) - (y1-y2)*(x1-x3)) / denom
	
	# Check if intersection point lies within both line segments
	if t >= 0 and t <= 1 and u >= 0 and u <= 1:
		return Vector2(x1 + t*(x2-x1), y1 + t*(y2-y1))
	
	return Vector2.INF  # No intersection within segments
	
# where r is an array of line segments (as [a: Vector2, b: Vector2]) and l is a line segment
func get_collision_points(r, l):
	var collision_points = []
	for line in r:
		var collision_point = line_segment_intersect(line[0], line[1], l[0], l[1]);
		
		if collision_point == Vector2.INF:
			continue;
			
		collision_points.append(collision_point);
		
	return collision_points;
	
func build_wall(wall_line):
	var wall = duplicate(DUPLICATE_USE_INSTANTIATION)
	
	wall.start_position = wall_line[0];
	wall.end_position = wall_line[1];
	
	wall.built = true;
	
	add_sibling(wall)
	
	
func split(laser):
	var line = [start_position, end_position]
	
	# check to see if whole wall is inside the laser
	var free_points = line.filter(func (x): return !point_in_rectangle(x, laser.get_shape(laser_hole_scale), laser.get_global_transform()))
		
	if free_points.size() == 0:	
		queue_free();
			
		return;
	
	# otherwise, cut 'er up
	var edges = laser.get_edges(laser_hole_scale)
	
	var cps = get_collision_points(edges, line);
	
	# math from claude :upside_down_smiley_face:
	# I don't even know if it works
	var wall_direction = (end_position - start_position).normalized()
	cps.sort_custom(func(a, b):  
		var proj_a = wall_direction.dot(a - start_position)
		var proj_b = wall_direction.dot(b - start_position)
		return proj_a < proj_b
	)
	
	if cps.size() >= 2:
		var wall_line_a = [start_position, cps[0]];
		var wall_line_b = [cps[1], end_position];
		
		build_wall(wall_line_a);
		build_wall(wall_line_b);
		
		queue_free();
	elif cps.size() == 1:
		build_wall([free_points[0], cps[0]]);
		
		queue_free();

func _process(delta: float) -> void:
	if !built:
		end_position = builder_ref.position - (start_position.direction_to(builder_ref.position) * distance_to_builder);
	elif size.x < minimum_wall_length:
		queue_free();
	
	pivot_offset = Vector2(0.0, size.y / 2.0);
	
	position = start_position;
	position -= pivot_offset; 
	
	var dirv = end_position - start_position;
	rotation = atan2(dirv.y, dirv.x);
	
	# I don't know why this doesn't work. I think I figured it out last night,
	# because code I wrote then has it and I remember vaguely figuring out
	# everything then...
	#rotation = start_position.angle_to(end_position);
	
	size.x = start_position.distance_to(end_position);
	
	collision_shape.shape.size = size
	collision_shape.position = Vector2(size.x / 2.0, 0.0) + pivot_offset;
		
	collision_shape.disabled = not built;
		
	material.set_shader_parameter("wall_color", Global.COLOR_PALETTE[4])
	material.set_shader_parameter("transp", 1.0 if built else 0.5)
