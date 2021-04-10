extends KinematicBody2D
var fRadius
var fAngle
var fTargetRadius
var vVelocity=Vector2()
enum States {Orbit,Attack}
var state=States.Orbit
const fSpeed=10
const fAngularSpeed=PI/18
const fxAttack=preload("res://scenes/fxAttack.tscn")
const fxExplosions=preload("res://scenes/fxExplosions.tscn")
const sfxEnemyDeath=preload("res://scenes/sfxEnemyDeath.tscn")
func _ready():
	global.connect('clearActors',self,'queue_free')
	var tt=rand_range(5.0,7.0)
	$timerAttack.wait_time=tt
	$timerAttack.start()
	self.fRadius=self.global_position.length()
	self.fAngle=self.global_position.angle()
	$area2D/lightOccluder2D.occluder.polygon=$area2D/collisionPolygon2D.polygon
	self.fTargetRadius=rand_range(380,400)
	set_physics_process(true)
func _physics_process(delta):
	if state==States.Orbit:
		self.fRadius=lerp(self.fRadius,self.fTargetRadius,0.01)
		self.fAngle+=self.fAngularSpeed*delta
		self.global_position=self.fRadius*Vector2(cos(self.fAngle),sin(self.fAngle))
		$sprite.rotation=self.fAngle+PI/2
	elif state==States.Attack:
		$tween.interpolate_property(self,'fRadius',self.fRadius,0,2,Tween.TRANS_BACK,Tween.EASE_IN,0.2)
		$tween.interpolate_property(self,'global_position',self.global_position,Vector2(),2,Tween.TRANS_BACK,Tween.EASE_IN,0.2)
		$tween.start()
		var i=fxAttack.instance()
		i.position=Vector2()
		#i.global_position=self.global_position
		add_child(i)
		set_physics_process(false)
		
func die():
	global.iScore+=20
	global.iNumberOfKills+=1
	$particles2D.emitting=true
	$collisionShape2D.disabled=true
	$area2D/collisionPolygon2D.disabled=true
	var i=fxExplosions.instance()
	i.global_position=self.fRadius*Vector2(cos(self.fAngle),sin(self.fAngle))#Vector2()#self.global_position
	global.nDebug2droot.add_child(i)
	global.nDebug2droot.add_child(sfxEnemyDeath.instance())
	self.queue_free()


func _on_timerAttack_timeout():
	state=States.Attack
	pass # Replace with function body.
