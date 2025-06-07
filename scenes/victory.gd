extends Control
@onready var win_panel = $TextureRect
@onready var text      = $TextureRect/Playerwin_text
@onready var buttons   = $HomeUI
@onready var gray      = $ColorRect
@onready var screen_size = get_viewport().size
@onready var game_over = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	hide()
	gray.modulate.a = 0.0
	win_panel.size.x = screen_size.x
	
	buttons.modulate.a = 0
	win_panel.position = Vector2(1300, 41)

func _process(delta: float) -> void:
	
	if Global.game_time <= 0 and not game_over:
		game_over = not game_over
		show()
		game_end()
		
		


func game_end():
	get_tree().paused = true
	if Global.percent < 0.5:
		text.text = "Player 1 Wins!"
	elif Global.percent > 0.5:
		text.text = "Player 2 Wins!"
	else:
		text.text = "Tie!"
	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(gray, "modulate:a", 0.6, 0.4)
	tween.tween_property(win_panel, "position", Vector2(0, 41), 0.8).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(buttons, "modulate:a", 1, 1.0)
	
