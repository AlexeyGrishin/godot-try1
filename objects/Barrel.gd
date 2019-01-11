extends "BaseEnemy.gd"

var bullet_ctor = preload("res://objects/EnemyBullet.tscn")
	
var speed = 200
var exploding = false
var bullets = 4
var debug_scene = false
var damage = 4
var bounce = 0

var sound
func _ready():
	debug_scene = get_viewport() == get_parent()
	if debug_scene:
		position += Vector2(400, 400)
	sound = $Explode
	remove_child(sound)
	get_parent().add_child(sound)

func on_hit(by):
	if exploding:
		return
	decrease_hp(by)
	if hp < 0:
		self.explode()
		
func _process(delta):
	if debug_scene and Input.is_action_just_pressed("debug_1"):
		explode()
		
func explode():
	exploding = true
	$Sprite.play("fire")
	sound.play()
	for b in range(bullets):
		var vec = Vector2(rand_range(-100, 100), rand_range(-10,-20)).normalized()
		var bullet = bullet_ctor.instance()
		vec = vec.normalized() * speed
		get_parent().add_child(bullet)
		bullet.set_kill_people(true, damage)
		bullet.set_animation("mortar_bullet")
		bullet.position = self.position + Vector2(-6, -8)
		bullet.rotation = vec.angle()
		bullet.bounce = bounce
		bullet.throw(vec, true)		
		

func _on_Sprite_animation_finished():
	self.emit_signal("on_destroy", self)
	self.queue_free()