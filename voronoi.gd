extends Sprite2D

var screen_size;
@export var points = 50;
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
		var color_possibilities = [Color.BLUE, Color.RED, Color.GREEN, Color.PURPLE, Color.YELLOW, Color.ORANGE]
		var c = color_possibilities[randi() % color_possibilities.size()];
		
		c = [randf(), randf(), randf(), 1.0]
		
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
#
#func generate_voronoi_diagram(img_size: Vector2i, num_cells: int):
	#var img = Image.create(img_size.x, img_size.y, false, Image.FORMAT_RGB8)
#
	#var points = []
	#var colors = []
#
	#for i in range(num_cells):
		#points.append(Vector2i(int(randf() * img.get_width()), int(randf() * img.get_height())))
#
		#randomize()
		#var color_possibilities = [Color.BLUE, Color.RED, Color.GREEN, Color.PURPLE, Color.YELLOW, Color.ORANGE]
		#colors.append(color_possibilities[randi() % color_possibilities.size()])
#
	#for y in range(img.get_height()):
		#for x in range(img.get_width()):
			#var dmin = float(img.get_size().length())
			#var j = -1
			#for i in range(num_cells):
				#var d = (points[i] - Vector2i(x, y)).length()
				#if d < dmin:
					#dmin = d
					#j = i
			#img.set_pixel(x, y, colors[j])
#
	#var generated_texture = ImageTexture.create_from_image(img)
#
	#self.texture = generated_texture

## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
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
