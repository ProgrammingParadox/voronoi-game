extends TextureRect

var screen_size: Vector2;

func resize():
	screen_size = get_viewport_rect().size
	
	var m = max(screen_size.x, screen_size.y);
	var img = Image.create(m, m, false, Image.FORMAT_RGB8)
	var generated_texture = ImageTexture.create_from_image(img)

	self.texture = generated_texture

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	resize()
	
	get_tree().get_root().size_changed.connect(resize)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
