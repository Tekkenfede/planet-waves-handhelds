extends Sprite
func _ready():
	$tween.interpolate_property(self,'global_position:y',self.global_position.y,self.global_position.y-64,0.5,Tween.TRANS_BACK,Tween.EASE_OUT)
	$tween.start()
	yield($tween,"tween_all_completed")
	yield(get_tree().create_timer(1.0),"timeout")
	$tween.interpolate_property(self,'modulate:a',1,0,0.4,Tween.TRANS_QUINT,Tween.EASE_IN)
	$tween.start()
	yield($tween,"tween_all_completed")
	self.queue_free()
