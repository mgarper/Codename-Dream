extends Node2D

var layer1
var layer2
var layer3

# Called when the node enters the scene tree for the first time.
func _ready():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	$MC_Moves.play("RUN")
	$Dog_Moves.play("RUN")
	var camera = $Camera2D
	
	layer1 = $CanvasLayer/ParallaxBackground/ParallaxLayer
	layer2 = $CanvasLayer/ParallaxBackground/ParallaxLayer2
	layer3 = $CanvasLayer/ParallaxBackground/ParallaxLayer3


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	layer1.motion_offset.x += 1
	layer2.motion_offset.x += 2
	layer3.motion_offset.x += 4


func _on_button_pressed():
	General.change_scene("Menu","Forest")


func _on_button_2_pressed():
	get_tree().quit()
