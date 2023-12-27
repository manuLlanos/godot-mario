extends Area2D

func _ready():
	$AnimationPlayer.play("spawn")

# should only be detecting the player
func _on_body_entered(_body):
	Globals.score += 50
	AudioManager.play("Coin")
	queue_free()
