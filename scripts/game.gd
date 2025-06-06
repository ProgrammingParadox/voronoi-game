extends Node2D

'''
TODO: 
	[ ] Mutex to lock points so bar calculation can be done without phantom points?
'''

@export var multithread_bar = true;
@export var bar_scan_step = 100;

@export var HUD_box: Node; # because we don't want to count the part of the screen obscured by the bars and timer
@onready var bar = get_node("OwnershipBar");

var screen_size: Vector2;

var references = [];

var point_x = [];
var point_y = [];
var colors  = [];

var thread: Thread;

func resize():
	screen_size = get_viewport_rect().size

func add_point(ref):
	references.append(ref);
	
func remove_point(ref):
	var ind = references.find(ref);
	references.remove_at(ind);
	
func build_voronoi_seeds():
	var m = max(screen_size.x, screen_size.y);
	
	var temp_point_x = [];
	var temp_point_y = [];
	var temp_colors  = [];
	for ref in references:
		temp_point_x.append(ref.position.x / m);
		temp_point_y.append(ref.position.y / m);
		
		temp_colors.append_array([ref.color[0], ref.color[1], ref.color[2], ref.color[3]])
		
	point_x = temp_point_x;
	point_y = temp_point_y;
	colors  = temp_colors ;

var polygon_data;
func _ready() -> void:
	resize()
	
	get_tree().root.size_changed.connect(resize)
	
	get_node("Player 1").color = Global.COLOR_PALETTE[1];
	
	var collision_polygon = HUD_box.get_node("CollisionPolygon2D")
	polygon_data = {
		"points": collision_polygon.polygon,
		"transform": collision_polygon.global_transform
	}

	if multithread_bar:
		thread = Thread.new();
		thread.start(calc_bar.bind(bar, polygon_data));
		
	var ebar1 = get_node("EnergyBar1");
	ebar1.filled_color   = Global.COLOR_PALETTE[2].darkened(0.2);
	ebar1.unfilled_color = Global.COLOR_PALETTE[2].darkened(0.4);
	
	var ebar2 = get_node("EnergyBar2");
	ebar2.filled_color   = Global.COLOR_PALETTE[2].darkened(0.2);
	ebar2.unfilled_color = Global.COLOR_PALETTE[2].darkened(0.4);

func is_point_in_static_body(point: Vector2, static_body: StaticBody2D) -> bool:
	var space_state = static_body.get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = point
	query.collision_mask = static_body.collision_layer
	
	var result = space_state.intersect_point(query)
	
	for collision in result:
		if collision.collider == static_body:
			return true
			
	return false

func calc_bar(bar, polygon_data):
	var owner_indices = [];
	var owner_count   = [];
	
	var samples = 0;
	
	var global_points = PackedVector2Array()
	for point in polygon_data.points:
		global_points.append(polygon_data.transform * point)

	var m = max(screen_size.x, screen_size.y);
	for y in range(0, screen_size.y, bar_scan_step):
		for x in range(0, screen_size.x, bar_scan_step):
			# this code is kinda nasty. Abstract to function?
			if Geometry2D.is_point_in_polygon(Vector2(x, y), global_points):
				continue;
			
			var min_dist = INF;
			var ind = -1;
			for i in range(point_x.size()):
				var dist = Vector2(point_x[i], point_y[i]).distance_to(Vector2(x/m, y/m));
				
				if dist < min_dist:
					ind = i;
					min_dist = dist;
			
			var id = owner_indices.find(ind);
			if id == -1:

				owner_indices.append(ind);
				owner_count.append(1);
			else:
				owner_count[id] += 1;
				
			samples += 1;
		
		var owner_colors = Global.COLOR_PALETTE;
		var owner_amount = [0, 0, 0, 0, 0];
		for ind in range(owner_indices.size()):
			var onind = owner_indices[ind];
			if(references.size() <= onind):
				return;
			
			var color = references[onind].color;
			
			var oind = owner_colors.find_custom(func(c): return c.is_equal_approx(color));
			if oind == -1:
				owner_colors.append(color);
				owner_amount.append(owner_count[ind]);
			else:
				owner_amount[oind] += owner_count[ind];
				
		bar.percent = float(owner_amount[1]) / float(samples)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	build_voronoi_seeds()
	
	if multithread_bar:
		if !thread.is_alive():
			thread.wait_to_finish();
			thread.start(calc_bar.bind(bar, polygon_data));
	else:
		calc_bar(bar, polygon_data)
		
func _exit_tree():
	if multithread_bar:
		thread.wait_to_finish()
