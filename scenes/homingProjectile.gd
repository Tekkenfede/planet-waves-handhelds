extends KinematicBody2D
var vVelocity=Vector2(1,0)
var nTarget=null
var t=0
const fSpeed=220
const trailFx=preload("res://scenes/trailCircleFx.tscn")
func _ready():
	$damageArea.connect("body_entered",self,'damage')
	if nTarget!=null:
		vVelocity=-fSpeed*(self.global_position-nTarget.global_position).normalized()
	self.rotation=wrapf(vVelocity.angle(),-PI,PI)
	set_physics_process(true)
func _physics_process(_delta):
	checkIfOOB()
	t+=1
	if t%3==0:
		var i=trailFx.instance()
		i.global_position=self.global_position+Vector2(rand_range(-4,4),rand_range(-4,4))
		get_parent().add_child(i)
	if vVelocity==Vector2():
		detectTarget()
		if nTarget!=null:
			vVelocity=-fSpeed*(self.global_position-nTarget.global_position).normalized()
	else:
		if nTarget!=null:
			vVelocity=-fSpeed*(self.global_position-nTarget.global_position).normalized()
		else:
			self.queue_free()
		self.rotation=lerp(self.rotation,wrapf(vVelocity.angle(),-PI,PI),0.1)
		move_and_slide(vVelocity,Vector2())

		
func detectTarget():
	for n in $area2D.get_overlapping_bodies():
		if n.is_in_group('Enemy'):
			if nTarget==null:
				nTarget=n
			elif (self.global_position-n.global_position).length() < (self.global_position-nTarget.global_position).length():
				nTarget=n
func damage(b):
	if b.is_in_group('Enemy'):
		b.die()
		self.queue_free()

func checkIfOOB():
	if self.global_position.x<-64-3*global.RESOLUTION.x or\
		self.global_position.x>3*global.RESOLUTION.x+64 or\
		self.global_position.y<-64-3*global.RESOLUTION.y or\
		self.global_position.y>3*global.RESOLUTION.y+64:
			$tween.interpolate_property(self,'modulate:a',1,0,0.66,Tween.TRANS_QUINT,Tween.EASE_IN)
			$tween.start()
			$tween.connect("tween_all_completed",self,'queue_free')
			set_physics_process(false)
