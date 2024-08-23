extends Node2D

var mc
var player_camera
var markerA
var markerB
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
	player_camera.limit_right = 4330
	#player_camera.limit_bottom = get_viewport().size.y - 50
	
	markerA = $Marker2D
	markerB = $Marker2D2
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
		pass
		General.first_load = false
		General.load_game = false
		mc.position = Vector2(statue.position.x - 240, statue.position.y - 170)
	
	player_camera.position_smoothing_enabled = false
	await get_tree().create_timer(2.0).timeout
	player_camera.position_smoothing_enabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_to_village_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.name == "Player":
		General.change_scene(false,false,false,"castle","village",false,false,false,true)


func _on_to_boss_fight_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.name == "Player":
		General.change_scene(false,false,false,"castle","final_boss_area_1",false,false,true,false)
