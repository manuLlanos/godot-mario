extends Area2D
class_name Hitbox

@onready var parent = get_parent()

# should only detect a hurtbox
func _on_area_entered(area):
	if not (area is Hurtbox or area is WarpArea):
		push_error("Hitbox is detecting somethign other than a hurtbox or warparea")
		return
	if "hit" in parent and "hitted" in area:
		parent.hit()
		area.hitted.emit()
	#else:
		#push_error("Hitbox assigned to parent without hit method")
