extends Sprite

var vDirection := Vector2(1,0)
var fSpeed := 0
var fRotationSpeed := 0

func _ready() -> void:
	$lightOccluder2D.modulate.a=0
	self.scale=Vector2(1,1)*rand_range(0.4,2.2)
	self.vDirection=self.vDirection.rotated(rand_range(-PI,PI))
# warning-ignore:narrowing_conversion
	self.fSpeed=rand_range(40,60)
# warning-ignore:narrowing_conversion
	self.fRotationSpeed=rand_range(-1,1)*PI/6
	set_process(true)
	
func _physics_process(delta:float) -> void:
	self.rotation+=self.fRotationSpeed*delta
	self.global_position+=self.vDirection*self.fSpeed*delta
	
func _on_visibilityNotifier2D_screen_entered() -> void:
	var _v = $tween.interpolate_property($lightOccluder2D,'modulate:a',0,1,0.3,Tween.TRANS_QUINT,Tween.EASE_IN)
	_v = $tween.start()
	
func _on_visibilityNotifier2D_screen_exited() -> void:
	var _v = $tween.interpolate_property($lightOccluder2D,'modulate:a',1,0,0.5,Tween.TRANS_QUINT,Tween.EASE_IN)
	_v = $tween.start()
	_v = $tween.connect("tween_all_completed",self,'queue_free')
