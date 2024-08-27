extends CharacterBody2D

var anim
var sprite
var attack_detection
var health_sprite
var health_bar
var camera
var score
var death_view
var you_dead
var container
var retry
var frameR
var to_menu
var frameM
var fade
var load_feedback
var player_anim
var dog_anim

var max_speed = 200
var jump = 200
var gravity = 450
var life

var hit = false
var switch_attacks = false
var is_dashing = false
var is_double_jump = false
var can_double_jump = true

var max_life = 5
var max_strength = 1
var current_points = 0
var level = 1
var check_castle = false

func _ready():
	life = General.current_life
	anim = get_node("AnimationPlayer")
	sprite = get_node("Sprite2D")
	attack_detection = get_node("Attack_Detector")
	camera = get_node("Camera2D")
	health_sprite = get_node("../CanvasLayer/Sprite2D")
	health_bar = get_node("../CanvasLayer/health_bar")
	health_sprite.frame = set_life_frame(false)
	score = get_node("../CanvasLayer2/Label")
	score.text = "0"
	death_view = get_node("../Death_View/ColorRect")
	death_view.modulate.a = 0
	you_dead = get_node("../Death_View/Label")
	you_dead.modulate.a = 0
	container = get_node("../Death_View/HBoxContainer")
	container.modulate.a = 0
	retry = get_node("../Death_View/HBoxContainer/Button")
	retry.disabled = true
	frameR = get_node("../Death_View/Sprite2D")
	frameR.modulate.a = 0
	to_menu = get_node("../Death_View/HBoxContainer/Button2")
	to_menu.disabled = true
	frameM = get_node("../Death_View/Sprite2D2")
	frameM.modulate.a = 0
	fade = get_node("../Death_View/fade")
	load_feedback = get_node("../LoadingFeedback")
	load_feedback.visible = false
	player_anim = get_node("../LoadingFeedback/MC_Moves")
	dog_anim = get_node("../LoadingFeedback/Dog_Moves")
	

#Bucle que se repite cada delta tiempo, procesando fisicas
func _physics_process(delta):
	#Positivo y negativo estan invertidos en el eje y de Godot Engine
	velocity.y += gravity*delta
	
	
	#Bloque de control para la interaccion con mando/teclado
	if Input.is_action_pressed("move_right"):
		#Velocidad a la derecha --> velocity.x > 0
		attack_detection.position.x = 426.471
		velocity.x = max_speed
		
	elif Input.is_action_pressed("move_left"):
		#Velocidad a la izquierda --> velocity.x < 0
		attack_detection.position.x = 379.309
		velocity.x = -max_speed
		
	else:
		#Estatico --> velocity.x = 0
		velocity.x = 0
	
	if is_on_floor():
		can_double_jump = true
	
	if Input.is_action_just_pressed("jump") && is_on_floor():
		velocity.y = -jump
		is_double_jump = false
		
	if Input.is_action_just_pressed("jump") && !is_on_floor() && can_double_jump:
		velocity.y = -jump
		is_double_jump = true
		can_double_jump = false
	
	if Input.is_action_just_pressed("dash") && is_on_floor() && velocity.x != 0:
		velocity.x *= 10
		is_dashing = true
	#Aplica los movimientos a la escena
	move_and_slide()
	_apply_animation()

func _apply_animation():
	
	if !is_dashing:
		if is_on_floor():
			if velocity.x > 0:
				anim.play("RUN")
				sprite.flip_h = false
			elif velocity.x < 0:
				anim.play("RUN")
				sprite.flip_h = true
			else:
				anim.play("IDLE")
			
		if velocity.y < 0 && !hit:
			if !is_double_jump:
				anim.play("JUMP")
			else:
				anim.play("DOUBLE_JUMP")
				
		elif velocity.y > 0 && !hit:
			anim.play("FALL")
			
	else:
		anim.play("DASH")
		if velocity.x > 0:
			sprite.flip_h = false
		elif velocity.x < 0:
			sprite.flip_h = true
		await anim.animation_finished
		is_dashing = false

