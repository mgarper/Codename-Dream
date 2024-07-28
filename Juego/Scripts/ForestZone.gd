extends Node2D

func _ready():
	var mc = $MAIN_CHARACTER
	var marker = $Marker2D
	
	if General.dead || General.first_load:
		pass
	else:
		mc.position = Vector2(marker.position.x - 240, marker.position.y - 150)

func _on_to_village_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.name == "Player":
		General.change_scene("Forest","Village")
