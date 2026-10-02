extends CharacterBody2D


const SPEED = 160.0
const JUMP_VELOCITY = -220.0
const MAX_AIR = 100.0
# air lost per second, a full tank lasts about 17 sec
const AIR_DRAIN = 5.7

var jumps_left = 2
var oxygen = 0
var air = MAX_AIR
var dead = false
# 1 is normal, -1 is upside down
var gravity_dir = 1
# time left frozen after a dud
var stunned = 0.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * gravity_dir * delta
	else:
		jumps_left = 2

	# stunned from a dud cell, can't move
	if stunned > 0:
		stunned -= delta
		# blink
		$Sprite2D.visible = int(stunned * 10) % 2 == 0
	else:
		$Sprite2D.visible = true

	# Handle jump.
	if Input.is_action_just_pressed("jump") and jumps_left > 0 and stunned <= 0:
		velocity.y = JUMP_VELOCITY * gravity_dir
		jumps_left -= 1
		$JumpSound.play()

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	if stunned > 0:
		direction = 0
	if direction:
		velocity.x = direction * SPEED
		$Sprite2D.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Use the walking frame while in the air.
	if is_on_floor():
		$Sprite2D.frame = 9
	else:
		$Sprite2D.frame = 10

	move_and_slide()

	# lose air over time
	air -= AIR_DRAIN * delta
	if air <= 0:
		air = 0
		die()

	# fell in the pit or up into space
	if position.y > 400 or position.y < -500:
		die()


func flip_gravity(new_dir: int) -> void:
	if new_dir == gravity_dir:
		return
	gravity_dir = new_dir
	# so the ceiling counts as the floor
	up_direction = Vector2.UP * gravity_dir
	$Sprite2D.flip_v = gravity_dir < 0
	velocity.y = 0
	# no jumping till you land
	jumps_left = 0
	$FlipSound.play()


func die() -> void:
	if dead:
		return
	dead = true
	set_physics_process(false)
	$CollisionShape2D.set_deferred("disabled", true)
	hide()
	$DeathSound.play()
	await get_tree().create_timer(0.6).timeout
	get_tree().reload_current_scene()
