extends Control

func _ready() -> void:
	var _v = global.connect("clearActors", self, 'makeInvisible')
	
func makeInvisible() -> void:
	self.visible = false
	self.queue_free()
