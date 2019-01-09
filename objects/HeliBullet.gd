extends KinematicBody2D

var DEFAULT_SPEED = 1000
var speed
var direction_vector

func fly(origin_vector, direction_vector, speed = DEFAULT_SPEED):
	self.position = origin_vector
	self.speed = speed
	self.direction_vector = direction_vector
	
	
	
func _process(delta):
	var collision = self.move_and_collide(direction_vector * speed * delta)
	if collision != null:
		if collision.collider.has_method("on_bullet_hit"):
			collision.collider.on_bullet_hit(self)
		queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
