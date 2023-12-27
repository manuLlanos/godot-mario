extends Node2D
class_name Level

@onready var player = %Player
@onready var ui = %UI
@onready var camera_limit_1 = %CameraLimit1
@onready var camera_limit_2 = %CameraLimit2
@onready var timer = %Timer

## The next level after this one is won, if empty, game is considered won
@export var next_level: PackedScene


func _ready():
	Globals.timeleft = Globals.max_time
	Globals.game_over.connect(_on_game_over)
	Globals.time_over.connect(_on_time_over)
	player.set_camera_boundaries(camera_limit_1.position.x, camera_limit_2.position.x)

func _on_player_death():
	if !Globals.is_game_over:
		await get_tree().create_timer(3).timeout
		Globals.score = Globals.last_score
		Globals.timeleft = Globals.max_time
		get_tree().reload_current_scene()


func _on_castle_level_won():
	timer.stop()
	if next_level:
		ui.show_victory_text()
		await get_tree().create_timer(3).timeout
		Globals.last_score = Globals.score
		get_tree().change_scene_to_file(next_level.get_path())
	else:
		ui.show_game_won()
		await get_tree().create_timer(5).timeout
		get_tree().quit()

func _on_time_over():
	player.kill()
	timer.stop()

func _on_game_over():
	await get_tree().create_timer(3).timeout
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")
	Globals.reset()

func _on_timer_timeout():
	Globals.timeleft -= 1

