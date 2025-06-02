extends AnimatedSprite2D


@export var speed = 400 # How fast the player will move (pixels/sec).
@export var acceleration: float = 1.0;
var screen_size # Size of the game window.

var velocity = Vector2.ZERO;

func resize():
	screen_size = get_viewport_rect().size

func _ready():
	screen_size = get_viewport_rect().size
	
	get_tree().get_root().size_changed.connect(resize)

func _process(delta):
	if Input.is_action_pressed("ui_right"):
		velocity.x += acceleration
	if Input.is_action_pressed("ui_left"):
		velocity.x += -acceleration
	if Input.is_action_pressed("ui_down"):
		velocity.y += acceleration
	if Input.is_action_pressed("ui_up"):
		velocity.y += -acceleration
		
		
	if velocity.length() > 1:
		velocity = velocity.normalized()
		
	position += velocity * speed * delta
	
	var clamped = position.clamp(Vector2.ZERO, screen_size)
	if clamped != position:
		velocity *= -1
		
		position = clamped
	
	velocity *= 0.9;
