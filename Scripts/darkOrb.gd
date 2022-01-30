extends Area2D

onready var player = get_tree().current_scene.get_node("Player")

func _on_darkOrb_body_entered(_body):
	if visible:
		$SoundPickup.play()
		player.got_darkOrb()
		# TODO actually free this lol
		visible = false
