tool
extends Area2D

export(Texture) var texture = preload("res://sprites/environment.sprites/environment18.tres")
export var debugScene = false
export var highlighted = false setget set_under_attack
export var has_glass = false

signal on_destroy

func _ready():
	$Sprite.texture = texture
	var debugRender = get_parent() == get_viewport()
	debugScene = debugScene or debugRender
	if debugRender:
		position.x = 200
		position.y = 200
		#$Sprite.scale *= 4
	self.set_under_attack(highlighted)
	
func shall_rotate():
	return true
	
func is_soldier():
	return false
		
func set_under_attack(val):
	highlighted = val
	if has_node("Sprite"):
		$Sprite/Highlighter.visible = val
	self.set_collision_layer_bit(2, val)

#func _process(delta):
#	if debugScene:
#		if Input.is_action_just_pressed("debug_1"):
#			do_destroy(Vector2(100, -50))

func do_destroy(velocity):
	var util = get_node("/root/util")
	util.drop_sharps("wood", 4, Rect2(self.position + $Sprite.offset, $Sprite.texture.get_size()), velocity, self.get_parent())
	if has_glass:
		util.drop_sharps("glass", 2, Rect2(self.position + $Sprite.offset, $Sprite.texture.get_size()), velocity, self.get_parent())
	self.emit_signal("on_destroy", self)
	self.queue_free()


func _on_Furniture_body_entered(body):
	if body.is_in_group("bullet"):
		do_destroy(Vector2(100, -50))
