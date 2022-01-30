extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	SceneChanger.change_scene("res://Scenes/mainMenu.tscn", 20)
