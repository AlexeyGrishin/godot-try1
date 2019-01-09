extends "Sharp.gd"

func _ready():
	self.angular_velocity = 0.0


func set_animation(name):
	$AnimatedSprite.animation = name
	$AnimatedSprite.frame = 0
	
func throw(velocity_vector, use_gravity):
	if not use_gravity:
		self.gravity_scale = 0
	apply_impulse(Vector2(0, 0), velocity_vector)
	
func use_trail(amount = 32):
	if amount == 0:
		$Particles2D.emitting = false
	else:
		$Particles2D.amount = amount

func _on_Sharp_body_entered(body):
	body.on_bullet_hit(self)
	self.queue_free()
