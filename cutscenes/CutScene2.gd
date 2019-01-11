extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func break_window():
	$Glass.play()
	util.drop_sharps("glass", 10, Rect2(-10, 0, 10, 100), Vector2(200, 0), $CanvasLayer)
	$Rotor.stop()