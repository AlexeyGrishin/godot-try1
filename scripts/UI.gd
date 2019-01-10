extends MarginContainer

signal on_panel_close

func _ready():
	global.connect("on_boss_appear", self, "_on_boss_appear")
	global.connect("on_boss_kill", self, "_on_boss_kill")
	$VBoxContainer/BossProgress.visible = false

var boss_ref = null

var allow_unpause = false

enum Panel {
	GameOver,
	Ready
}

func pause_and_show_panel(type):
	$Panel.visible = true
	$Panel/ReadyText.visible = type == Panel.Ready
	$Panel/GameOverText.visible = type == Panel.GameOver
	get_tree().paused = true
	allow_unpause = false
	$AllowKey.start()

func _on_boss_appear(boss):
	boss_ref = weakref(boss)
	$VBoxContainer/BossProgress.visible = true
	
func _on_boss_kill(boss):
	boss_ref = null
	$VBoxContainer/BossProgress.visible = false
		
func _unpause():
	get_tree().paused = false
	$Panel.visible = false
	emit_signal("on_panel_close")
	

func _process(delta):
	if get_tree().paused and allow_unpause and Input.is_action_just_pressed("ui_select"):
		call_deferred("_unpause")
	$VBoxContainer/Label.text = "FPS: %d" % Engine.get_frames_per_second()
	$VBoxContainer/Objects.text = "Objects: %d" % Performance.get_monitor(Performance.PHYSICS_2D_ACTIVE_OBJECTS)
	if boss_ref != null:
		if boss_ref.get_ref():
			$VBoxContainer/BossProgress/ProgressBar.value = boss_ref.get_ref().hp


func update_helicopter_stats(helicopter):
	$VBoxContainer/HBoxContainer/ProgressBar.value = helicopter.health
	$VBoxContainer/HBoxContainer2/ProgressBar.value = helicopter.bullets

func _on_AllowKey_timeout():
	allow_unpause = true
