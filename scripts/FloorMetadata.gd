tool
extends Node2D

export var title = "Floor title"
export var size = 400
export var id = "1"
export var top_size = 400
export var height = 80

export var boss_depends = false
export(PackedScene) var resurrect_scene = null

func _draw():
	var radius = size / 2
	self.draw_circle(Vector2(0, 0), radius, Color(0, 0, 0, 0.1))
	
	