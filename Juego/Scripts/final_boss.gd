extends Node2D

var first_load
var load_game
var dead

var left
var right

var check_castle

var mc
var player_camera
var markerA
var health_bar
var health
var background
var anim_background
var bd_feedback
var hint
var anim_feedback

var statue

var reaper
var move_left
var move_right
var attack_left
var attack_right
var enemy_sprite
var enemy_asset
var enemy_body
var attack

var hand
var hand_col
var hand_anim
var prox

var speed
var is_attacking
var is_moving
var points
var player_close
var cooldown

# Called when the node enters the scene tree for the first time.
func _ready():
	
	first_load = General.first_load
	load_game = General.load_game
	dead = General.dead
	
	left = General.left
	right = General.right
	
	check_castle = General.check_castle
	
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	var SceneToLoad = preload("res://Scenes/player.tscn")
	mc = SceneToLoad.instantiate()
	add_child(mc)
	General.current_scene = get_tree().current_scene
	General.player_node = General.current_scene.get_node("./player")
	
	player_camera = get_node("player/Player/Camera2D")
	player_camera.limit_top = 0
	player_camera.limit_left = 0 
	player_camera.limit_right = 1350
	player_camera.limit_bottom = 625
	
	health_bar = get_node("CanvasLayer")
	health_bar.visible = false
	health = health_bar.get_node("ProgressBar")
	health.value = 100
	
	statue = get_node("Statue")
	background = get_node("Black/ColorRect")
	background.modulate.a = 255
	anim_background = get_node("Black/Fade")
	bd_feedback = get_node("CanvasLayer2/Boss_Defeat_FB")
	hint = get_node("CanvasLayer2/Hint")
	anim_feedback = get_node("CanvasLayer2/DefeatFB")
	bd_feedback.modulate.a = 0
	hint.modulate.a = 0
	
	reaper = get_node("CharacterBody2D")
	enemy_sprite = reaper.get_node("AnimationPlayer")
	enemy_asset = reaper.get_node("Sprite2D")
	enemy_body = reaper.get_node("CollisionShape2D")
	move_left = reaper.get_node("move_left")
	move_right = reaper.get_node("move_right")
	attack_left = reaper.get_node("left_attacks")
	attack_right = reaper.get_node("right_attacks")
	attack = reaper.get_node("attack_area/CollisionShape2D")
	
	hand = reaper.get_node("Magic_hand")
	hand_col = reaper.get_node("CollisionShape2D2")
	hand_anim = reaper.get_node("HandAnimation")
	prox = reaper.get_node("Prox_detection/CollisionShape2D")
	
	
	if !check_castle:
		statue.visible = false
		attack.disabled = true
		enemy_body.disabled = false
	else:
		reaper.queue_free()
		get_node("TileMap").clear_layer(2)
		get_node("StaticBody2D/CollisionShape2D").disabled = true
	
	markerA = get_node("Marker2D")
	
	speed = 120
	is_attacking = false
	is_moving = false
	points = 200
	player_close = false
	cooldown = false
	
	_player_set_up()

func _player_set_up():
	mc.scale = Vector2(0.7, 0.7)
	if !load:
		if left:
			mc.position = Vector2(markerA.position.x - 240, markerA.position.y - 200)
		elif right:
			pass
	else:
		mc.position = Vector2(markerA.position.x - 240, markerA.position.y - 200)
	
	anim_background.play("fade_out")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var collision
	
	if reaper != null:
		if attack_right.is_colliding() && attack_right.get_collider() != null && attack_right.get_collider().is_in_group("Persist"):
			enemy_asset.flip_h = true
			reaper.velocity.x = 0
			is_moving = false
			is_attacking = true
		elif attack_left.is_colliding() && attack_left.get_collider() != null && attack_left.get_collider().is_in_group("Persist"):
			enemy_asset.flip_h = false
			reaper.velocity.x = 0
			is_moving = false
			is_attacking = true
		else:
			is_attacking = false
			attack.disabled = true
		
		if move_right.is_colliding() && !is_attacking && move_right.get_collider() != null && move_right.get_collider().is_in_group("Persist"):
			enemy_asset.flip_h = true
			reaper.velocity.x = speed
			is_attacking = false
			is_moving = true
			enemy_body.disabled = false
		elif move_left.is_colliding() && !is_attacking && move_left.get_collider() != null && move_left.get_collider().is_in_group("Persist"):
			enemy_asset.flip_h = false
			reaper.velocity.x = -speed
			is_attacking = false
			is_moving = true
			enemy_body.disabled = false
			if !health_bar.visible:
				health_bar.visible = true
				get_node("AudioStreamPlayer").playing = true
				
		else:
			is_moving = false
		
		if !is_moving && !is_attacking:
			reaper.velocity.x = 0
			enemy_body.disabled = false
			
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
		attack.position.x = 212
		hand.position.x = 134.333
		hand_col.position.x = 124.333
		prox.position.x = 117.667
	else:
		enemy_asset.position.x = 0
		attack.position.x = -65
		hand.position.x = 14.333
		hand_col.position.x = 4.333
		prox.position.x = 17.667

func hit(body):
	set_physics_process(false)
	health.value -= 5 
	if health.value <= 0:
		body.add_points(points)
		death()
	else:
		enemy_sprite.play("take_hit")
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
	General.check_castle = true
	statue.visible = true
	anim_feedback.play("fade_in")
	await anim_feedback.animation_finished
	anim_feedback.play("fade_out")
	await anim_feedback.animation_finished
	get_node("AudioStreamPlayer").playing = false

func _on_attack_area_body_entered(body):
	if body.name == "Player":
		body.damage()
	
func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.name == "Player":
		anim_background.play("fade_in")
		await anim_background.animation_finished
		General.change_scene(false,false,false,"final_boss_area_1","castle",false,false,false,true)
		General.current_life = mc.get_node("Player").get_life()

func _on_prox_detection_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.name == "Player" && !cooldown:
		cooldown = true
		set_physics_process(false)
		enemy_sprite.play("summon")
		hand_anim.play("Summon")
		await hand_anim.animation_finished
		if reaper.get_node("Prox_detection").get_overlapping_bodies().has(body):
			body.damage()
		set_physics_process(true)
		await get_tree().create_timer(3.0).timeout
		cooldown = false
