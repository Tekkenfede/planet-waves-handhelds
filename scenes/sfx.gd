extends AudioStreamPlayer
func _ready():
	randomize()
	self.pitch_scale=rand_range(0.8,1.2)
	self.connect("finished",self,'queue_free')
