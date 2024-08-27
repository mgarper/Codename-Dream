extends Node2D

var layer1
var layer2
var layer3
var background
var anim_background

# Called when the node enters the scene tree for the first time.
func _ready():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	get_node("MC_Moves").play("RUN")
	get_node("Dog_Moves").play("RUN")
	get_node("AudioStreamPlayer").playing = true
	var camera = $Camera2D
	
	layer1 = get_node("CanvasLayer/ParallaxBackground/ParallaxLayer")
	layer2 = get_node("CanvasLayer/ParallaxBackground/ParallaxLayer2")
	layer3 = get_node("CanvasLayer/ParallaxBackground/ParallaxLayer3")
	background = get_node("Black/ColorRect")
	background.modulate.a = 255
	anim_background = get_node("Black/Fade")
	
	anim_background.play("fade_out")
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
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
	if not FileAccess.file_exists(OS.get_user_data_dir() + "/ONIROS/Save_Files/savegame.save"):
		General.set_player_attributes("beginning",5,1,0,1,false,5)
		anim_background.play("fade_in")
		await anim_background.animation_finished
		General.change_scene(true,false,false,"main_menu","beginning",false,false,true,false)
	else:
		General.first_load = false
		General.load_game = true
		var save_nodes = get_tree().get_nodes_in_group("Persist")
		for i in save_nodes:
			i.queue_free()

		# Load the file line by line and process that dictionary to restore
		# the object it represents.
		var save_file = FileAccess.open(OS.get_user_data_dir() + "/ONIROS/Save_Files/savegame.save", FileAccess.READ)
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
			General.set_player_attributes(path, node_data["max_life"],node_data["max_strength"],node_data["current_points"],node_data["level"],node_data["check_castle"],5)
			anim_background.play("fade_in")
			await anim_background.animation_finished
			General.change_scene(false,true,false,"main_menu",path,false,false,false,false)
