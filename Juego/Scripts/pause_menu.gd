extends CanvasLayer


var layer1
var layer2
var layer3

# Called when the node enters the scene tree for the first time.
func _ready():
	$CanvasLayer.visible = false
	$CanvasLayer/VBoxContainer/Button.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		_toggle_pause()

func _toggle_pause():
	get_tree().paused = not get_tree().paused
	$CanvasLayer.visible = not $CanvasLayer.visible


func _on_button_pressed():
	_toggle_pause()


func _on_button_2_pressed():
	pass # Replace with function body.


func _on_button_3_pressed():
	var path = get_parent().get_parent()
	get_tree().paused = not get_tree().paused
	General.change_scene(path.name,"main_menu")
