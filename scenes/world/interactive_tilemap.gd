extends TileMap

# script should replace all tiles with the corresponding
# scenes in the dictionary

@export var tile_scenes: Dictionary = {
	0: preload("res://scenes/world/brick_tile.tscn"),
	1: preload("res://scenes/world/question_tile_mushroom.tscn"),
	2: preload("res://scenes/world/question_tile_coin.tscn")
}

var half_cell_size = tile_set.tile_size.x / 2.0

func _ready():
	# is only using layer 0
	for tile_pos in get_used_cells(0):
		var tile_custom_data: TileData = get_cell_tile_data(0, tile_pos)
		var tile_type: int = tile_custom_data.get_custom_data("interactive")
		_replace_tiles_with_objects(tile_pos, tile_scenes[tile_type])
	
	clear()
	queue_free()


func _replace_tiles_with_objects(tile_pos: Vector2, object_scene: PackedScene, parent: Node = get_tree().current_scene):
	var object = object_scene.instantiate()
	object.global_position = tile_pos * 32 + Vector2.ONE * half_cell_size
	parent.call_deferred("add_child", object)
	
