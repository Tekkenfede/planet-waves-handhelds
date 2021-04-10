extends Control
func _ready():global.connect("clearActors",self,'makeInvisible')
func makeInvisible():
	self.visible=false
	self.queue_free()
