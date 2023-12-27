extends CharacterBody2D

@export var speed: int = 200

@onready var hurtbox = %Hurtbox
@onready var player_touch = %PlayerTouch


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction: Vector2
var active: bool = false


func _ready():
	$AnimationPlayer.play("spawn")

func _physics_process(delta):
	if active and is_on_wall():
		direction *= -1
		velocity.x = direction.x * speed
		
		#after the first bounce, make it also hurt the player
		hurtbox.set_collision_layer_value(3, true)
	velocity.y += gravity * delta
	move_and_slide()

# body should only be the player
func _on_player_touch_body_entered(body):
	if active:
		return
	active = true
	if global_position.x - body.global_position.x  < 0:
		direction = Vector2.LEFT
	else:
		direction = Vector2.RIGHT
	velocity = direction * speed
	
	hurtbox.set_deferred("monitorable", true)
	player_touch.queue_free()
