extends Control
@onready var number = $Label
var countdown_step = 0
var timer: Timer
var done = false

func _ready() -> void:
	pass

func _show_countdown_number():
	match countdown_step:
		0:
			number.text = "3"
		1:
			number.text = "2"
		2:
			number.text = "1"
		3:
			number.text = "GO!"
		4:
			_finish_countdown()
			return

func _on_timer_timeout():
	countdown_step += 1
	_show_countdown_number()

func _finish_countdown():
		print("Countdown finished, unpausing game")
		timer.queue_free()
		hide()
		get_tree().paused = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not done:
		process_mode = Node.PROCESS_MODE_ALWAYS
		show()
		get_tree().paused = true
		
		# Create timer for countdown
		timer = Timer.new()
		timer.process_mode = Node.PROCESS_MODE_ALWAYS
		add_child(timer)
		timer.wait_time = 1.0
		timer.timeout.connect(_on_timer_timeout)
		
		# Start countdown
		_show_countdown_number()
		timer.start()
		
		# Animate the scale
		done = true
