extends MarginContainer

func _process(delta):
	$VBoxContainer/Label.text = "FPS: %d" % Engine.get_frames_per_second()
	$VBoxContainer/Objects.text = "Objects: %d" % Performance.get_monitor(Performance.PHYSICS_2D_ACTIVE_OBJECTS)


func update_helicopter_stats(helicopter):
	$VBoxContainer/HBoxContainer/ProgressBar.value = helicopter.health
	$VBoxContainer/HBoxContainer2/ProgressBar.value = helicopter.bullets