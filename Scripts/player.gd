extends KinematicBody2D

export var move_speed = 200.0

var velocity := Vector2.ZERO

var dimension := false

export var jump_height : float
export var jump_time_to_peak : float
export var jump_time_to_descent : float

# Based on the real life equation for projectiles
onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

func _physics_process(delta):
	velocity.y += get_jump_gravity() * delta
	velocity.x = get_input_velocity() * move_speed
	
	if Input.is_action_just_pressed("down") and dimension == false and is_on_floor():
		position.y = 116
		rotation_degrees = 180
		fall_gravity *= -1
		dimension = true
	elif Input.is_action_just_pressed("up") and dimension == true and is_on_ceiling():
		position.y = 91
		rotation_degrees = 0
		fall_gravity *= -1
		dimension = false
	elif Input.is_action_just_pressed("jump") and (is_on_floor() or is_on_ceiling()):
		jump()
		$SoundJump.play()
		
	velocity = move_and_slide(velocity, Vector2.UP)

func get_jump_gravity() -> float:
	if not dimension:
		return jump_gravity if velocity.y < 0.0 else fall_gravity
	else:
		return jump_gravity * -1 if velocity.y > 0.0 else fall_gravity

func jump():
	if not dimension:
		velocity.y = jump_velocity
	else:
		velocity.y = -jump_velocity

func get_input_velocity() -> float:
	var horizontal := 0.0
	
	if Input.is_action_pressed("left"):
		horizontal -= 1.0
	if Input.is_action_pressed("right"):
		horizontal += 1.0
	
	return horizontal
