extends CharacterBody2D

var anim
var sprite
var attack_detection

var max_speed = 200
var jump = 200
var gravity = 450

var switch_attacks = false
var is_dashing = false
var is_double_jump = false
var can_double_jump = true

func _ready():
	anim = $AnimationPlayer
	sprite = $Sprite2D
	attack_detection = $Attack_Detector

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
			
		if velocity.y < 0:
			if !is_double_jump:
				anim.play("JUMP")
			else:
				anim.play("DOUBLE_JUMP")
				
		elif velocity.y > 0:
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

func _on_detector_body_entered(body):
	if body.name == "flying_enemy":
		body.dead()
