extends Node

var crate_creator = preload("res://objects/Crate.tscn")

enum State {
	Cutscene,
	Rotating,
	Firing
}

const CAMERA_PAD = 100

var state = State.Rotating

var bg_width
var allow_fire = false
var allow_input = true

func _ready():
	bg_width = $Background/Sky.texture.get_width()
	global.model.post_init()
	global.connect("on_angle_change", self, "_on_angle_change")
	global.connect("on_boss_kill", self, "_on_boss_kill")
	global.connect("on_all_clear", self, "_on_all_clear")
	update_bg()
	$UILayer/UI.connect("on_panel_close", self, "_on_panel_close")
	$UILayer/UI.pause_and_show_panel($UILayer/UI.Panel.Ready)
	AudioServer.set_bus_mute(2, false)
	
func _on_all_clear():
	allow_input = false
	$CrateTimer.stop()
	$Helicopter.slowmotion = 0.0
	$Helicopter.no_slowmo = true
	
func _on_panel_close():
	if $Helicopter.health <= 0:
		global.init()
		get_tree().reload_current_scene()	
	else:
		$AllowFireTimer.start()
	
func _on_boss_kill(boss):
	$KillBoss.play()
	
func _on_angle_change():
	update_bg()
	
func update_camera():
	var speed = 2
	var bottom_y = global.model.bottom_y
	var desired_y = bottom_y - get_viewport_rect().size.y + CAMERA_PAD
	if bottom_y == -9999:
		desired_y = -1400
		speed = 1 
	if desired_y < $Camera.position.y:
		$Camera.position.y = max(desired_y, $Camera.position.y - speed )
	
func update_bg():
	var angle_part = fposmod(global.model.angle / 2 / PI, 1.0)	
	var dx = bg_width * angle_part
	$Background/Sky.position.x = -bg_width + dx
	if dx > bg_width / 2:
		dx -= bg_width
	$Background/Polars.position.x = dx
	

func _process(delta):
	if state == State.Rotating and allow_input:
		if Input.is_action_pressed("rotate_left"):
			global.model.rotate(0.02)
		if Input.is_action_pressed("rotate_right"):
			global.model.rotate(-0.02)
			
	$Helicopter.firing = allow_fire and allow_input and Input.is_action_pressed("fire")
	$UILayer/UI.update_helicopter_stats($Helicopter)
	update_camera()
	
	if $Camera.position.y <= -999 and not $EndGame.is_playing():
		$EndGame.play("end")

	if $Helicopter.health <= 0:
		AudioServer.set_bus_mute(2, true)
		$UILayer/UI.pause_and_show_panel($UILayer/UI.Panel.GameOver)
		
		


func _on_CrateTimer_timeout():
	var crate = crate_creator.instance()
		
	if $Helicopter.health < 40:
		crate.contents = crate.Contents.Health
		crate.amount = 80
	elif $Helicopter.bullets < 80:
		crate.contents = crate.Contents.Bullets
		crate.amount = 200
	elif randf() < 0.1:
		crate.contents = crate.Contents.Slowmotion
	elif randf() < 0.5:
		crate.contents = crate.Contents.Bullets
	else:
		crate.contents = crate.Contents.Health			
	
	$Crates.add_child(crate)
	
	crate.position.x = rand_range(100, 300) #hardcode is bad...
	crate.position.y = $Camera.position.y


func _on_AllowFireTimer_timeout():
	allow_fire = true

func fade_ui():
	$UILayer/UI.fade()

func _on_EndGame_animation_finished(anim_name):
	get_tree().change_scene("res://cutscenes/CutScene2.tscn")
