extends Particles2D

func _ready():
	if not global.use_particles:
		emitting = false
		queue_free()

func _on_Timer_timeout():
	queue_free()