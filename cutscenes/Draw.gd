extends Node2D

func _draw():
	draw_rect(Rect2(0, 0, 200, 50), colors.WINDOW_BACK, true)
	draw_rect(Rect2(0, 50, 200, 100), colors.FLOOR, true)
