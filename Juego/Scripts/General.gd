extends Node

var dead 
var first_load 
var load_game 

var max_life
var max_strength
var current_points
var level
var check_castle

var current_scene
var player_node
var pause_menu

var up
var down
var left
var right


# Called when the node enters the scene tree for the first time.
func change_scene(s_first_load,s_load_game,s_dead,from, to, p_up, p_down, p_left, p_right):
	first_load = s_first_load
	load_game = s_load_game
	dead = s_dead
	
	up = p_up
	down = p_up
	left = p_left
	right = p_right
	
	var file = ""
	match to:
		"main_menu":
			file = "res://Scenes/main_menu.tscn"
		"beginning":
			file = "res://Scenes/beginning.tscn"
		"village":
			file = "res://Scenes/village.tscn"
		"castle":
			file = "res://Scenes/castle.tscn"
	
	get_tree().change_scene_to_file(file)
	

func _input(event):
	if Input.is_action_just_pressed("pause"):
		_open_menu()

func _open_menu():
	var SceneToLoad = preload("res://Scenes/pause_menu.tscn")
	var pause_menu = SceneToLoad.instantiate()
	player_node.add_child(pause_menu)
	player_node.get_node("./pause_menu").offset = Vector2(385,200)
	pause_menu = null
		
func _check_character_stats():
	var SceneToLoad = preload("res://Scenes/character_stats.tscn")
	var cstats = SceneToLoad.instantiate()
	player_node.add_child(cstats)
	player_node.get_node("./character_stats").offset = Vector2(385,200)

func set_player_attributes(life, strength, points, m_level, castle):
	max_life = life
	max_strength = strength
	current_points = points
	level = m_level
	check_castle = castle

func update_points(points):
	current_points += points
