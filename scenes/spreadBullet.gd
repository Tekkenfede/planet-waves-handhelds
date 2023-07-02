extends KinematicBody2D

var t := 0
var vDirection := Vector2(1,0)
const fSpeed = 66.0

func _ready():
	var _v = $area2D.connect("body_entered",self,'bodyEnter')
	self.rotation = vDirection.angle() - PI/2
	set_physics_process(true)

func _physics_process(_delta:float) -> void:
	t+=1
	if t % 240 == 0:
		checkIfOOB()
	
	var _v = move_and_slide(vDirection*fSpeed,Vector2())

func checkIfOOB() -> void:
	if self.global_position.x<-64 or\
		self.global_position.x>global.RESOLUTION.y+64 or\
		self.global_position.y-64 or\
		self.global_position.y>global.RESOLUTION.y+64:
			var _v = $tween.interpolate_property(self,'modulate:a',1,0,0.66,Tween.TRANS_QUINT,Tween.EASE_IN)
			_v = $tween.start()
			_v = $tween.connect("tween_all_completed",self,'queue_free')
func bodyEnter(b):
	if b.is_in_group('Enemy'):
		b.die()
		self.queue_free()
