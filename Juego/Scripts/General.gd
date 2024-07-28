extends Node

var position
var dead 
var first_load

func _ready():
	first_load = true
	dead = false

# Called when the node enters the scene tree for the first time.
func change_scene(from, to):
	
	var file = ""
	match to:
		"Menu":
			file = "res://Scenes/main_menu.tscn"
		"Forest":
			file = "res://Scenes/beginning.tscn"
		"Village":
			file = "res://Scenes/village.tscn"
	get_tree().change_scene_to_file(file)
