extends StaticBody2D

var scene_ctor = preload("res://objects/FloorHit.tscn")

func _ready():
	pass

func on_bullet_hit(bullet):
	var hit = scene_ctor.instance()
	hit.position = bullet.position
	hit.emitting = true
	if not bullet.is_in_group("heli_bullet"):
		hit.rotation_degrees -= 120
		hit.scale = Vector2(0.5, 0.5)
	bullet.get_parent().add_child(hit)
