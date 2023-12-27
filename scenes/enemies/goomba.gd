extends CharacterBody2D

@export var speed: int = 50
@export var score: int = 100

@onready var animation_player = %AnimationPlayer
@onready var hitbox = %Hitbox
@onready var hurtbox = %Hurtbox

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
# later make them start moving when they enter the screen
var direction: Vector2 = Vector2.LEFT
var active: bool = false

func _ready():
	animation_player.play("walk")
	velocity = direction * speed

func _physics_process(delta):
	if !active:
		return
	if is_on_wall():
		direction *= -1
		velocity.x = direction.x * speed
	velocity.y += gravity * delta
	move_and_slide()

func hit():
	Globals.score += score
	velocity = Vector2.ZERO
	gravity = 0
	hitbox.queue_free()
	hurtbox.queue_free()
	$CollisionShape2D.queue_free()
	AudioManager.play("Stomp")
	animation_player.play("death")


func _on_visible_on_screen_notifier_2d_screen_entered():
	active = true
	$VisibleOnScreenNotifier2D.queue_free()
