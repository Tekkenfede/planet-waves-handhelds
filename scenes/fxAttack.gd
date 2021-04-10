extends Node2D
var fRadius=0
func _ready():
	$tween.interpolate_property(self,'fRadius',0,64,0.66,Tween.TRANS_BACK,Tween.EASE_OUT)
	$tween.start()
#	$tween.connect("tween_all_completed",self,'goAway')
	set_process(true)
func _process(delta):update()
func _draw():draw_arc(Vector2(),self.fRadius,0,2*PI,360,global.colors['red'],8)
func goAway():
	$tween.interpolate_property(self,'modulate:a',self.modulate.a,0,0.4,Tween.TRANS_QUINT,Tween.EASE_IN)
	$tween.start()
	yield($tween,"tween_all_completed")
	self.queue_free()