#Funcion predefinida de Godot para gestionar eventos de input fuera de physics process
func _input(event):
	if sprite != null:
		if Input.is_action_just_pressed("attack") && is_on_floor():
			#Para el bucle de procesamiento de fisicas
			set_physics_process(false)
			if !switch_attacks:
				anim.play("ATTACK_A")
				switch_attacks = true
			else:
				anim.play("ATTACK_B")
				switch_attacks = false
			await anim.animation_finished #Espera a que la animación termine
			set_physics_process(true)
			
		if Input.is_action_just_pressed("move_left"):
			sprite.flip_h = true
		elif Input.is_action_just_pressed("move_right"):
			sprite.flip_h = false
			
		if Input.is_action_just_pressed("block") && is_on_floor():
			set_physics_process(false)
			anim.play("BLOCK")
			await anim.animation_finished #Espera a que la animación termine
			set_physics_process(true)
	else:
		if Input.is_action_just_pressed("accept"):
			if retry.has_focus():
				retry.emit_signal("pressed")
			else:
				to_menu.emit_signal("pressed")

func damage():
	life -= 1
	if life == 0:
		dead()
	var animation = "life_" + str(life)
	health_bar.play(animation)
	velocity.y = -150
	move_and_slide()
	anim.play("HIT")
	await anim.animation_finished
	velocity = Vector2.ZERO
	hit = false

func dead():
	set_physics_process(false)
	$CollisionShape2D.disabled = true
	health_bar.play("death")
	anim.play("DEAD")
	await anim.animation_finished
	fade.play("fade_in")
	await fade.animation_finished
	retry.disabled = false
	to_menu.disabled = false
	retry.grab_focus()
	sprite.queue_free()
	current_points = 0
	var save_file = FileAccess.open(OS.get_user_data_dir() + "/ONIROS/Save_Files/savegame.save", FileAccess.WRITE)
	# Call the node's save function.
	var node_data = save(General.last_save)
	# JSON provides a static method to serialized JSON string.
	var json_string = JSON.stringify(node_data)
	# Store the save dictionary as a new line in the save file.
	save_file.store_line(json_string)

func set_attributes(m_life, strength, points, level, castle):
	max_life = m_life
	max_strength = strength
	current_points = points
	level = level
	check_castle = castle
	update_points()

func add_points(points):
	current_points = current_points + points
	update_points()
	General.update_points(points)

func update_points():
	score.text = "" + str(current_points)

func save(last_place):
	var save_dict = {
		"last_place" : last_place,
		"max_life" : General.max_life,
		"max_strength" : General.max_strength,
		"current_points" : current_points,
		"level" : General.level,
		"check_castle" : General.check_castle
	}
	General.last_save = last_place
	return save_dict

func get_life():
	return life

func set_life_frame(action_type):
	var frame
	if action_type:
		frame = 0.0
		match int(life):
			1:
				frame = 0.2
			2:
				frame = 0.5
			3:
				frame = 0.8
			4:
				frame = 1.1
	else: 
		frame = 0
		match int(life):
			1:
				frame = 12
			2:
				frame = 9
			3:
				frame = 6
			4:
				frame = 3
			5:
				frame = 0
	return frame

func restore_life():
	if life != max_life:
		#0.2 + (life - 1) + 0.3
		health_bar.play("restore")
		health_bar.seek(set_life_frame(true))
		await health_bar.animation_finished
		life = max_life

func loading_feedback():
	load_feedback.visible = true
	dog_anim.play("RUN")
	player_anim.play("RUN")
	await get_tree().create_timer(3.0).timeout
	load_feedback.visible = false

func _on_player_ready():
	if General.load_game:
		General.load_game = false
	set_attributes(General.max_life,General.max_strength,General.current_points,General.level,General.check_castle)

func _on_detector_body_entered(body):
	if body.is_in_group("Enemy"):
		body.hit(self)
	elif body.is_in_group("BossEnemy"):
		body.get_parent().hit(self)

func _on_button_pressed():
	General.retry()

func _on_button_2_pressed():
	General.change_scene(false,false,false,"path.name","main_menu","false","false","false","false")
