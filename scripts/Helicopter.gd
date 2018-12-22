extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var speed = 50

func _ready():
	$AnimationPlayer.play("idle")
	pass

func _physics_process(delta):
	
	var dx = 0
	var dy = 0
	if Input.is_action_pressed("ui_left"):
		dx = -1
	if Input.is_action_pressed("ui_right"):
		dx = +1
	if Input.is_action_pressed("ui_up"):
		dy = -1
	if Input.is_action_pressed("ui_down"):
		dy = +2
		
	position.x += dx*speed*delta
	position.y += dy*speed*delta
	

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
