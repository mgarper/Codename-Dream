extends CharacterBody2D

@export var bullet:PackedScene

var sprite
var animation
var attack_detectorR
var attack_detectorL
var spawn_bullet

var speed
var direction

func _ready():
	sprite = $Sprite2D
	animation = $AnimationPlayer
	attack_detectorR = $right_detection
	attack_detectorL = $left_detection
	spawn_bullet = $Marker2D
	
	speed = 60
	direction = 1

func _physics_process(delta):
	
	if is_on_wall():
		direction *= -1
		
	velocity.x = speed * direction
	if velocity.x < 0:
		animation.play("run")
		sprite.flip_h = true
	elif velocity.x > 0:
		animation.play("run")
		sprite.flip_h = false
	
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
	set_physics_process(false)
	velocity.x = 0
	animation.play("attack")
	await animation.animation_finished
	set_physics_process(true)

func shoot():
	var new_bullet = bullet.instantiate()
	new_bullet.position = spawn_bullet.global_position
	get_parent().add_child(new_bullet)
