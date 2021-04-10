extends ColorRect
func _ready():
	global.nWhiteRect=self
	global.connect("gameOver",self,'gameOver')
	self.modulate.a=0
func gameOver():
	$tween.interpolate_property(self,'modulate:a',self.modulate.a,1,2.0,Tween.TRANS_QUINT,Tween.EASE_IN,1.0)
	$tween.start()
	yield($tween,"tween_all_completed")
	yield(get_tree().create_timer(1.0),"timeout")
	global.nDebug2droot.queue_free()
	global.emit_signal("clearActors")
	$tween.interpolate_property(self,'modulate:a',self.modulate.a,0,1.0,Tween.TRANS_QUINT,Tween.EASE_IN,0.5)
	$tween.start()
