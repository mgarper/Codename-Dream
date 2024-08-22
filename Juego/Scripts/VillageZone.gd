extends Node2D

var mc
var player_camera 
var markerA
var markerB
var spawnpoint
var statue

var first_load
var load_game
var dead
var check_castle
var left
var right

# Called when the node enters the scene tree for the first time.
func _ready():
	first_load = General.first_load
	load_game = General.load_game
	dead = General.dead
	check_castle = General.check_castle
	left = General.left
	right = General.right
	
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
	
	markerA = get_node("Marker2DA")
	markerB = get_node("Marker2DB")
	spawnpoint = get_node("Spawnpoint")
	statue = $Statue
	
	
	
	_player_set_up()

func _player_set_up():
	mc.scale = Vector2(0.7, 0.7)
	if !load_game:
		if dead:
			pass
		else:
			if left:
				mc.position = Vector2(markerA.position.x - 240, markerA.position.y - 150)
			elif right:
				mc.position = Vector2(markerB.position.x - 240, markerB.position.y - 150)
	else:
		General.first_load = false
		General.load_game = false
		mc.position = Vector2(spawnpoint.position.x - 300, spawnpoint.position.y - 170)
	
	var camera = mc.get_node("Player/Camera2D")
	
	camera.position_smoothing_enabled = false
	await get_tree().create_timer(2.0).timeout
	camera.position_smoothing_enabled = true

func _on_to_forest_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.name == "Player":
		General.change_scene(false,false,false,"village","beginning",false,false,false,false)


func _on_to_castle_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.name == "Player":
		General.change_scene(false,false,false,"village","castle",false,false,true,false)
