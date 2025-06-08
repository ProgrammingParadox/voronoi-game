extends Node;

var percent := 0.0

var game_time := 30
var curr_game_time : int = 30

var paused = false

enum SCENES {
	HOME, 
	CHAR_SELECT,
	COUNT,
	SETTINGS,
	BATTLE
}
var SCENE = SCENES.HOME;

var SCENE_TSCN = {
	SCENES.HOME: "res://scenes/home.tscn",
	SCENES.CHAR_SELECT: "res://scenes/char_select.tscn",
	SCENES.BATTLE: "res://scenes/Game.tscn",
}

var COLOR_PALETTE: Array[Color] = [
	Color("#b3fffc"),
	Color("#645dd7"),
	Color("#fb62f6"),
	Color("#ff4242"),
	Color("#f2ff49")
];

func set_scene(scene):
	SCENE = scene;
	get_tree().change_scene_to_file(SCENE_TSCN[scene])
