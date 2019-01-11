extends Area2D

var highlighted = false
signal on_destroy

#todo: hardcode is bad, but getting textures is hard
const ENEMY_W = 16
const ENEMY_H = 16

var target = null
var last_target = null

var hp = 1

class PseudoNode:
	var position
	
	func _init(pos):
		position = pos
		
	func to_global(vec):
		return position

func _ready():
	post_init()
	
func post_init():
	pass

func post_process(delta):
	pass
	
func resurrect():
	$Sprite/ResurrectBox.visible = true
	$Sprite/ResurrectBox.play("default")

	
func _process(delta):
	post_process(delta)
	

		
func set_under_attack(val):
	highlighted = val
	if $Sprite != null:
		$Sprite/Highlighter.visible = val
	self.set_collision_layer_bit(2, val)

		
func shall_rotate():
	return false
	
func is_soldier():
	return true


func do_destroy(velocity):
	var util = get_node("/root/util")
	util.drop_sharps("flesh", 5, Rect2(self.position + $Sprite.offset, Vector2(ENEMY_W, ENEMY_H)), velocity, self.get_parent())
	self.emit_signal("on_destroy", self)
	self.queue_free()

func decrease_hp(by):
	var attack = 1
	if by.has_method("get_damage"):
		attack = by.get_damage()
	hp -= attack
	if hp > 0:
		$AnimationPlayer.play("hit")
	
func on_hit(by):
	decrease_hp(by)
	if hp <= 0:
		do_destroy(Vector2(100, -50))
	

func _on_BaseEnemy_body_entered(body):
	if body.is_in_group("kill_people"):
		on_hit(body)


func do_fire_after_reload():
	pass
	
func do_start_fire():
	pass
	
func do_stop_fire():
	pass
	
func _on_ReloadTimer_timeout():
	$ReloadTimer.start()
	do_fire_after_reload()


func _on_Vision_body_entered(body):
	target = body
	last_target = body
	do_start_fire()

func _on_Vision_body_exited(body):
	target = null
	last_target = PseudoNode.new(body.to_global(Vector2(0,0)))
	do_stop_fire()
	



func _on_ResurrectBox_animation_finished():
	$Sprite/ResurrectBox.visible = false
