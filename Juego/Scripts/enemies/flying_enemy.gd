extends CharacterBody2D

var MC_Detector_A
var MC_Detector_B
var Attack_Detector_A
var Attack_Detector_B
var enemy_sprite
var health_bar
var attack_area

var speed
var is_attacking
var is_moving

var points = 5

func _ready():
	MC_Detector_A = get_node("MC_detector_A")
	MC_Detector_B = get_node("MC_detector_B")
	Attack_Detector_A = get_node("Attack_detector_A")
	Attack_Detector_B = get_node("Attack_detector_B")
	enemy_sprite = get_node("AnimatedSprite2D")
	health_bar = get_node("ProgressBar")
	health_bar.value = 100
	health_bar.visible = false
	attack_area = get_node("Attack_Area/CollisionShape2D")
	attack_area.disabled = true
	
	speed = 50
	is_attacking = false
	is_moving = false
	
	enemy_sprite.play("Flight")

func _physics_process(delta):
	var collision
	velocity.y = 0
	if Attack_Detector_A.is_colliding():
		collision = Attack_Detector_A.get_collider()
		if collision.name == "Player":
			enemy_sprite.flip_h = false
			velocity.x = 0
			is_attacking = true
			enemy_sprite.play("Attack")
			attack_area.disabled = false
	elif Attack_Detector_B.is_colliding():
		collision = Attack_Detector_B.get_collider()
		if collision.name == "Player":
			enemy_sprite.flip_h = true
			velocity.x = 0
			is_attacking = true
			enemy_sprite.play("Attack")
			attack_area.disabled = false
	else:
		is_attacking = false
		attack_area.disabled = true
		enemy_sprite.play("Flight")
	
	if MC_Detector_A.is_colliding() && !is_attacking:
		collision = MC_Detector_A.get_collider()
		if collision != null and collision.name == "Player":
			enemy_sprite.flip_h = false
			velocity.x = speed
			is_attacking = false
			is_moving = true
			enemy_sprite.play("Flight")
	elif MC_Detector_B.is_colliding() && !is_attacking:
		collision = MC_Detector_B.get_collider()
		if collision != null and collision.name == "Player":
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

func hit(body):
	health_bar.value -= 40
	if health_bar.value < 100:
		health_bar.visible = true
	if health_bar.value <= 0:
		body.add_points(points)
		dead()
	enemy_sprite.play("take_hit")
	await enemy_sprite.animation_finished

func dead():
	set_physics_process(false)
	enemy_sprite.play("Death")
	await enemy_sprite.animation_finished
	self.queue_free()


func _on_attack_area_body_entered(body):
	if body.name == "Player":
		body.damage()
