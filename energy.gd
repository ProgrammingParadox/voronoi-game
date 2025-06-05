extends Control

@export var player_ref : Node
@onready var progress_bar = $ProgressBar

@export var energy_speed := 10.0
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_ref.energy = 0.0



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	player_ref.energy += energy_speed * delta
	progress_bar.value = player_ref.energy
	
	
	
	
	
	
