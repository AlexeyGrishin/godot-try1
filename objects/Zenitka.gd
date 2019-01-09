extends "BaseEnemy.gd"

var bullet_ctor = preload("res://objects/EnemyBullet.tscn")
	
const SPEED = 500
const SALVO = 1
	
func post_init():
	$ReloadTimer.wait_time = 0.1
	if get_viewport() == get_parent():
		target = Node2D.new()
		self.add_child(target)
		target.position = Vector2(-400+200, -400+300)
		self.position.x = 400
		self.position.y = 400
		last_target = target
		do_start_fire()



func do_fire_after_reload():
	$Sprite.stop()
	$Sprite.play("fire")
	
	
func do_start_fire():
	$ReloadTimer.start()
	do_fire_after_reload()
	
func do_stop_fire():
	$ReloadTimer.stop()
	$Sprite.play("idle")


func _on_Sprite_animation_finished():
	if $Sprite.animation == "fire":
		for b in range(SALVO):
			var bullet = bullet_ctor.instance()
			var vec = last_target.to_global(Vector2(0, 0)) - self.to_global(Vector2(0, 0))
			vec += Vector2(rand_range(-60, 60), rand_range(-50, 50))
			vec = vec.normalized() * SPEED
			get_parent().add_child(bullet)
			bullet.set_animation("bullet2")
			bullet.position = self.position + Vector2(-6, -8)
			bullet.rotation = vec.angle()
			bullet.use_trail(0)
			bullet.throw(vec, false)
		$Sprite.frame = 0
		
func _process(delta):
	if Input.is_action_just_pressed("debug_1"):
		print(Engine.get_frames_per_second())
		print(Performance.get_monitor(Performance.PHYSICS_2D_ACTIVE_OBJECTS))
