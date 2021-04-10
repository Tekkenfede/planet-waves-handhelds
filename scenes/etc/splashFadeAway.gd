extends CanvasLayer
func _ready():
	$sprite.visible=true
	$tween.interpolate_property($sprite,'modulate:a',1,0,0.66,Tween.TRANS_QUINT,Tween.EASE_IN)
	$tween.start()
	yield($tween,"tween_all_completed")
	self.queue_free()
