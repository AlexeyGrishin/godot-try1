extends Node2D

export(PackedScene) var floor_scene_path = load("res://floors/Floor1.tscn")

var floor_scene
var wrapper_ctor = preload("res://Wrapper.tscn")
var wrapper_class = preload("res://scripts/Wrapper.gd")
var bullet_ctor = preload("res://objects/HeliBullet.tscn")
var radius = 200
var top_radius = 200
var height = 40
var floor_id = 1

var clean = false

var debug_scene = false

func _ready():
	floor_scene = floor_scene_path.instance()
	floor_id = floor_scene.get_node("Metadata").id
	radius = floor_scene.get_node("Metadata").size/2
	top_radius = floor_scene.get_node("Metadata").top_size/2
	height = floor_scene.get_node("Metadata").height

	$floor_circle.radius = radius
	$floor_circle.floor_id = floor_id
	$back_windows.floor_id = floor_id
	$front_windows.floor_id = floor_id
	
	$colliders/Floor2.position.y = global.ATTACK_HALF_SIZE
	$colliders/Floor2/CollisionShape2D.shape.extents.x = sqrt(radius*radius - global.ATTACK_HALF_SIZE*global.ATTACK_HALF_SIZE/global.ASPECT/global.ASPECT)
	
	global.model.add_floor(floor_id, position.y, radius, top_radius, height)
	
	$colliders/LeftWindow.position.y = -height/2
	$colliders/LeftWindow/CollisionShape2D.shape.extents.y = height/2
	$colliders/RightWindow.position.y = -height/2
	$colliders/RightWindow/CollisionShape2D.shape.extents.y = height/2
	
	global.connect("on_angle_change", self, "_on_angle_change")
	add_objects()
	call_deferred("_recalculate_enemies")

	if get_viewport() == get_parent():
		self.position.x += 400
		self.position.y += 400
		global.model.post_init()
		debug_scene = true
		
	
func add_objects():
	# ok, i don't know how to do that. have to add whole scene and process contents manually
	#var contents = floor_scene.get_node("Contents")
	#print(contents)
	#$items_container.add_child(contents)
	#$items_container.add_child(floor_scene)
	var source = floor_scene
	for child in source.get_children():
		if child.name == "Metadata":
			continue
		source.remove_child(child) # ok, need to remove child before adding it
		var wrapper = wrapper_ctor.instance()
		wrapper.coords = child.position
		child.position = Vector2(0,0)
		$items_container.add_child(wrapper)
		wrapper.wrap(child)
		wrapper.connect("on_destroy", self, "_on_item_destroy")
		
	#$items_container.remove_(source)
	
func _on_item_destroy():
	call_deferred("_recalculate_enemies")	
	
func _recalculate_enemies():
	for wrapper in $items_container.get_children():
		if not (wrapper is wrapper_class) or wrapper.wrapped == null:
			continue
		if wrapper.wrapped.is_in_group("enemy"):
			return
	global.model.on_floor_clear(floor_id)
	
func _on_angle_change():
	_redraw()
	
func _process(delta):
	if debug_scene:
		global.model.rotate(0.01)
		if Input.is_action_just_pressed("ui_select"):
			var bullet = bullet_ctor.instance()
			self.add_child(bullet)
			bullet.fly(
				get_viewport().get_mouse_position() - Vector2(400,400), 
				Vector2(0.8, 0.2)
			) 
			#global.model.break_left_window(floor_id)
			
	$colliders/LeftWindow.position.x = global.model.get_floor(floor_id).left_window_x
	$colliders/RightWindow.position.x = global.model.get_floor(floor_id).right_window_x
	
	
func _redraw():
	$floor_circle.update()
	$back_windows.update()
	$front_windows.update()
	$floor_height.update()
	
#todo: on_window_hit (break, animate)


func _on_LeftWindow_body_entered(body):
	if body.is_in_group("glass"):
		return
	if global.model.break_left_window(floor_id):
		var rect = Rect2(
			$colliders/LeftWindow.position.x - $colliders/LeftWindow/CollisionShape2D.shape.extents.x,
			$colliders/LeftWindow.position.y - $colliders/LeftWindow/CollisionShape2D.shape.extents.y,
			$colliders/LeftWindow/CollisionShape2D.shape.extents.x * 2,
			$colliders/LeftWindow/CollisionShape2D.shape.extents.y * 2
		)
		var sign_x = -1
		#todo: ugly, but i don't know how to correctly understand velocity and direction of bullets
		if body.is_in_group("heli_bullet"):
			sign_x = 1
		util.drop_sharps("glass", 12, rect, Vector2(sign_x*300, -10), $colliders)
		body.queue_free()


func _on_RightWindow_body_entered(body):
	if body.is_in_group("glass"):
		return
	if global.model.break_right_window(floor_id):
		var rect = Rect2(
			$colliders/RightWindow.position.x - $colliders/RightWindow/CollisionShape2D.shape.extents.x,
			$colliders/RightWindow.position.y - $colliders/RightWindow/CollisionShape2D.shape.extents.y,
			$colliders/RightWindow/CollisionShape2D.shape.extents.x * 2,
			$colliders/RightWindow/CollisionShape2D.shape.extents.y * 2
		)
		util.drop_sharps("glass", 12, rect, Vector2(300, -10), $colliders)
		body.queue_free()
