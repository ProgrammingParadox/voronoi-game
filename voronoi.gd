extends Sprite2D

var screen_size;

@export var points = 50;
@export var color_palette: Array[Color] = [];

var point_x = [];
var point_y = [];
var colors = [];
func resize():
	screen_size = get_viewport_rect().size
	
	var img = Image.create(screen_size.x, screen_size.y, false, Image.FORMAT_RGB8)
	var generated_texture = ImageTexture.create_from_image(img)

	self.texture = generated_texture
	
func _ready():
	screen_size = get_viewport_rect().size
	
	get_tree().get_root().size_changed.connect(resize)
	
	for i in range(points):
		point_x.append(randf())
		point_y.append(randf())

		randomize()
		
		#var c = [randf(), randf(), randf(), 1.0]
		
		var c = color_palette[randi() % color_palette.size()]
		
		colors.append(c[0])
		colors.append(c[1])
		colors.append(c[2])
		colors.append(c[3])
	
	var img = Image.create(screen_size.x, screen_size.y, false, Image.FORMAT_RGB8)
	var generated_texture = ImageTexture.create_from_image(img)

	self.texture = generated_texture
	
	material.set_shader_parameter("p_x", point_x)
	material.set_shader_parameter("p_y", point_y)
	material.set_shader_parameter("colors", colors)
	material.set_shader_parameter("points", points)
	#generate_voronoi_diagram(Vector2i(screen_size.x, screen_size.y), 100)

func _process(delta: float) -> void:
	# generate_voronoi_diagram(Vector2i(screen_size.x, screen_size.y), 100)
	var player_position = get_parent().get_node("Player").get_node("AnimatedSprite2D").position
	
	var px = player_position.x
	var py = player_position.y
	
	material.set_shader_parameter("player_x", px / screen_size.x)
	material.set_shader_parameter("player_y", py / screen_size.y)
	
	point_x[0] = px/screen_size.x;
	point_y[0] = py/screen_size.y;
	
	material.set_shader_parameter("p_x", point_x)
	material.set_shader_parameter("p_y", point_y)
