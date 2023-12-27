extends Node

signal update_ui
signal time_over
signal game_over

var is_game_over: bool = false

var max_time: int = 300

var lives: int = 2:
	set(value):
		if value < 0:
			game_over.emit()
			is_game_over = true
			return
		lives = value
		update_ui.emit()

var last_score = 0

var score: int = 0:
	set(value):
		score = value
		update_ui.emit()

var timeleft: int = max_time:
	set(value):
		if value == 0:
			time_over.emit()
		timeleft = value
		update_ui.emit()

func reset():
	timeleft = max_time
	last_score = 0
	score = 0
	lives = 2
