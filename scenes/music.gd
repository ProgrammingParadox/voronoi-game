extends Node

@onready var audio_start = get_node("start");
@onready var audio_loop = get_node("loop");
@onready var audio_end = get_node("end");
@onready var audio_end_length = audio_end.get_stream().get_length();

@onready var audio_over = get_node("over");
@onready var audio_menu = get_node("menu");

enum audio {
	START,
	LOOP,
	END,
	OVER,
	MENU,
}
var cur = audio.START;
@onready var audio_players = {
	audio.START: audio_start,
	audio.LOOP: audio_loop,
	audio.END: audio_end,
	audio.OVER: audio_over,
	audio.MENU: audio_menu,
};

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var ca = audio_players[cur]; # current audio
		
func set_cur(a: audio):
	audio_players[cur].stop();
	cur = a;
	audio_players[cur].play(0.0);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var ca = audio_players[cur]; # current audio
	if !ca.playing:
		ca.play(0.0);
	
	# there's probably a better way to do this...
	if !ca.playing and cur == audio.START:
		set_cur(audio.LOOP);
		
	if Global.curr_game_time < audio_end_length and cur == audio.LOOP:
		set_cur(audio.END);
		
	if Global.curr_game_time < 0 and cur == audio.END:
		set_cur(audio.MENU);
