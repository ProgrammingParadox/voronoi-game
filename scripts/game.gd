extends Node2D

var screen_size: Vector2;

var references = [];

var point_x = [];
var point_y = [];
var colors  = [];

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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	build_voronoi_seeds()
