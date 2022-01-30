extends Area2D

onready var player = get_tree().current_scene.get_node("Player")

var got = false


func _on_lightOrb_body_entered(_body):
	if visible:
		$SoundPickup.play()
		player.got_lightOrb()
		# TODO actually free this lol
		visible = false
