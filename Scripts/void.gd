extends Area2D

onready var player = get_tree().current_scene.get_node("Player")

func _on_Void_body_entered(_body):
	player.can_move = false
	player.visible = false
	$DeathSound.play()
	SceneChanger.player_died()
