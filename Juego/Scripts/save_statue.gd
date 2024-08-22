extends Node2D

func _on_ready():
	$Label.visible = false

func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.name == "Player":
		$Label.visible = true

func _on_area_2d_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if body.name == "Player":
		$Label.visible = false
		
func _input(event):
	if Input.is_action_just_pressed("interaction") && $Label.visible == true:
		_save_game()

func _save_game():
	var save_file = FileAccess.open("C:/Users/USUARIO/Documents/ONIROS/Save_Files/savegame.save", FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		# Call the node's save function.
		var node_data = node.save(get_parent().get_path())
		# JSON provides a static method to serialized JSON string.
		var json_string = JSON.stringify(node_data)
		# Store the save dictionary as a new line in the save file.
		save_file.store_line(json_string)
