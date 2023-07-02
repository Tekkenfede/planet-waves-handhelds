extends AudioStreamPlayer

func _ready() -> void:
	randomize()
	self.pitch_scale=rand_range(0.8,1.2)
	var _v = self.connect("finished",self,'queue_free')
