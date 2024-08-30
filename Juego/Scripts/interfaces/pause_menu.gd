extends CanvasLayer

func _ready():
	self.get_node("./CanvasLayer/VBoxContainer/Button").grab_focus()
	if !get_tree().paused:
		get_tree().paused = true
	print(get_tree().paused)

func _input(event):
	if Input.is_action_just_pressed("accept"):
		if $CanvasLayer/VBoxContainer/Button.has_focus():
			$CanvasLayer/VBoxContainer/Button.emit_signal("pressed")
		elif $CanvasLayer/VBoxContainer/Button2.has_focus():
			$CanvasLayer/VBoxContainer/Button2.emit_signal("pressed")
		else:
			$CanvasLayer/VBoxContainer/Button3.emit_signal("pressed")

func _on_button_pressed():
	get_tree().paused = not get_tree().paused
	self.queue_free()

func _on_button_2_pressed():
	General._check_character_stats()
	self.queue_free()

func _on_button_3_pressed():
	var path = get_parent().get_parent()
	get_tree().paused = not get_tree().paused
	General.change_scene(false,false,false,path.name,"main_menu","false","false","false","false")
