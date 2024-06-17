extends CharacterBody2D

var raycastDL
var raycastDR
var sprite
var animation
var attack_detectorL
var attack_detectorR
var attack_area
var health_bar

var speed
var is_waiting 

func _ready():
	sprite = $Sprite2D
	raycastDL = $DownLeft
	raycastDR = $DownRight
	animation = $AnimationPlayer
	attack_detectorL = $Left
	attack_detectorR = $Right
	attack_area = $Area2D
	health_bar = $ProgressBar
	health_bar.value = 100
	health_bar.visible = false
	
	speed = 120
	is_waiting = false

func _physics_process(delta):
	if is_waiting:
		return
	
	if !raycastDL.is_colliding():
		velocity.x = speed
	elif !raycastDR.is_colliding():
		velocity.x = -speed
	
	if velocity.x < 0:
		sprite.flip_h = true
		animation.play("run")
		attack_area.position.x = -50
	elif velocity.x > 0:
		sprite.flip_h = false
		animation.play("run")
		attack_area.position.x = 0
	
	move_and_slide()
	detection()

func detection():
	var collision
	if attack_detectorL.is_colliding():
		collision = attack_detectorL.get_collider()
		if collision.name == "Player":
			sprite.flip_h = true
			attack()
	elif attack_detectorR.is_colliding():
		collision = attack_detectorR.get_collider()
		if collision.name == "Player":
			sprite.flip_h = false
			attack()

func attack():
	velocity.x = 0
	animation.play("attack")
	await animation.animation_finished
	if sprite.flip_h:
		velocity.x = -speed
	else:
		velocity.x = speed


func _player_body_detected(body):
	if body.name == "Player":
		body.damage("patrol_enemy")

func hit():
	set_physics_process(false)
	health_bar.value -= 30
	if health_bar.value < 100:
		health_bar.visible = true
	if health_bar.value <= 0:
		dead()
		return
	animation.play("take_hit")
	await animation.animation_finished
	set_physics_process(true)
	

func dead():
	set_physics_process(false)
	animation.play("death")
	await animation.animation_finished
	self.queue_free()
