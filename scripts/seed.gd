extends CharacterBody2D

@export var color: Color;

var screen_size;
func resize():
	screen_size = get_viewport_rect().size
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("entity")
	add_to_group("seeds")
	
	resize();
	get_tree().get_root().size_changed.connect(resize);

	
	get_node("Sprite2D").material.set_shader_parameter("player_color", [
		color.r,
		color.g,
		color.b,
		color.a
	]);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		var collider = collision_info.get_collider();
		
		if !collider is StaticBody2D:
			if(collider.velocity.length() > 100):
				# parent.remove_point(self);
				pass
				# queue_free()
			
			collider.velocity = velocity;
		
		velocity = velocity.bounce(collision_info.get_normal())
	
	var clamped = position.clamp(Vector2.ZERO, screen_size)
	if clamped != position:
		var normal = clamped - position;
		normal = normal.normalized();
		
		velocity = velocity - (2 * velocity.dot(normal) * normal)
		
		position = clamped
	
	velocity *= 0.9;
	
	get_node("Sprite2D").material.set_shader_parameter("player_color", [
		color.r,
		color.g,
		color.b,
		color.a
	]);
