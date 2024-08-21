extends Node2D

var first_load
var load_game
var dead

var left
var right

var mc
var player_camera
var markerA
var health_bar
var health

var reaper
var move_left
var move_right
var attack_left
var attack_right
var enemy_sprite
var enemy_asset
var enemy_body
var attack

var speed
var is_attacking
var is_moving
var points

# Called when the node enters the scene tree for the first time.
func _ready():
	
	first_load = General.first_load
	load_game = General.load_game
	dead = General.dead
	
	left = General.left
	right = General.right
	
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	var SceneToLoad = preload("res://Scenes/player.tscn")
	mc = SceneToLoad.instantiate()
	add_child(mc)
	General.current_scene = get_tree().current_scene
	General.player_node = General.current_scene.get_node("./player")
	
	player_camera = $player/Player/Camera2D
	player_camera.limit_top = 0
	player_camera.limit_left = 0 
	player_camera.limit_right = 1350
	player_camera.limit_bottom = 625
	
	health_bar = $CanvasLayer
	health_bar.visible = false
	health = health_bar.get_node("ProgressBar")
	health.value = 100
	
	reaper = $CharacterBody2D
	enemy_sprite = reaper.get_node("AnimationPlayer")
	enemy_asset = reaper.get_node("Sprite2D")
	enemy_body = reaper.get_node("CollisionShape2D")
	move_left = reaper.get_node("move_left")
	move_right = reaper.get_node("move_right")
	attack_left = reaper.get_node("left_attacks")
	attack_right = reaper.get_node("right_attacks")
	attack = reaper.get_node("attack_area/CollisionShape2D")
	
	attack.disabled = true
	enemy_body.disabled = false
	
	markerA = $Marker2D
	
	speed = 120
	is_attacking = false
	is_moving = false
	points = 200
	
	_player_set_up()

func _player_set_up():
	mc.scale = Vector2(0.7, 0.7)
	if dead:
		pass
	else:
		if left:
			mc.position = Vector2(markerA.position.x - 240, markerA.position.y - 200)
		elif right:
			pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var collision
	
	if attack_right.is_colliding():
		collision = attack_right.get_collider()
		if collision.name == "Player":
			enemy_asset.flip_h = true
			reaper.velocity.x = 0
			is_moving = false
			is_attacking = true
	elif attack_left.is_colliding():
		collision = attack_left.get_collider()
		if collision.name == "Player":
			enemy_asset.flip_h = false
			reaper.velocity.x = 0
			is_moving = false
			is_attacking = true
	else:
		is_attacking = false
	
	if move_right.is_colliding() && !is_attacking:
		collision = move_right.get_collider()
		if collision != null and collision.name == "Player":
			enemy_asset.flip_h = true
			reaper.velocity.x = speed
			is_attacking = false
			is_moving = true
	elif move_left.is_colliding() && !is_attacking:
		collision = move_left.get_collider()
		if collision != null and collision.name == "Player":
			enemy_asset.flip_h = false
			reaper.velocity.x = -speed
			is_attacking = false
			is_moving = true
		
		if !health_bar.visible:
			health_bar.visible = true
			
	else:
		is_moving = false
	
	if !is_moving && !is_attacking:
		reaper.velocity.x = 0
		
	_set_colliders_and_detectors()
	_play_animation()
	reaper.move_and_slide()

func _play_animation():
	if is_moving:
		enemy_sprite.play("move")
	elif is_attacking:
		enemy_sprite.play("attack")
		await enemy_sprite.animation_finished
	else:
		enemy_sprite.play("idle")

func _set_colliders_and_detectors():
	if enemy_asset.flip_h:
		enemy_asset.position.x = 142
		attack.position.x = 209
	else:
		enemy_asset.position.x = 0
		attack.position.x = -54

func hit(body):
	set_physics_process(false)
	health.value -= 5 
	if health.value <= 0:
		body.add_points(points)
		death()
	else:
		enemy_sprite.play("hit")
		await enemy_sprite.animation_finished
		set_physics_process(true)

func death():
	enemy_sprite.play("death")
	await enemy_sprite.animation_finished
	health_bar.visible = false
	reaper.queue_free()
	set_physics_process(false)
	$TileMap.clear_layer(2)
	$StaticBody2D/CollisionShape2D.disabled = true

func _on_attack_area_body_entered(body):
	if body.name == "Player":
		body.damage("skeleton")
	
func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.name == "Player":
		General.change_scene(false,false,false,"final_boss","castle",false,false,false,true)
