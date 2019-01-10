extends Node

const FLOOR = Color("#556666")
const FLOOR_HIGHLIGHT = Color("#20ff0000")
const FLOOR_DONE = Color("#447744")

#72a3b0
const WINDOW_FRONT = Color("#3372a3b0") #Color(0, 0.4, 0.8, 0.3)
const WINDOW_BACK = Color("#aa46656d") #Color(0, 0.2, 0.6, 0.6)
const WINDOW_EDGE = Color("#8872a3b0")
const LIGHT_VECTOR = Vector2(1, 0)

func light(angle):
	var v1 = Vector2(cos(angle), sin(angle))
	return LIGHT_VECTOR.dot(v1)


func window_front(i):
	var light = light(PI*2* i/global.WINDOWS_COUNT)
	var color = WINDOW_FRONT#*(0.8 + 0.5*light)
	color.a = WINDOW_FRONT.a
	return color

func window_back(i):
	var light = light(PI*2* i/global.WINDOWS_COUNT)
	var color = WINDOW_BACK#*(0.8 + 0.5*light)
	color.a = WINDOW_BACK.a
	return color

func _ready():
	pass
