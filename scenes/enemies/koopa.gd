extends CharacterBody2D
@export var speed: int = 50
@export var score: int = 100

@onready var animation_player = %AnimationPlayer
@onready var hitbox = %Hitbox
@onready var hurtbox = %Hurtbox
@onready var sprite = %Sprite2D

var shell_scene: PackedScene = preload("res://scenes/enemies/koopa_shell.tscn")
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
		sprite.flip_h = !sprite.flip_h
	velocity.y += gravity * delta
	move_and_slide()

func hit():
	Globals.score += score
	AudioManager.play("Stomp")
	var shell = shell_scene.instantiate()
	shell.position = global_position
	get_parent().call_deferred("add_child",shell)
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_entered():
	active = true
	$VisibleOnScreenNotifier2D.queue_free()
