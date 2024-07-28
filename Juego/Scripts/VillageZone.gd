extends Node2D

var player_camera 

# Called when the node enters the scene tree for the first time.
func _ready():
	player_camera = $MAIN_CHARACTER/Player/Camera2D
	
	player_camera.limit_left = 0
	player_camera.limit_bottom = get_viewport().size.y


func _on_to_forest_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.name == "Player":
		General.change_scene("Village","Forest")
