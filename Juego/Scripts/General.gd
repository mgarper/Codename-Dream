extends Node

var dead 
var first_load 
var load_game 

var last_save
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
		"final_boss_area_1":
			file = "res://Scenes/final_boss.tscn"
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

func set_player_attributes(last_place, life, strength, points, m_level, castle):
	last_save = last_place
	max_life = life
	max_strength = strength
	current_points = points
	level = m_level
	check_castle = castle

func update_points(points):
	current_points += points

func retry():
	General.first_load = false
	General.load_game = true
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		i.queue_free()

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var save_file = FileAccess.open("C:/Users/USUARIO/Documents/ONIROS/Save_Files/savegame.save", FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()

		# Creates the helper class to interact with JSON
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		# Get the data from the JSON object
		var node_data = json.get_data()

		# Firstly, we need to create the object and add it to the tree and set its position.
		var path =  node_data["last_place"].replace("/root/", "")
		
		General.set_player_attributes(path, node_data["max_life"],node_data["max_strength"],0,node_data["level"],node_data["check_castle"])
		General.change_scene(false,true,false,"",path,false,false,false,false)
