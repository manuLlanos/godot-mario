extends CharacterBody2D
class_name Player

@export var walk_speed: int = 250
@export var run_speed: int = 450
@export var jump_force: float = 370
@export var accel: int = 250
var default_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var gravity = default_gravity
var motion: Vector2 = Vector2.ZERO

@onready var sprite = %Sprite
@onready var collision_shape = %CollisionShape
@onready var hitbox = %Hitbox
@onready var stomp_hurtbox = %StompHurtbox
@onready var animation_player = %AnimationPlayer
@onready var camera = %Camera2D


var in_big_mode: bool = false
var can_move: bool = true
var warping: bool = false
var alive: bool = true
var vulnerable: bool = true
var warp_position: Vector2

signal death

func _ready():
	stomp_hurtbox.hitted.connect(stomp)

func _physics_process(delta):
	if !can_move or !alive:
		return
	motion = Vector2.ZERO
	var speed: int = walk_speed
	if Input.is_action_pressed("left"):
		motion.x -= 1
	if Input.is_action_pressed("right"):
		motion.x += 1
	if Input.is_action_pressed("run"):
		speed = run_speed
	
	
	# warp
	if Input.is_action_just_pressed("down") and is_on_floor() and can_move:
		warp()
	
	# jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		AudioManager.play("Jump")
		jump()
	if Input.is_action_pressed("jump") and velocity.y < 0:
		gravity = default_gravity * 0.50
	else:
		gravity = default_gravity
	
	# stomp hurtbox
	if velocity.y > 0:
		stomp_hurtbox.monitorable = true
	else:
		stomp_hurtbox.monitorable = false
	
	# animation
	handle_animations()
	
	var target_velocity_x: float = motion.x * speed
	velocity.x = move_toward(velocity.x, target_velocity_x, accel * delta)
	velocity.y += gravity * delta
	move_and_slide()
	
	handle_head_collisions()

func stomp():
	velocity.y = 0
	gravity = default_gravity * 0.5
	jump()

func jump(multiplier: float = 1.0):
	velocity.y -= jump_force * multiplier

func hit():
	if !vulnerable:
		return
	if in_big_mode:
		to_small_mode()
	else:
		kill()

func kill():
	alive = false
	AudioManager.play("PlayerDeath")
	animation_player.play("death")
	Globals.lives -= 1
	death.emit()

func warp():
	#check if player is in warp area
	var overlapping_areas = hitbox.get_overlapping_areas()
	for area in overlapping_areas:
		if area is WarpArea:
			velocity = Vector2.ZERO
			can_move = false
			warping = true
			warp_position = area.target_area.global_position - Vector2(0, 32)
			animation_player.play("warpIn")
			break

func teleport():
	position = warp_position
	animation_player.play("warpOut")
	await get_tree().create_timer(animation_player.current_animation_length).timeout
	can_move = true
	warping = false


func to_small_mode():
	make_invulnerable(3)
	in_big_mode = false
	can_move = false
	AudioManager.play("PowerDown")
	animation_player.play("shrink")
	

func to_big_mode():
	if in_big_mode:
		return
	make_invulnerable(0.6)
	velocity = Vector2.ZERO
	can_move = false
	in_big_mode = true
	AudioManager.play("PowerUp")
	animation_player.play("grow")

func make_invulnerable(time):
	vulnerable = false
	$BlinkerComponent.start_blinking(self, time)
	await get_tree().create_timer(time).timeout
	vulnerable = true

func handle_animations():
	if warping:
		return
	var big_modifier: String = ""
	if in_big_mode:
		big_modifier = "Big"
	
	if velocity == Vector2.ZERO or (is_on_wall() and is_on_floor()):
		animation_player.play("idle" + big_modifier)
	elif velocity.y != 0:
		animation_player.play("jump" + big_modifier)
	else:
		animation_player.play("walk" + big_modifier)
		if velocity.x < 0:
			sprite.flip_h = true
			if Input.is_action_pressed("right"):
				animation_player.play("slide" + big_modifier)
		else:
			sprite.flip_h = false
			if Input.is_action_pressed("left"):
				animation_player.play("slide" + big_modifier)

func handle_head_collisions():
	if is_on_ceiling():
		var collider = get_last_slide_collision().get_collider()
		if "head_hit" in collider:
			collider.head_hit(in_big_mode)
		elif "hit" in collider:
			collider.hit()

func set_camera_boundaries(min_x:int, max_x:int):
	camera.limit_left = min_x
	camera.limit_right = max_x
