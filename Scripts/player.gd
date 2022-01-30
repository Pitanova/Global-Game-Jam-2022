extends KinematicBody2D

const MAX_SPEED = 200.0
var velocity := Vector2.ZERO
const ACCELERATION = 50
const SLOW_DOWN_PERCENT_GROUND = 0.4
const SLOW_DOWN_PERCENT_AIR = 0.2

var can_move = true
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
	
	if not can_move:
		return
	
	velocity.y += get_jump_gravity() * delta

	if Input.is_action_pressed("left"):
		velocity.x = max(velocity.x - ACCELERATION, -MAX_SPEED)
		$Sprite.set_flip_h(true)
	elif Input.is_action_pressed("right"):
		velocity.x = min(velocity.x + ACCELERATION, MAX_SPEED)
		$Sprite.set_flip_h(false)
	else:
		# idle player
		# if friction should be applied
		if (is_on_floor() or is_on_ceiling()):
			velocity.x = lerp(velocity.x, 0, SLOW_DOWN_PERCENT_GROUND)
		else:
			# else air friction
			velocity.x = lerp(velocity.x, 0, SLOW_DOWN_PERCENT_AIR)

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
	
	
	if dimension:
		if $Light2D.energy >= 0:
			$Light2D.energy -= 0.05 * delta
		else:
			$Light2D.energy = 0
	else:
		$Light2D.energy = light_default

	AudioManager.sound_change(dimension)

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

func got_lightOrb():
	$Light2D.energy += 0.5

func got_darkOrb():
	$Light2D.energy -= 0.5
	if $Light2D.energy < 0:
		$Light2D.energy = 0


func _on_Area2D_body_entered(body):
	if body.get_name() == "Player":
		print(get_tree().current_scene.name)
		if get_tree().current_scene.name == "Level1":
			$EndSong.play()
			SceneChanger.change_scene("res://Scenes/level2.tscn")
		elif get_tree().current_scene.name == "Level2":
			SceneChanger.change_scene("res://Scenes/level3.tscn")
		elif get_tree().current_scene.name == "Level3":
			SceneChanger.change_scene("res://Scenes/credits.tscn")
