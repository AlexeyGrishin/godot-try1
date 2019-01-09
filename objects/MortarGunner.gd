extends "BaseEnemy.gd"


var bullet_ctor = preload("res://objects/EnemyBullet.tscn")
	
const SPEED = 200
	
func post_init():
	$ReloadTimer.wait_time = 5
	if get_viewport() == get_parent():
		target = Node2D.new()
		get_viewport().add_child(target)
		target.position = Vector2(200, 300)
		self.position.x = 400
		self.position.y = 400
		last_target = target
		do_start_fire()
		$Sprite.play("fire")



func do_fire_after_reload():
	$Sprite.play("fire")
	
	
func do_start_fire():
	$ReloadTimer.start()
	do_fire_after_reload()
	
func do_stop_fire():
	$ReloadTimer.stop()


func _on_Sprite_animation_finished():
	if $Sprite.animation == "fire":
		$Sprite.play("idle") 

func _on_Sprite_frame_changed():
	if $Sprite.animation == "fire" and $Sprite.frame == 2:
		for i in range(3):
			var bullet = bullet_ctor.instance()
			var vec = Vector2(-1.5,-1).normalized()
			vec = vec.normalized() * SPEED * rand_range(0.9, 1.2)
			get_parent().add_child(bullet)
			bullet.set_animation("mortar_bullet")
			bullet.mass = 4
			bullet.use_trail(8)
			bullet.position = self.position + Vector2(-6, -8)
			#bullet.rotation = vec.angle()
			bullet.throw(vec, true)	
