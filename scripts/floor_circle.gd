extends Node2D

export var radius = 200
export var floor_id = 1

func _ready():
	pass


func _draw():
	var is_clear = global.model.get_floor(floor_id).clear
	var color;
	if is_clear:
		color = colors.FLOOR_DONE
	else:
		color = colors.FLOOR
	var coords = global.get_floor_coords_abs(global.model.angle, Vector2(0, 0), radius)
	draw_polygon(
		PoolVector2Array (coords),
		PoolColorArray([color])
	)
	if not is_clear:
		#draw_circle(Vector2(0, 0), radius, Color("#000000"))
		draw_rect(Rect2(-radius+5, -global.ATTACK_HALF_SIZE, radius*2-10, global.ATTACK_HALF_SIZE*2), colors.FLOOR_HIGHLIGHT)
	coords = global.get_bottom_floor_coords_abs(global.model.angle, Vector2(0, 0), radius, 100)
	#draw_polygon(
	#	PoolVector2Array (coords),
	#	PoolColorArray(["#000000"])
	#)
	#draw_circle(Vector2(0, 0), radius, Color("#000000"))
