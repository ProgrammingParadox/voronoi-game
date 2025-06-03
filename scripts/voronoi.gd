extends Sprite2D

# screen size, duh
var screen_size;

@onready var parent = get_node("/root/Node2D"); 

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

func _process(delta: float) -> void:
	material.set_shader_parameter("points", parent.point_x.size());
	
	material.set_shader_parameter("p_x"   , parent.point_x);
	material.set_shader_parameter("p_y"   , parent.point_y);
	material.set_shader_parameter("colors", parent.colors );
