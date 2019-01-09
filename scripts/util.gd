extends Node

var sharpScene = preload("res://objects/Sharp.tscn")

func _ready():
	pass

func drop_sharps(sharp_type, count, position_rect, velocity_vector, container):
	for i in range(count):
		var sharp = sharpScene.instance()
		container.add_child(sharp)
		sharp.position.x = rand_range(position_rect.position.x, position_rect.end.x)
		sharp.position.y = rand_range(position_rect.position.y, position_rect.end.y)
		sharp.set_random_animation(sharp_type)
		var velocity = velocity_vector
		velocity.x += rand_range(-10, 10)
		velocity.y += rand_range(-10, 10)
		sharp.apply_impulse(Vector2(1,1), velocity_vector*rand_range(0.9, 1.1))
