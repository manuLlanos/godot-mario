extends StaticBody2D

@onready var hurtbox = %Hurtbox
var explode_effect_scene: PackedScene = preload("res://scenes/effects/brick_explosion.tscn")

func head_hit(in_big_mode: bool):
	if in_big_mode:
		AudioManager.play("Break")
		$AnimationPlayer.play("destroy")
		Globals.score += 10
	else:
		$AnimationPlayer.play("shake")
		enable_hurtbox(0.4)

func enable_hurtbox(time: float):
	hurtbox.monitorable = true
	await get_tree().create_timer(time).timeout
	hurtbox.monitorable = false

func create_effect():
	var effect = explode_effect_scene.instantiate()
	effect.position = global_position
	get_parent().call_deferred("add_child", effect)
