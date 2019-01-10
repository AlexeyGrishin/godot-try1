extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	self.angular_velocity = randf() * 60
	pass

func set_random_wood():
	set_random_animation("wood")
	
func set_random_animation(anim):
	self.add_to_group(anim)
	$AnimatedSprite.animation = anim
	$AnimatedSprite.frame = randi() % $AnimatedSprite.frames.get_frame_count(anim)
	

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Sharp_sleeping_state_changed():
	if sleeping:
		$Timer.start()
	else:
		$Timer.stop()


func _on_Timer_timeout():
	queue_free()


func _on_Lifetimer_timeout():
	queue_free()
