extends Node2D

var layer1
var layer2
var layer3

# Called when the node enters the scene tree for the first time.
func _ready():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	$MC_Moves.play("RUN")
	$Dog_Moves.play("RUN")
	var camera = $Camera2D
	
	layer1 = $CanvasLayer/ParallaxBackground/ParallaxLayer
	layer2 = $CanvasLayer/ParallaxBackground/ParallaxLayer2
	layer3 = $CanvasLayer/ParallaxBackground/ParallaxLayer3
	
	$VBoxContainer/Button.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	layer1.motion_offset.x -= 1
	layer2.motion_offset.x -= 2
	layer3.motion_offset.x -= 4

func _input(event):
	if Input.is_action_just_pressed("accept"):
		if $VBoxContainer/Button.has_focus():
			$VBoxContainer/Button.emit_signal("pressed")
		else:
			$VBoxContainer/Button2.emit_signal("pressed")

func _on_button_pressed():
	load_game()


func _on_button_2_pressed():
	get_tree().quit()

func load_game():
	if not FileAccess.file_exists("C:/Users/USUARIO/Documents/ONIROS/Save_Files/savegame.save"):
		General.set_player_attributes(5,1,0,1,false)
		General.change_scene("main_menu","beginning")
	else:
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
			
			General.change_scene("main_menu",path)
			General.set_player_attributes(node_data["max_life"],node_data["max_strength"],node_data["current_points"],node_data["level"],node_data["check_castle"])
