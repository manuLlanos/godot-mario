extends StaticBody2D
class_name QuestionTile

@onready var sprite = %Sprite2D
var item_scene: PackedScene
var activated: bool = false

func hit():
	if activated:
		return
	activated = true
	sprite.frame = 1
	$AnimationPlayer.play("shake")
	spawn_item()

func spawn_item():
	if item_scene:
		var item = item_scene.instantiate()
		item.position = global_position
		item.position.y -= 32
		get_parent().get_node("Pickups").call_deferred("add_child", item)
