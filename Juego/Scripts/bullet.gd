extends Area2D

var speed
var direction

func _ready():
	speed = 25
	direction = 1

func _physics_process(delta):
	position.x += speed * direction
