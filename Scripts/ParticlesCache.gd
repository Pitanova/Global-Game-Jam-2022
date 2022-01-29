extends Node2D

var materials = [preload("res://Materials/PlayerTrailLeft.tres"), preload("res://Materials/PlayerTrailRight.tres")]

# Called when the node enters the scene tree for the first time.
func _ready():
	for material in materials:
		var particles_instance = Particles2D.new()
		particles_instance.set_process_material(material)
		particles_instance.set_one_shot(true)
		particles_instance.set_modulate(Color(1,1,1,0))
		particles_instance.set_emitting(true)
		particles_instance.name = material.resource_path.get_file().trim_suffix(".tres")
		add_child(particles_instance)
