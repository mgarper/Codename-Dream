extends CharacterBody2D

var MC_Detector_A
var MC_Detector_B
var Attack_Detector_A
var Attack_Detector_B
var enemy_sprite


var speed
var is_attacking
var is_moving

func _ready():
	MC_Detector_A = $MC_detector_A
	MC_Detector_B = $MC_detector_B
	Attack_Detector_A = $Attack_detector_A
	Attack_Detector_B = $Attack_detector_B
	enemy_sprite = $AnimatedSprite2D
	
	speed = 50
	is_attacking = false
	is_moving = false
	
	enemy_sprite.play("Flight")

func _physics_process(delta):
	var collision
	
	if Attack_Detector_A.is_colliding():
		collision = Attack_Detector_A.get_collider()
		if collision.name == "Player":
			enemy_sprite.flip_h = false
			velocity.x = speed + 10
			is_attacking = true
			enemy_sprite.play("Attack")
	elif Attack_Detector_B.is_colliding():
		collision = Attack_Detector_B.get_collider()
		if collision.name == "Player":
			enemy_sprite.flip_h = true
			velocity.x = -speed - 10
			is_attacking = true
			enemy_sprite.play("Attack")
	else:
		is_attacking = false
	
	if MC_Detector_A.is_colliding() && !is_attacking:
		collision = MC_Detector_A.get_collider()
		if collision.name == "Player":
			enemy_sprite.flip_h = false
			velocity.x = speed
			is_attacking = false
			is_moving = true
			enemy_sprite.play("Flight")
	elif MC_Detector_B.is_colliding() && !is_attacking:
		collision = MC_Detector_B.get_collider()
		if collision.name == "Player":
			enemy_sprite.flip_h = true
			velocity.x = -speed
			is_attacking = false
			is_moving = true
			enemy_sprite.play("Flight")
	else:
		is_moving = false
	
	
	
	
	
	if !is_moving && !is_attacking:
		velocity.x = 0
	
	move_and_slide()



func dead():
	set_physics_process(false)
	enemy_sprite.play("Death")
	await enemy_sprite.animation_finished
	self.queue_free()
