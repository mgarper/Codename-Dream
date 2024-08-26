extends Node2D

var mc
var player_camera
var markerA
var markerB
var statue
var background
var anim_background
var falling_spawn
var label

var first_load
var load_game
var dead
var check_castle
var hidden_zone
var left
var right

# Called when the node enters the scene tree for the first time.
func _ready():
	first_load = General.first_load
	load_game = General.load_game
	dead = General.dead
	check_castle = General.check_castle
	hidden_zone = !check_castle
	left = General.left
	right = General.right
	
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	var SceneToLoad = preload("res://Scenes/player.tscn")
	mc = SceneToLoad.instantiate()
	add_child(mc)
	
	General.current_scene = get_tree().current_scene
	General.player_node = General.current_scene.get_node("./player")
	
	player_camera = get_node("player/Player/Camera2D")
	player_camera.limit_left = 0
	player_camera.limit_right = 4330
	
	markerA = get_node("Marker2D")
	markerB = get_node("Marker2D2")
	statue = get_node("Statue")
	background = get_node("Black/ColorRect")
	background.modulate.a = 255
	anim_background = get_node("Black/Fade")
	falling_spawn = get_node("FallingSpawn")
	label = get_node("Label")
	label.visible = false
	
	if !hidden_zone:
		get_node("Structures").clear_layer(2)
		get_node("Hidden_Section").visible = hidden_zone
		get_node("AnimationPlayer").play("movement")
	
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
	
	anim_background.play("fade_out")
	player_camera.position_smoothing_enabled = false
	await get_tree().create_timer(2.0).timeout
	player_camera.position_smoothing_enabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if Input.is_action_just_pressed("interaction") && $Label.visible == true:
			anim_background.play("fade_in")
			await anim_background.animation_finished
			General.change_scene(false,false,false,"castle","demo_end",false,false,false,false)


func _on_to_village_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.name == "Player":
		anim_background.play("fade_in")
		await anim_background.animation_finished
		General.change_scene(false,false,false,"castle","village",false,false,false,true)
		General.current_life = mc.get_node("Player").get_life()


func _on_to_boss_fight_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.name == "Player":
		anim_background.play("fade_in")
		await anim_background.animation_finished
		General.change_scene(false,false,false,"castle","final_boss_area_1",false,false,true,false)
		General.current_life = mc.get_node("Player").get_life()


func _on_falling_area_body_entered(body):
	if body.name == "Player":
		body.damage()
		if body.get_life() != 0:
			anim_background.play("fade_in")
			await anim_background.animation_finished
			body.position = Vector2(falling_spawn.position.x - 3700, falling_spawn.position.y - 650)
			anim_background.play("fade_out")
			await anim_background.animation_finished

func _on_to_demo_end_body_entered(body):
	if body.name == "Player":
		label.visible = true

func _on_to_demo_end_body_exited(body):
	if body.name == "Player":
		label.visible = false
