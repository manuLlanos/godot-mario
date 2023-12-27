extends Area2D

# should only detect the player
# should constantly move in one direction like goombas but faster
# until hitting a wall and swapping direction
# or leaving the screen and dissapearing
# Make the player bigger if in small mode, always give score


func _ready():
	$AnimationPlayer.play("spawn")

func _on_body_entered(body: Player):
	if ! body.in_big_mode:
		body.to_big_mode()
	Globals.score += 200
	queue_free()
