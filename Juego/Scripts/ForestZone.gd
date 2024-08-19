extends Node2D
var mc
var marker
var statue

func _ready():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	var SceneToLoad = preload("res://Scenes/player.tscn")
	mc = SceneToLoad.instantiate()
	add_child(mc)
	
	marker = $Marker2D
	statue = $Node2D
	_player_set_up()

# Sets up the scale, position and camera of the player
func _player_set_up():
	mc.scale = Vector2(0.7, 0.7)
	if !General.load_game:
		if General.first_load:
			mc.position = Vector2(-102, -139)
			General.first_load = false
		elif General.dead:
			pass
		else:
			mc.position = Vector2(marker.position.x - 240, marker.position.y - 150)
	else:
		General.first_load = false
		mc.position = Vector2(statue.position.x - 240, statue.position.y - 170)
	
	var camera = mc.get_node("Player/Camera2D")
	
	camera.position_smoothing_enabled = false
	await get_tree().create_timer(2.0).timeout
	camera.position_smoothing_enabled = true

# Moving to the Village
func _on_to_village_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.name == "Player":
		General.change_scene("beginning","village")


		
