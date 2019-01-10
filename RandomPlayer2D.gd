extends AudioStreamPlayer2D

export(Resource) var sound1 = null
export(Resource) var sound2 = null
export(Resource) var sound3 = null
export(Resource) var sound4 = null
export(Resource) var sound5 = null

var resources = []

func _ready():
	for sound in [sound1, sound2, sound3, sound4, sound5]:
		if sound != null:
			resources.append(sound)
			
			
func play_random():
	self.stream = resources[randi()%resources.size()]
	self.play()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
