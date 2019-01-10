extends "BaseEnemy.gd"

var bullet_ctor = preload("res://objects/EnemyBullet.tscn")
	
const SPEED = 500
	
func post_init():
	$ReloadTimer.wait_time = 2
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
	$Fire.play()
	
	
func do_start_fire():
	$ReloadTimer.start()
	do_fire_after_reload()
	
func do_stop_fire():
	$ReloadTimer.stop()


func _on_Sprite_animation_finished():
	if $Sprite.animation == "fire":
		var bullet = bullet_ctor.instance()
		var vec = last_target.to_global(Vector2(0, 0)) - self.to_global(Vector2(0, 0))
		vec = vec.normalized() * SPEED
		get_parent().add_child(bullet)
		bullet.set_animation("bullet1")
		bullet.position = self.position + Vector2(-6, -8)
		bullet.rotation = vec.angle()
		bullet.throw(vec, false)		
		$Sprite.play("idle") 
