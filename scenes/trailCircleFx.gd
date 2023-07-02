extends Node2D
var t := 0
var radius := 4.0#8#2
var ringWidth := 6.0#1.5
var duration := 0.5

func _ready() -> void:
	var _v = $twn.connect("tween_all_completed",self,'queue_free')
	set_process(true)
	
func _process(_delta:float) -> void:
	t += 1
	if t == 4:
		var _v = $twn.interpolate_property(self,'radius',self.radius,0,duration,Tween.TRANS_QUINT,Tween.EASE_IN)
		_v = $twn.interpolate_property(self,'ringWidth',self.ringWidth,0,duration,Tween.TRANS_QUINT,Tween.EASE_IN)
		_v = $twn.start()
	update()

func _draw() -> void:
	if t < 4:
		draw_circle(Vector2(),radius,Color.white)
	else:
		draw_arc(Vector2(),radius,0,2*PI,360,Color.white,ringWidth,false)

func _delete(_a,_b) -> void:
	self.queue_free()
