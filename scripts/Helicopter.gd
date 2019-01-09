extends KinematicBody2D

var bullet_ctor = preload("res://objects/HeliBullet.tscn")

const BULLET_RELOAD = 0.05

export var speed = 50
export var firing = false setget set_firing
export var emiting = false #todo: slow start, slow stop
export var bullets = 100
var reload = 0
var pad = 0
var camera

var health = 100

func _ready():
	var cameras = get_tree().get_nodes_in_group("camera")
	if cameras.size() > 0:
		camera = cameras[0]
	else:
		camera = self
	$AnimationPlayer.play("idle")
	pad = $HelicopterBody.frames.get_frame(
		$HelicopterBody.animation,
		$HelicopterBody.frame
	).get_height() / 2
	set_firing(firing)
	
func on_bullet_hit(bullet):
	health -= 1
	
func set_firing(val):
	firing = val and bullets > 0
	if $HelicopterBody != null:
		var anim = "idle"
		if val:
			anim = "rotating"
		$HelicopterBody/Gun.play(anim)
		$HelicopterBody/Gun/Fire.visible = val
		
func inc_health(v):
	health = min(100, health+v)
	
func inc_bullets(v):
	bullets = min(100, bullets+v)

func _physics_process(delta):
	var moveVector = Vector2(0, 0);
	if Input.is_action_pressed("ui_left"):
		moveVector.x = -1
	if Input.is_action_pressed("ui_right"):
		moveVector.x = +1
	if Input.is_action_pressed("ui_up"):
		moveVector.y = -1
	if Input.is_action_pressed("ui_down"):
		moveVector.y = +2
		
	self.move_and_collide(moveVector * speed * delta)
	
	var camera_offset = camera.position
	var vprect = get_viewport_rect()
	vprect.position += camera_offset
	self.position.y = clamp(self.position.y, 
		vprect.position.y + pad, 
		vprect.position.y + vprect.size.y - pad * 2);
		
	self._fire(delta)
	
	
func _fire(delta):
	if firing and bullets > 0:
		reload -= delta
		if reload < 0:
			reload = BULLET_RELOAD
			_emit_bullet()
			
func _emit_bullet():
	bullets -= 1
	var bullet = bullet_ctor.instance()
	get_parent().add_child(bullet)
	bullet.fly(
		self.position + $HelicopterBody.offset + Vector2(10, 14), 
		Vector2(0.8, 0.2)
	) 

		

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
