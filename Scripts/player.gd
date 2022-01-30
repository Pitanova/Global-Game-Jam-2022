extends KinematicBody2D

export var move_speed = 200.0

var velocity := Vector2.ZERO

var dimension := false
# where true is right and false is left

export var jump_height : float
export var jump_time_to_peak : float
export var jump_time_to_descent : float

# Based on the real life equation for projectiles
onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

var light_default = 1.03

func _physics_process(delta):
	velocity.y += get_jump_gravity() * delta
	velocity.x = get_input_velocity() * move_speed

	var dimension_modifier := 1
	if dimension:
		dimension_modifier = -1
	
	var GlassTileMap: TileMap = get_tree().current_scene.get_node("Glass")
	var tile_idx = GlassTileMap.get_cellv(GlassTileMap.world_to_map(position) + Vector2(0,dimension_modifier))
	var on_glass = tile_idx != -1
	
	
	if Input.is_action_just_pressed("down") and dimension == false and is_on_floor() and on_glass:
		position.y = 116
		rotation_degrees = 180
		fall_gravity *= -1
		scale.x *= -1
		dimension = true
	elif Input.is_action_just_pressed("up") and dimension == true and is_on_ceiling() and on_glass:
		position.y = 91
		rotation_degrees = 0
		fall_gravity *= -1
		dimension = false
	elif Input.is_action_just_pressed("jump") and (is_on_floor() or is_on_ceiling()):
		jump()
		$SoundJump.play()
	
	#if dimension:
	#	$Light2D.energy = 2.1
	#else:
	#	$Light2D.energy = 2
	
	#$playerTrailRight.visible = false
	#$playerTrailLeft.visible = false
	
	#if velocity.x >= 0.1 and (is_on_floor() or is_on_ceiling()):
	#	$playerTrailLeft.visible = true
	#elif velocity.x <= -0.1 and (is_on_floor() or is_on_ceiling()):
	#	$playerTrailRight.visible = true
	
	if dimension:
		if $Light2D.energy >= 0:
			$Light2D.energy -= 0.05 * delta
		else:
			$Light2D.energy = 0
	else:
		$Light2D.energy = light_default

	
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
		$Sprite.set_flip_h(true)
	if Input.is_action_pressed("right"):
		horizontal += 1.0
		$Sprite.set_flip_h(false)
		
	return horizontal

func got_lightOrb():
	$Light2D.energy += 0.5

func got_darkOrb():
	$Light2D.energy -= 0.5
	if $Light2D.energy < 0:
		$Light2D.energy = 0


func _on_Area2D_body_entered(body):
	if body.get_name() == "Player":
		SceneChanger.change_scene("res://Scenes/level2.tscn")
