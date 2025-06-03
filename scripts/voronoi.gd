extends Sprite2D

# screen size, duh
var screen_size;

@export var points = 50;

var color_palette = Global.COLOR_PALETTE;

var point_x = [];
var point_y = [];
var colors = [];
func resize():
	screen_size = get_viewport_rect().size
	
	var m = max(screen_size.x, screen_size.y);
	var img = Image.create(m, m, false, Image.FORMAT_RGB8)
	var generated_texture = ImageTexture.create_from_image(img)

	self.texture = generated_texture
	
func _ready():
	resize()
	
	get_tree().get_root().size_changed.connect(resize)
	
	for i in range(points):
		point_x.append(randf())
		point_y.append(randf())

		var c = color_palette[randi() % color_palette.size()]
		
		colors.append(c[0])
		colors.append(c[1])
		colors.append(c[2])
		colors.append(c[3])
	
	material.set_shader_parameter("p_x", point_x)
	material.set_shader_parameter("p_y", point_y)
	material.set_shader_parameter("colors", colors)
	material.set_shader_parameter("points", points)

func _process(delta: float) -> void:
	var player_position = get_parent().get_node("Player").position
	
	var m = max(screen_size.x, screen_size.y);
	
	var px = player_position.x/m
	var py = player_position.y/m
	
	material.set_shader_parameter("player_x", px)
	material.set_shader_parameter("player_y", py)
	
	point_x[0] = px;
	point_y[0] = py;
	
	material.set_shader_parameter("p_x", point_x)
	material.set_shader_parameter("p_y", point_y)
