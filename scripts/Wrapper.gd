extends Node2D

export(Vector2) var coords = 0.0

var wrapped
signal on_destroy

func _ready():
	global.connect("on_angle_change", self, "_on_angle_change")
	redraw()
	
func resurrect(resurrect_scene):
	if wrapped == null and resurrect_scene != null:
		wrapped = resurrect_scene.instance()
		wrap(wrapped)
		wrapped.position = Vector2(0,0)
		wrapped.resurrect()

func _on_angle_change():
	redraw()
	
func wrap(sprite):
	self.add_child(sprite)
	wrapped = sprite
	wrapped.connect("on_destroy", self, "_on_wrapped_destroy")
	
func _on_destroy(old_wrapped):
	emit_signal("on_destroy")
	
func _on_wrapped_destroy(obj):
	self.wrapped = null
	call_deferred("_on_destroy", obj)
	
func redraw():
	self.position = global.translate_xy(coords, global.model.angle)
	if wrapped != null:
		var is_under_attack = global.model.is_under_attack(self.position)
		wrapped.set_under_attack(is_under_attack)
		if wrapped.shall_rotate():
			self.scale.x = -sign(self.position.y)
			if self.scale.x == 0:
				self.scale.x = 1
				
		
