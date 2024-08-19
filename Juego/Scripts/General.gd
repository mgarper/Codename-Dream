extends Node

var position
var dead 
var first_load
var load_game

var max_life
var max_strength
var current_points
var level
var check_castle

func _ready():
	first_load = true
	load_game = false
	dead = false

# Called when the node enters the scene tree for the first time.
func change_scene(from, to):
	
	var file = ""
	match to:
		"main_menu":
			file = "res://Scenes/main_menu.tscn"
		"beginning":
			file = "res://Scenes/beginning.tscn"
		"village":
			file = "res://Scenes/village.tscn"
	get_tree().change_scene_to_file(file)

func set_player_attributes(life, strength, points, level, castle):
	max_life = life
	max_strength = strength
	current_points = points
	level = level
	check_castle = castle

func update_points(points):
	current_points += points
