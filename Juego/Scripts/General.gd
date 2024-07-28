extends Node

var position
var dead 
var first_load

func _ready():
	first_load = true
	dead = false

# Called when the node enters the scene tree for the first time.
func change_scene(from, to):
	first_load = false
	var file = ""
	match to:
		"Forest":
			file = "res://Scenes/beginning.tscn"
		"Village":
			file = "res://Scenes/village.tscn"
	get_tree().change_scene_to_file(file)

# We'll see if I'll use this method
func go_to_position(from, to):
	match to:
		"Forest":
			if dead:
				pass
			else:
				pass
		"Village":
			if dead:
				pass
			else:
				pass
