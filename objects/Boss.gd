extends "BaseEnemy.gd"

var bullet_ctor = preload("res://objects/EnemyBullet.tscn")

var shots = 0

const SUPER_SHOT_EVERY = 4

const SIMPLE_SPEED = 600
const SUPER_SPEED = 150
const AFTER_SUPER_SPEED = 50

const SUPER_BULLETS = 3
const BULLETS_IN_BULLET = 10

var super_bullets = []

var firing = false
var shooting_now = false

func post_init():
	hp = 1000
	$ReloadTimer.wait_time = 1
	if get_viewport() == get_parent():
		target = Node2D.new()
		self.add_child(target)
		target.position = Vector2(-400+200, -400+300)
		self.position.x = 400
		self.position.y = 400
		last_target = target
		do_start_fire()	

#func post_process(delta):
#	if Input.is_action_just_pressed("debug_1"):
#		do_destroy(Vector2(100,10))

func do_fire_after_reload():
	if not firing or shooting_now:
		return
	shooting_now = true
	$ReloadTimer.stop()
	shots += 1
	if shots % SUPER_SHOT_EVERY == 0:
		$SuperFire.play()
		$AnimationPlayer.play("boss_super_fire")
	else:
		$Sprite.play("fire1")
		$StandardFire.play()
		$AnimationPlayer.play("boss_simple_fire")

func do_super_shot1():
	$Sprite.play("fire2")		

func do_super_shot2():
	for b in range(SUPER_BULLETS):
		var bullet = bullet_ctor.instance()
		var vec = Vector2(-3,-1).normalized()
		vec = vec.normalized() * SUPER_SPEED * rand_range(0.9, 1.2)
		get_parent().add_child(bullet)
		bullet.set_animation("boss_bullet")
		bullet.mass = 40
		bullet.use_trail(4)
		bullet.damage = 10
		bullet.gravity_scale = 0.5
		bullet.position = self.position + Vector2(-32, -26)
		#bullet.rotation = vec.angle()
		bullet.throw(vec, true)	
		super_bullets.append(weakref(bullet))
	
func do_super_shot3():
	for b in super_bullets:
		if !b.get_ref():
			continue
		for i in range(BULLETS_IN_BULLET):
			var vec = Vector2(rand_range(-100, 100), rand_range(-100,100)).normalized()
			var bullet = bullet_ctor.instance()
			vec = vec.normalized() * AFTER_SUPER_SPEED
			get_parent().add_child(bullet)
			bullet.set_animation("mortar_bullet")
			bullet.position = b.get_ref().position
			bullet.rotation = vec.angle()
			bullet.damage = 5
			bullet.throw(vec, true)	
		b.get_ref().queue_free()
	super_bullets = []
	
func do_simple_shot():
	var bullet = bullet_ctor.instance()
	var vec = Vector2(-1,rand_range(-0.05, 0.05)).normalized()
	vec = vec.normalized() * SIMPLE_SPEED * rand_range(0.9, 1.2)
	get_parent().add_child(bullet)
	bullet.set_animation("mortar_bullet")
	bullet.mass = 4
	bullet.use_trail(8)
	bullet.damage = 5
	bullet.position = self.position + Vector2(-26, -16)
	#bullet.rotation = vec.angle()
	bullet.throw(vec, true)		
	
	
func do_start_fire():
	if not shooting_now:
		$ReloadTimer.start()
	firing = true
	do_fire_after_reload()
	
func do_stop_fire():
	#$ReloadTimer.stop()
	firing = false


func do_destroy(velocity):
	var util = get_node("/root/util")
	util.drop_sharps("flesh", 50, Rect2(self.position + $Sprite.offset, Vector2(16, 16)), velocity, self.get_parent())
	global.emit_signal("on_boss_kill", self)
	self.emit_signal("on_destroy", self)
	self.queue_free()

func _on_AnimationPlayer_animation_finished(anim_name):
	shooting_now = false
	if anim_name == "boss_simple_fire" or anim_name == "boss_super_fire":
		$Sprite.stop()
		$Sprite.play("idle")
		if firing:
			$ReloadTimer.start()


func _on_VisibilityNotifier2D_screen_entered():
	global.emit_signal("on_boss_appear", self)
