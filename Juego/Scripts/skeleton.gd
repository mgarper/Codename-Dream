extends CharacterBody2D

var raycastDL
var raycastDR
var sprite
var animation
var attack_detectorL
var attack_detectorR
var attack_area
var health_bar
var skeleton_body

var speed
var direction
var is_waiting 
var life_amount

func _ready():
	sprite = $Sprite2D
	raycastDL = $raycastDL
	raycastDR = $raycastDR
	animation = $AnimationPlayer
	attack_detectorL = $attack_detectorL
	attack_detectorR = $attack_detectorR
	attack_area = $Area2D
	health_bar = $ProgressBar
	skeleton_body = $CollisionShape2D
	health_bar.value = 100
	health_bar.visible = false
	
	speed = 120
	life_amount = 3
	direction = 1

func _physics_process(delta):
	if is_on_wall():
		direction *= -1
		velocity.x = speed * direction
	
	if !raycastDL.is_colliding():
		velocity.x = speed 
	elif !raycastDR.is_colliding():
		velocity.x = -speed
	
	if velocity.x < 0:
		sprite.flip_h = true
		animation.play("walk")
		attack_area.position.x = 130
	elif velocity.x > 0:
		sprite.flip_h = false
		animation.play("walk")
		attack_area.position.x = 284
	
	move_and_slide()
	detection()

func detection():
	var collision
	if attack_detectorL.is_colliding():
		collision = attack_detectorL.get_collider()
		if collision.name == "Player":
			sprite.flip_h = true
			attack_area.position.x = 153
			attack()
	elif attack_detectorR.is_colliding():
		collision = attack_detectorR.get_collider()
		if collision.name == "Player":
			sprite.flip_h = false
			attack_area.position.x = 261
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
		body.damage("skeleton")

func hit():
	set_physics_process(false)
	health_bar.value -= 40
	if health_bar.value < 100:
		health_bar.visible = true
	if health_bar.value <= 0:
		dead()
		return
	animation.play("take_hit")
	await animation.animation_finished
	set_physics_process(true)
	

func dead():
	life_amount -= 1
	set_physics_process(false)
	animation.play("death")
	await animation.animation_finished
	if life_amount == 0:
		self.queue_free()
	else: 
		skeleton_body.disabled = true
		health_bar.visible = false
		set_life_color(life_amount)
		await get_tree().create_timer(5.0).timeout
		animation.play("revive")
		await animation.animation_finished
		animation.play("idle")
		health_bar.value = 100
		await get_tree().create_timer(1.5).timeout
		skeleton_body.disabled = false
		set_physics_process(true)

func set_life_color(lifes_left):
	var color
	if lifes_left == 2:
		color = Color.ORANGE
	else:
		color = Color.RED
	var style_box = health_bar.get_theme_stylebox("fill", "ProgressBar") as StyleBoxFlat
	style_box.bg_color = color
