extends KinematicBody2D
var t=0
var vGravity=Vector2(0,1)
var vVelocity=Vector2()
var vVelocityLocal=Vector2()
var vDashDirection=Vector2()
var vDashVelocity=Vector2()
var fFuel=0
const fRefuelSpeed=155
const fBurnFuelSpeed=75
const fMaxFuel=100
const fSpeed=250
const fDashSpeed=260
const fJumpForce=200
const trailCircleFx=preload("res://scenes/trailCircleFx.tscn")

enum States {Normal, Jetpack}
var state=States.Normal
func _ready():
	global.player=self
	set_physics_process(true)
func _physics_process(delta):
	
	var fFowardAngle=vGravity.angle()-PI/2
	print_debug(rad2deg(fFowardAngle))
	self.rotation=wrapf(fFowardAngle,0,2*PI)#lerp(self.rotation,wrapf(fFowardAngle,0,2*PI),0.5)
	#self.rotation=lerp(self.rotation,wrapf(fFowardAngle,-PI,2*PI),0.5)
	t+=1
#	$canvasLayer/camera2D.rotation=lerp($canvasLayer/camera2D.rotation,self.rotation,0.2)
#	$canvasLayer/camera2D.global_position=self.global_position
	$rayCast2D.cast_to=vDashVelocity.rotated(-fFowardAngle)
	if state==States.Normal:
		if self.is_on_floor():
			self.fFuel=clamp(self.fFuel+delta*fRefuelSpeed,0,self.fMaxFuel)
		var vInputDirection=Vector2(
			1 if Input.is_action_pressed("ui_right") else -1 if Input.is_action_pressed("ui_left") else 0,
			1 if Input.is_action_pressed("ui_down") else -1 if Input.is_action_pressed("ui_up") else 0
		)
#		var fFowardAngle=vGravity.angle()-PI/2
	#	var vMotion=vInputDirection#.rotated(fFowardAngle)
		#$rayCast2D.cast_to=100*vInputDirection#.rotated(-fFowardAngle)
#		self.rotation=fFowardAngle
		if Input.is_action_just_pressed("ui_jetpack"):
			vVelocity=Vector2()
			self.state=States.Jetpack
			self.vDashDirection=vInputDirection.normalized()
			self.vDashVelocity=self.fDashSpeed*self.vDashDirection.rotated(fFowardAngle)
#			self.vDashVelocity.x=self.fDashSpeed*self.vDashDirection.x#.rotated(-fFowardAngle)#.rotated(fFowardAngle)
#			self.vDashVelocity.y=self.fDashSpeed*self.vDashDirection.y
#			print_debug(self.vDashVelocity)
			
		if vInputDirection.x!=0:
			var vTempVectorVelocity=vVelocity.rotated(-fFowardAngle)
			vTempVectorVelocity.x=lerp(vTempVectorVelocity.x,vInputDirection.x*fSpeed,0.2)
			if Input.is_action_just_pressed("ui_jump") and self.is_on_floor():
				vTempVectorVelocity.y=-fJumpForce
			vVelocity=vTempVectorVelocity.rotated(fFowardAngle)
			#vVelocity=(vVelocity.rotated(-fFowardAngle)+vInputDirection*fSpeed).rotated(fFowardAngle)
		else:
			var vTempVectorVelocity=vVelocity.rotated(-fFowardAngle)
			vTempVectorVelocity.x=lerp(vTempVectorVelocity.x,0,0.1)
			if Input.is_action_just_pressed("ui_jump") and self.is_on_floor():
				vTempVectorVelocity.y=-fJumpForce
			vVelocity=vTempVectorVelocity.rotated(fFowardAngle)
			#vVelocity=(Vector2(,vVelocity.rotated(-fFowardAngle).y)).rotated(fFowardAngle)
		#vVelocity+=vMotion*fSpeed
		vVelocity+=vGravity
		vVelocity=move_and_slide(vVelocity,-vGravity.normalized())
	elif self.state==States.Jetpack:
		self.fFuel=clamp(self.fFuel-self.fBurnFuelSpeed*delta,0,self.fMaxFuel)
		if Input.is_action_just_released("ui_jetpack") or is_equal_approx(self.fFuel,0):
			vVelocity=vDashVelocity
			self.state=States.Normal
		if t%5==0:createDots()
		#var vTempDashDirection=vDashDirection.rotated(-fFowardAngle)
		#vDashDirection+=vGravity
		#vDashVelocity+=vGravity
		print_debug(sign(vDashVelocity.x))
		#$rayCast2D.cast_to=vDashVelocity.rotated(-fFowardAngle)
		if vDashDirection.x>0:
			vDashVelocity=vDashVelocity.rotated(vDashVelocity.angle_to(vGravity)-PI/2)
		elif vDashDirection.x<0:
			vDashVelocity=vDashVelocity.rotated(vDashVelocity.angle_to(vGravity)+PI/2)
#		if vDashDirection.y>0:
#			vDashVelocity=vDashVelocity.rotated(vDashVelocity.angle_to(vGravity))
		vDashVelocity=move_and_slide(vDashVelocity,-vGravity.normalized())
func createDots():
	var fFowardAngle=self.vGravity.angle()-PI/2
	var i=trailCircleFx.instance()
	i.global_position=self.global_position+Vector2(0,rand_range(-4,4)).rotated(fFowardAngle)
	get_parent().add_child(i)
