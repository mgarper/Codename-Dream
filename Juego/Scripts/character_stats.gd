extends CanvasLayer

func _ready():
	self.get_node("./Node2D/Button").grab_focus()
	
	self.get_node("./Node2D/Level").text = str(General.level)
	self.get_node("./Node2D/StrengthLevel").text = str(General.max_strength)
	self.get_node("./Node2D/LifeLevel").text = str(General.max_life)

func _input(event):
	if Input.is_action_just_pressed("accept"):
		if $Node2D/Button.has_focus():
			$Node2D/Button.emit_signal("pressed")

func _on_button_pressed():
	General._open_menu()
	self.queue_free()
