extends Area2D

enum Contents {
	Health, Bullets, Slowmotion
}

export(Contents) var contents = Contents.Health setget set_contents
export var amount  = -1

var SPEED = 60
var wind_x

func set_contents(val):
	contents = val
	if has_node("Contents"):
		$Contents/Health.visible = contents == Contents.Health
		$Contents/Bullets.visible = contents == Contents.Bullets
		$Contents/Clock.visible = contents == Contents.Slowmotion

func _ready():
	if amount == -1:
		amount = rand_range(40, 100)
	wind_x = rand_range(-10, 10)
	set_contents(contents)
	
func _physics_process(delta):
	self.position.y += SPEED*delta
	self.position.x += wind_x*delta


func _on_Area2D_body_entered(body):
	if body.is_in_group("bullet") or body.is_in_group("sharp"):
		queue_free()
		return
	if $AnimationPlayer.is_playing():
		return
	match contents:
		Contents.Health:
			body.inc_health(amount)
		Contents.Bullets:
			body.inc_bullets(amount)
		Contents.Slowmotion:
			body.inc_slomo(amount)
	$AnimationPlayer.play("got")


func _on_VisibilityNotifier2D_screen_exited():
	self.queue_free()


func _on_AnimationPlayer_animation_finished(anim_name):
	self.queue_free()
