extends Node2D

'''
TODO: 
	[ ] Mutex to lock points so bar calculation can be done without phantom points?
'''

@export var multithread_bar = true;
@export var bar_scan_step = 100;

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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	resize()
	
	get_tree().root.size_changed.connect(resize)
	
	get_node("Player 1").color = Global.COLOR_PALETTE[1];

	if multithread_bar:
		thread = Thread.new();
		thread.start(calc_bar.bind(bar));
		
	var ebar1 = get_node("EnergyBar1");
	ebar1.filled_color   = Global.COLOR_PALETTE[2].darkened(0.4);
	ebar1.unfilled_color = Global.COLOR_PALETTE[2].darkened(0.2);
	
	var ebar2 = get_node("EnergyBar2");
	ebar2.filled_color   = Global.COLOR_PALETTE[2].darkened(0.4);
	ebar2.unfilled_color = Global.COLOR_PALETTE[2].darkened(0.2);

func calc_bar(bar):
	var owner_indices = [];
	var owner_count   = [];
	
	var samples = 0;
	
	var m = max(screen_size.x, screen_size.y);
	for y in range(0, screen_size.y, bar_scan_step):
		for x in range(0, screen_size.x, bar_scan_step):
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
			thread.start(calc_bar.bind(bar));
	else:
		calc_bar(bar)
		
func _exit_tree():
	if multithread_bar:
		thread.wait_to_finish()
