extends Node

var crate_creator = preload("res://objects/Crate.tscn")

enum State {
	Cutscene,
	Rotating,
	Firing
}

const CAMERA_PAD = 60

var state = State.Rotating

var bg_width

func _ready():
	bg_width = $Background/Sky.texture.get_width()
	global.model.post_init()
	global.connect("on_angle_change", self, "_on_angle_change")
	update_bg()
	
func _on_angle_change():
	update_bg()
	update_camera()
	
func update_camera():
	var bottom_y = global.model.bottom_y
	if bottom_y != -9999:
		$Camera.position.y = bottom_y - get_viewport_rect().size.y + CAMERA_PAD
	
func update_bg():
	var angle_part = fposmod(global.model.angle / 2 / PI, 1.0)	
	var dx = bg_width * angle_part
	$Background/Sky.position.x = -bg_width + dx
	if dx > bg_width / 2:
		dx -= bg_width
	$Background/Polars.position.x = dx
	

func _process(delta):
	if state == State.Rotating:
		if Input.is_action_pressed("rotate_left"):
			global.model.rotate(0.02)
		if Input.is_action_pressed("rotate_right"):
			global.model.rotate(-0.02)
			
	$Helicopter.firing = Input.is_action_pressed("ui_select")
	$UI.update_helicopter_stats($Helicopter)


func _on_CrateTimer_timeout():
	var crate = crate_creator.instance()
		
	if $Helicopter.health < 40:
		crate.contents = crate.Contents.Health
		crate.amount = 80
	elif $Helicopter.bullets < 40:
		crate.contents = crate.Contents.Bullets
	elif randf() < 0.5:
		crate.contents = crate.Contents.Bullets
	else:
		crate.contents = crate.Contents.Health
			
			
	
	$Crates.add_child(crate)
	
	crate.position.x = rand_range(100, 300) #hardcode is bad...
	crate.position.y = $Camera.position.y
