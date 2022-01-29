extends Area2D

onready var player = get_tree().current_scene.get_node("Player")

func _on_Void_body_entered(body):
	player.queue_free()
	$DeathSound.play()
	yield(get_tree().create_timer(2.0), "timeout")
	get_tree().reload_current_scene()
