extends Node2D

var mc
var player_camera 
var markerA
var statue

# Called when the node enters the scene tree for the first time.
func _ready():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	var SceneToLoad = preload("res://Scenes/player.tscn")
	mc = SceneToLoad.instantiate()
	add_child(mc)
	
	General.current_scene = get_tree().current_scene
	General.player_node = General.current_scene.get_node("./player")
	
	player_camera = $player/Player/Camera2D
	player_camera.limit_left = 0
	player_camera.limit_right = 4480
	player_camera.limit_bottom = get_viewport().size.y - 50
	
	markerA = $Marker2DA
	statue = $Node2D
	
	_player_set_up()

func _player_set_up():
	mc.scale = Vector2(0.7, 0.7)
	if !General.load_game:
		
		if General.dead:
			pass
		else:
			mc.position = Vector2(markerA.position.x - 240, markerA.position.y - 150)
	else:
		General.first_load = false
		mc.position = Vector2(statue.position.x - 240, statue.position.y - 170)
	
	var camera = mc.get_node("Player/Camera2D")
	
	camera.position_smoothing_enabled = false
	await get_tree().create_timer(2.0).timeout
	camera.position_smoothing_enabled = true

func _on_to_forest_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.name == "Player":
		General.change_scene("village","beginning")
