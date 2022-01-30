extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var previous_dimension = true

func sound_change(dimension):
	if dimension != previous_dimension:
		if dimension:
			$FlopMusic.play($FlipMusic.get_playback_position())
			$FlipMusic.stop()
		else:
			$FlipMusic.play($FlopMusic.get_playback_position())
			$FlopMusic.stop()
		previous_dimension = dimension
