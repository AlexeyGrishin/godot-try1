extends Node2D

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		$AnimationPlayer.stop()
		$AnimationPlayer.play("fade")


func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().change_scene("res://Main.tscn")
