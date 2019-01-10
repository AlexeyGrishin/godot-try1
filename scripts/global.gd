extends Node

const ASPECT = 0.1
const WINDOWS_COUNT = 16.0
#const HEIGHT = 72.0
#const INTER_FLOOR_HEIGHT = 8.0

const ATTACK_HALF_SIZE = 6.0

signal on_angle_change
signal on_boss_appear
signal on_boss_kill

var model

func _ready():
	model = BuildingModel.new(self)
	pass
	
func init():
	model = BuildingModel.new(self)
	

class WindowModel:
	var index
	var broken
	var coords_to_draw = []
	var is_back = false
	var is_left = false
	var is_right = false
	
	func _init(index):
		self.index = index
		self.broken = false
		
	func break_window():
		self.broken = true	
	
class FloorModel:
	var id
	var y
	var radius
	var clear = false
	var windows = []
	
	var top_radius
	
	var left_window_x = 0
	var right_window_x = 0
	var height
	
	var active_soldiers = 0
	
	func _init(id, y, radius, top_radius = radius, height = 40):
		self.id = id
		self.y = y
		self.radius = radius
		self.top_radius = top_radius
		self.height = height
		for i in range(WINDOWS_COUNT):
			windows.append(WindowModel.new(i))

		
	func on_clear():
		self.clear = true
		
	func update(angle):
		var leftmostx = 999
		var leftmostxi = -1
		var rightmostx = -999
		var rightmostxi = -1
		for i in range(WINDOWS_COUNT):
			var w = windows[i]
			w.coords_to_draw = global.get_window_coords_abs(i, angle, Vector2(0,0), radius, Vector2(0, -height), top_radius)
			var dy = (w.coords_to_draw[0].y + w.coords_to_draw[1].y)/2
			var dx = (w.coords_to_draw[0].x + w.coords_to_draw[1].x)/2
			w.is_back = dy < 0
			w.is_left = false
			w.is_right = false
			if dx < leftmostx:
				leftmostx = dx
				leftmostxi = i
			if dx > rightmostx:
				rightmostx = dx
				rightmostxi = i
		windows[leftmostxi].is_left = true
		left_window_x = leftmostx
		windows[rightmostxi].is_right = true
		right_window_x = rightmostx
		
	func break_left_window():
		for w in windows:
			if w.is_left:
				if w.broken:
					break
				w.break_window()
				return true
		return false

	func break_right_window():
		for w in windows:
			if w.is_right:
				if w.broken:
					break
				w.break_window()
				return true
		return false
		

class BuildingModel:
	
	var angle = 0.0
	var floors = []
	var prev_bottom_y = 0.0
	var bottom_y = 0.0
	var next_floor_after_top_clear_y = 0.0 #i hate myself
	var emitter
	var all_clear = false
	
	func _init(emitter):
		self.emitter = emitter
		
	func rotate(delta):
		angle += delta
		emitter.emit_signal("on_angle_change")
		recalculate_floors()
		
	func post_init():
		recalculate_floors()
		recalculate_bottom_y()
		emitter.emit_signal("on_angle_change")
		
	func recalculate_floors():
		for flr in floors:
			flr.update(angle)
			
	func break_left_window(floor_id):
		if get_floor(floor_id).break_left_window():
			emitter.emit_signal("on_angle_change")
			recalculate_floors()
			return true
		return false
		
	func break_right_window(floor_id):
		if get_floor(floor_id).break_right_window():
			emitter.emit_signal("on_angle_change")
			recalculate_floors()
			return true
		return false
		
	func add_floor(id, y, radius, top_radius, height):
		if get_floor(id) != null:
			print("ERROR: duplicate id %d", id)
		floors.append(FloorModel.new(id, y, radius, top_radius, height))
		
	func get_floor(id):
		for flr in floors:
			if flr.id == id:
				return flr
				
	func is_under_attack(floor_coord):
		return abs(floor_coord.y) < ATTACK_HALF_SIZE
		
	
	func recalculate_bottom_y():
		prev_bottom_y = bottom_y
		bottom_y = -9999
		next_floor_after_top_clear_y = 9999
		all_clear = true
		for flr in floors:
			if not flr.clear:
				bottom_y = max(bottom_y, flr.y)
				all_clear = false
				
		for flr in floors:
			if flr.clear and flr.y > bottom_y:
				next_floor_after_top_clear_y = min(next_floor_after_top_clear_y, flr.y)
		
		if next_floor_after_top_clear_y == 9999:
			next_floor_after_top_clear_y = bottom_y
		
		
	func on_floor_clear(id):
		for flr in floors:
			if flr.id == id:
				flr.on_clear()
		recalculate_bottom_y()
		emitter.emit_signal("on_angle_change")
				
	

		
# vector(x,y) -> relative to floor middle
func translate_xy(vector, angle):
	var out = vector.rotated(angle)
	out.y *= ASPECT
	return out
	
	
func translate_xy_abs(vector, angle, floorMiddleCoord):
	return translate_xy(vector - floorMiddleCoord, angle) + floorMiddleCoord

func get_corner_point(angle, radius):
	return Vector2(cos(angle)*radius, sin(angle)*radius)

func get_window_coords(wi, bottom_floor_r, top_floor_r):
	var window_angle = wi / WINDOWS_COUNT * 2 * PI
	var next_window_angle = (wi+1) / WINDOWS_COUNT * 2 * PI
	return [
		get_corner_point(window_angle, bottom_floor_r),
		get_corner_point(next_window_angle, bottom_floor_r),
		get_corner_point(next_window_angle, top_floor_r),
		get_corner_point(window_angle, top_floor_r)
	]
	
func get_window_coords_abs(wi, angle, bottom_floor_coord, bottom_floor_r, top_floor_coord, top_floor_r):
	var out = get_window_coords(wi, bottom_floor_r, top_floor_r)
	out[0] = translate_xy_abs(out[0], angle, bottom_floor_coord)
	out[1] = translate_xy_abs(out[1], angle, bottom_floor_coord)
	out[2] = translate_xy_abs(out[2], angle, bottom_floor_coord) + top_floor_coord
	out[3] = translate_xy_abs(out[3], angle, bottom_floor_coord) + top_floor_coord
	return out

func get_floor_coords_abs(angle, floor_coord, floor_r):
	var out = []
	for i in range(WINDOWS_COUNT):
		out.append(
		#todo: translate_xy_abs invalid!
			translate_xy_abs(
				get_corner_point(i/WINDOWS_COUNT * 2 * PI, floor_r),
				angle,
				floor_coord
			)
		)
	return out
	
func get_bottom_floor_coords_abs(angle, floor_coord, floor_r, floor_height = INTER_FLOOR_HEIGHT):
	var v2 = get_floor_coords_abs(angle, floor_coord, floor_r)
	v2.invert()
	var v1 = get_floor_coords_abs(angle, floor_coord, floor_r)
	var out = []
	for v in v1:
		if v.y > 0:
			out.append(v)
	for v in v2:
		if v.y > 0:
			v.y += floor_height
			out.append(v)
	return out
	