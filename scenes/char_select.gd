extends Control

@export var seed_tscn: PackedScene;

var references = [];

var point_x = [];
var point_y = [];
var colors  = [];

var screen_size: Vector2;
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

func set_game_time(seconds):
	Global.game_time = seconds;
	
func start_game():
	get_tree().paused = false
	Global.curr_game_time = Global.game_time
	Global.set_scene(Global.SCENES.BATTLE);

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var m = get_node("music")
	m.set_cur(m.audio.OVER);
	
	resize()
	
	get_tree().root.size_changed.connect(resize)
	
	get_node("Voronoi").parent = self;
	
	var cs = Global.COLOR_PALETTE;
	var seeds = 40;
	for i in range(seeds):
		var new_seed = seed_tscn.instantiate()
		add_child(new_seed)
		
		new_seed.position = Vector2(randf(), randf()) * screen_size;
		new_seed.color = cs.pick_random();
		
		new_seed.velocity = Vector2(randf() - 0.5, randf() - 0.5) 
		
		add_point(new_seed);
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for r in references:
		if r.velocity.length() < 0.01:
			r.velocity =  Vector2(randf() - 0.5, randf() - 0.5)
		
		r.position += r.velocity;
		
		var c = r.position.clamp(Vector2(0.0, 0.0), screen_size);
		if c != r.position:
			r.velocity *= -1;
	
	build_voronoi_seeds();
