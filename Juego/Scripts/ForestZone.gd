extends Node2D
var mc
var start
var spawnpoint
var marker
var statue

var first_load
var load_game
var dead

func _ready():
	first_load = General.first_load
	load_game = General.load_game
	dead = General.dead
	
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	var SceneToLoad = preload("res://Scenes/player.tscn")
	mc = SceneToLoad.instantiate()
	add_child(mc)
	
	General.current_scene = get_tree().current_scene
	General.player_node = General.current_scene.get_node("./player")
	
	start = get_node("start")
	spawnpoint = get_node("spawnpoint")
	marker = $Marker2D
	statue = $Node2D
	_player_set_up()

# Sets up the scale, position and camera of the player
func _player_set_up():
	mc.scale = Vector2(0.7, 0.7)
	if !load_game:
		if first_load:
			mc.position = Vector2(start.position.x - 240, start.position.y - 170)
			General.first_load = false
		elif dead:
			pass
		else:
			mc.position = Vector2(marker.position.x - 240, marker.position.y - 150)
	else:
		General.first_load = false
		General.load_game = false
		mc.position = Vector2(spawnpoint.position.x - 240, spawnpoint.position.y - 170)
	
	var camera = mc.get_node("Player/Camera2D")
	
	camera.position_smoothing_enabled = false
	await get_tree().create_timer(2.0).timeout
	camera.position_smoothing_enabled = true

# Moving to the Village
func _on_to_village_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.name == "Player":
		General.change_scene(false,false,false,"beginning","village",false,false,true,false)
