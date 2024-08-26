extends Node2D
var mc
var start
var spawnpoint
var marker
var statue
var background
var anim_background
var pre_spikes
var post_spikes

var first_load
var load_game
var dead
var check_castle

var right

func _ready():
	first_load = General.first_load
	load_game = General.load_game
	dead = General.dead
	check_castle = General.check_castle
	right = General.right
	
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	var SceneToLoad = preload("res://Scenes/player.tscn")
	mc = SceneToLoad.instantiate()
	add_child(mc)
	
	General.current_scene = get_tree().current_scene
	General.player_node = General.current_scene.get_node("./player")
	
	start = get_node("start")
	spawnpoint = get_node("spawnpoint")
	marker = get_node("Marker2D")
	statue = get_node("Node2D")
	background = get_node("Black/ColorRect")
	background.modulate.a = 255
	anim_background = get_node("Black/Fade")
	pre_spikes = get_node("SpikesSpawn")
	post_spikes = get_node("SpikesSpawn2")
	_player_set_up()

# Sets up the scale, position and camera of the player
func _player_set_up():
	mc.scale = Vector2(0.7, 0.7)
	if !load_game:
		if first_load:
			mc.position = Vector2(start.position.x - 240, start.position.y - 170)
			General.first_load = false
		else:
			mc.position = Vector2(marker.position.x - 240, marker.position.y - 150)
	else:
		General.first_load = false
		General.load_game = false
		mc.position = Vector2(spawnpoint.position.x - 240, spawnpoint.position.y - 170)
	
	var camera = mc.get_node("Player/Camera2D")
	anim_background.play("fade_out")
	camera.position_smoothing_enabled = false
	await get_tree().create_timer(2.0).timeout
	camera.position_smoothing_enabled = true

# Moving to the Village
func _on_to_village_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.name == "Player":
		anim_background.play("fade_in")
		await anim_background.animation_finished
		General.change_scene(false,false,false,"beginning","village",false,false,true,false)
		General.current_life = mc.get_node("Player").get_life()


func _on_spikes_body_entered(body):
	if body.name == "Player":
		body.damage()
		if body.get_life() != 0:
			anim_background.play("fade_in")
			await anim_background.animation_finished
			if !right:
				body.position = Vector2(pre_spikes.position.x - 50, pre_spikes.position.y + 200)
			else:
				body.position = Vector2(post_spikes.position.x - 4500, post_spikes.position.y - 1050)
			anim_background.play("fade_out")
			await anim_background.animation_finished
