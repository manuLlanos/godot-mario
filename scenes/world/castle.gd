extends Node2D

signal level_won

func _on_end_area_body_entered(body):
	if !(body is Player):
		push_error("Check flagpole area collision")
	print("Level won")
	Globals.score += Globals.timeleft * 50
	level_won.emit()
