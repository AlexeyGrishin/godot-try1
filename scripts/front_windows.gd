extends Node2D

export var floor_id = "1"

func _ready():
	pass

func _draw():
	var flr = global.model.get_floor(floor_id)
	for window in flr.windows:
		if not window.is_back and not window.broken:
			draw_polygon(
				PoolVector2Array(window.coords_to_draw),
				PoolColorArray([
					colors.window_front(window.index)
				])
			)
	for window in flr.windows:
		if not window.is_back :
			draw_polyline(
				PoolVector2Array(window.coords_to_draw),
				colors.WINDOW_EDGE
			)