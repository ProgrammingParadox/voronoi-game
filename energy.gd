extends Control

@export var player_ref : Node
@onready var progress_bar = $ProgressBar
@onready var energy_num = $ProgressBar/EnergyDisplay
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_ref.energy = 0.0
	energy_num.text = "0"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progress_bar.value += 0.2
	player_ref.energy = floor(progress_bar.value / 10)
	energy_num.text = str(int(player_ref.energy))
	
	
	
	
	
	
