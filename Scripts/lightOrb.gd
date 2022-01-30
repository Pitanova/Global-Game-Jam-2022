extends Area2D

onready var player = get_tree().current_scene.get_node("Player")

func _on_lightOrb_body_entered(_body):
	# todo play pick up orb sound
	player.got_lightOrb()
	#$DeathSound.play()
	queue_free()
