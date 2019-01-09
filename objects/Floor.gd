tool
extends StaticBody2D

export(float) var width = 400
export(float) var height = 8

var ASPECT = 0.02
var RASPECT = 1/ASPECT

func _ready():
	$CollisionShape2D.shape.extents.x = width/2
	$CollisionShape2D.shape.extents.y = height/2
	pass
	
func _draw():
	draw_set_transform(Vector2(0, 0), 0, Vector2(1, 0.02))
	#draw_rect(Rect2(-width/2, -height/2, width, height), Color("#000000"), true)
	for i in range(height):
		draw_circle(Vector2(0, i*RASPECT), width/2, Color("#cccccc"))
	
