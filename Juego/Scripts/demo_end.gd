extends Node2D

var button
# Called when the node enters the scene tree for the first time.
func _ready():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	button = get_node("CanvasLayer/Button")
	var label = get_node("CanvasLayer/Label")
	var button_sprite = get_node("CanvasLayer/Sprite2D")
	var mc = get_node("CanvasLayer/Main_Character")
	var dog = get_node("CanvasLayer/Dog")
	var mc_moves = get_node("CanvasLayer/MC_Moves")
	var dog_moves = get_node("CanvasLayer/Dog_Moves")
	var fade = get_node("fade")
	
	button.disabled = true
	
	label.modulate.a = 0
	button.modulate.a = 0
	button_sprite.modulate.a = 0
	mc.modulate.a = 0
	dog.modulate.a = 0
	
	mc_moves.play("RUN")
	dog_moves.play("RUN")
	
	fade.play("fade_in")
	await fade.animation_finished
	
	button.disabled = false
	button.grab_focus()

func _input(event):
	if Input.is_action_just_pressed("accept"):
		if button.has_focus():
			button.emit_signal("pressed")


func _on_button_pressed():
	General.change_scene(false,false,false,"demo_end","main_menu",false,false,false,false)
