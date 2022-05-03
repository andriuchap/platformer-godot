extends KinematicBody2D

const WALK_FORCE = 1800
const WALK_MAX_SPEED = 640
const STOP_FORCE = 3900
const JUMP_SPEED = 1000

var velocity = Vector2()

var is_jumping = false
var jump_time = 0.0

onready var gravity = 980
var gravity_scale = 1.0

func _physics_process(delta):
	var walk = WALK_MAX_SPEED * (Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	velocity.x = walk

	if velocity.x != 0:
		$CharacterSprite.flip_h = velocity.x < 0

	if is_jumping:
		if jump_time < 0.2:
			velocity.y = -JUMP_SPEED
		else:
			is_jumping = false
		jump_time += delta
	else:
		velocity.y += gravity * gravity_scale * delta
	
	if velocity.y > 0 && !is_on_floor():
		gravity_scale = 2.0

	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)

	if is_on_floor() and Input.is_action_just_pressed("jump"):
		is_jumping = true
		jump_time = 0.0
		gravity_scale = 4.0
		$CharacterSprite.animation = "jump_start"
		$jump.play()
	if Input.is_action_just_released("jump"):
		is_jumping = false
		
	update_animation()
	
func update_animation():
	if velocity.y != 0:
		$CharacterSprite.animation = "jump"
	elif velocity.x != 0:
		$CharacterSprite.animation = "walk"
	elif velocity == Vector2.ZERO:
		$CharacterSprite.animation = "idle"

func play_coin():
	$coin.play()
