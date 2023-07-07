extends Area2D

enum Types {Photo, Homing, Laser, Spread, Shield}
export(Types) var type = Types.Photo

enum States {Creation, Docked, GoAway}
var state = States.Creation

const fEnergyGain := 4.0#2
var fShieldHealth := 100
var bMouseIn := false
var bDeletionQueued := false
const homingProjectile := preload("res://scenes/homingProjectile.tscn")
const laserBeam := preload("res://scenes/laserBeam.tscn")
const spreadBullet := preload("res://scenes/spreadBullet.tscn")
const sfxHoming := preload("res://scenes/sfxHoming.tscn")
const sfxLaser := preload("res://scenes/sfxLaser.tscn")
const sfxSpread := preload("res://scenes/sfxSpread.tscn")
const sfxTowerSet := preload("res://scenes/sfxTowerSet.tscn")
const sprMissingEnergy := preload("res://scenes/sprMissingEnergy.tscn")
var bCooldown := true
var dictEnergyCosts = {
	Types.Photo:0,
	Types.Homing:50,
	Types.Laser:5,
	Types.Spread:10,
	Types.Shield:0
}
var dictCollisionPolygons={
	Types.Photo:PoolVector2Array([Vector2()]),
	Types.Shield:PoolVector2Array([Vector2()]),
	Types.Homing:PoolVector2Array([
			Vector2(8,0),
			Vector2(200,-360),
			Vector2(-200,-360),
			Vector2(-8,0)
		]),
	Types.Laser:PoolVector2Array([
			Vector2(8,0),
			Vector2(100,-360),
			Vector2(-100,-360),
			Vector2(-8,0)
		]),
	Types.Spread:PoolVector2Array([
			Vector2(8,0),
			Vector2(220,-173.2),
			Vector2(-220,-173.2),
			Vector2(-8,0)
		]),
}
onready var nPanelGuide=$layerControl/panelGuide
onready var nPanelClickToDelete=$layerControl/panelClickToDelete
onready var nSprReference=$sprite/sprReference
func _ready():
	spawn()
	selectColor()
	setupLine2d()
	$progressBar.max_value = $timerCooldown.wait_time if self.type != Types.Shield else 100
	$sprite.visible = true
	$sprite/sprReference.visible = false
	$timerCooldown.start()
# warning-ignore:return_value_discarded
	self.connect("mouse_entered",self,'mouseEnter')
# warning-ignore:return_value_discarded
	self.connect("mouse_exited",self,'mouseExit')
#	nPanelClickToDelete.visible=false
# warning-ignore:return_value_discarded
	$enemyDetection.connect("body_entered",self,'bodyEnter')
	set_process(true)
func _process(delta):
	self.rotation=self.global_position.angle()+PI/2-global.nPlanetBase.rotation
#	nPanelClickToDelete.rect_rotation=-rad2deg(self.rotation+global.nPlanetBase.rotation)
	nPanelClickToDelete.rect_global_position=self.global_position+Vector2(36,-8)
#	$layerControl/panelClickToDeleteConfirmation.rect_rotation=-rad2deg(self.rotation+global.nPlanetBase.rotation)
	$layerControl/panelClickToDeleteConfirmation.rect_global_position=self.global_position+Vector2(36,-8)
	if state==States.Creation:
		stateRoutineCreation(delta)
	elif state==States.Docked:
		stateRoutineDocked(delta)
	elif state==States.GoAway:
		self.rotation+=delta*PI
# warning-ignore:unused_argument
func stateRoutineCreation(delta):
# warning-ignore:unused_variable
	var fR=self.get_global_mouse_position().length()
	var fA=self.get_global_mouse_position().angle();fA=deg2rad(int(rad2deg(fA))%180)
	self.global_position=(global.fPlanetRadius+nSprReference.texture.get_size().y*nSprReference.scale.y*0.5)*Vector2(cos(fA),sin(fA))
#	nPanelGuide.rect_rotation=-rad2deg(self.rotation+global.nPlanetBase.rotation)
	nPanelGuide.rect_global_position=self.global_position+Vector2(36,-64)
	if Input.is_action_just_pressed("ui_rmb"):
		if self.type==Types.Photo:global.fEnergy+=20
		elif self.type==Types.Shield:global.fEnergy+=50
		elif self.type==Types.Spread:global.fEnergy+=100
		elif self.type==Types.Homing:global.fEnergy+=50
		elif self.type==Types.Laser:global.fEnergy+=75
#		$shieldArea/collisionShape2D.disabled=true
		global.bTowerQueued=false
		self.set_process(false)
		self.goAway()
	if self.get_overlapping_areas().size()!=0:
		self.modulate=Color('#ff5555')
	else:
		self.modulate=Color('#ffffffaa')
		if Input.is_action_just_pressed('ui_lmb'):
			self.state=self.States.Docked
			$animationPlayer.play("dock")
			$sprite.modulate.a=1
#			self.state=self.States.Docked
			$layerControl/panelGuide.queue_free()
			global.bTowerQueued=false
			if self.type!=Types.Photo:$line2D.modulate.a=0
			if self.type==Types.Shield:$shieldArea/collisionShape2D.disabled=false
			if self.type==Types.Photo:global.emit_signal("photoPlaced")
#			$animationPlayer.play("dock")

func addSfxTowerSet():
	global.nDebug2droot.add_child(sfxTowerSet.instance())
	
func stateRoutineDocked(delta:float) -> void:
	match self.type:
		Types.Photo:
			stateRoutinePhoto(delta)
		Types.Homing:
			stateRoutineHoming(delta)
		Types.Laser:
			stateRoutineLaser(delta)
		Types.Spread:
			stateRoutineSpread(delta)
		Types.Shield:
			stateRoutineShield(delta)
	
#	if self.type==Types.Photo:stateRoutinePhoto(delta)
#	elif self.type==Types.Homing:stateRoutineHoming(delta)
#	elif self.type==Types.Laser:stateRoutineLaser(delta)
#	elif self.type==Types.Spread:stateRoutineSpread(delta)
#	elif self.type==Types.Shield:stateRoutineShield(delta)
#
	if Input.is_action_just_pressed('ui_rmb') and self.bDeletionQueued:
		self.bDeletionQueued=false
		$layerControl/panelClickToDeleteConfirmation.visible=false
	if bMouseIn and Input.is_action_just_pressed("ui_lmb"):
		if self.bDeletionQueued:
			self.set_process(false)
			addSfxTowerSet()
			self.goAway()
		else:
			self.bDeletionQueued=true
			$layerControl/panelClickToDelete.visible=false
			$layerControl/panelClickToDeleteConfirmation.visible=true


func findClosestEnemy():
	var closestEnemy=null
	for n in $reach.get_overlapping_bodies():
		if n.is_in_group('Enemy'):
			if closestEnemy==null:
				closestEnemy=n
			else:
				if (self.global_position-n.global_position).length() < (self.global_position-closestEnemy.global_position).length():
					closestEnemy=n
	return closestEnemy
func spawn():
	$sprite.modulate.a=0.66
	$tween.interpolate_property(self,'modulate:a',0,1,0.44,Tween.TRANS_QUINT,Tween.EASE_IN)
	$tween.interpolate_property($sprite,'position:y',128,0,0.44,Tween.TRANS_BACK,Tween.EASE_OUT)
	$tween.interpolate_property(self,'scale',Vector2(1,0),Vector2(1,1),0.44,Tween.TRANS_QUINT,Tween.EASE_OUT)
	$tween.start()
	self.global_position=(global.fPlanetRadius+$sprite.texture.get_size().y*$sprite.scale.y*0.5)*Vector2(cos(0),sin(0))
	if self.type==Types.Photo:
		$progressBar.queue_free()
#		$sprite/sprPhoto.queue_free()
		$sprite/sprLaser.queue_free()
		$sprite/sprHoming.queue_free()
		$sprite/sprSpread.queue_free()
		$sprite/sprShield.queue_free()
		$lightOccTower.queue_free()
		$lightOccShield.queue_free()
	elif self.type==Types.Laser:
		$timerCooldown.wait_time = 4.0
		$sprite/sprPhoto.queue_free()
#		$sprite/sprLaser.queue_free()
		$sprite/sprHoming.queue_free()
		$sprite/sprSpread.queue_free()
		$sprite/sprShield.queue_free()
		$lightOccPhoto.queue_free()
		$lightOccShield.queue_free()
	elif self.type==Types.Homing:
		$timerCooldown.wait_time = 4
		$sprite/sprPhoto.queue_free()
		$sprite/sprLaser.queue_free()
#		$sprite/sprHoming.queue_free()
		$sprite/sprSpread.queue_free()
		$sprite/sprShield.queue_free()
		$lightOccPhoto.queue_free()
		$lightOccShield.queue_free()
	elif self.type==Types.Spread:
		$timerCooldown.wait_time = 2
		$sprite/sprPhoto.queue_free()
		$sprite/sprLaser.queue_free()
		$sprite/sprHoming.queue_free()
#		$sprite/sprSpread.queue_free()
		$sprite/sprShield.queue_free()
		$lightOccPhoto.queue_free()
		$lightOccShield.queue_free()
	elif self.type==Types.Shield:
		$sprite/sprPhoto.queue_free()
		$sprite/sprLaser.queue_free()
		$sprite/sprHoming.queue_free()
		$sprite/sprSpread.queue_free()
		#$sprite/sprShield.queue_free()
		$lightOccPhoto.queue_free()
		$lightOccTower.queue_free()
		var _v = $shieldArea.connect("body_entered",self,'shieldTakeDamage')

func shieldTakeDamage(b):
	if b.is_in_group('Enemy'):
		if b.is_in_group('Meteor'):
			self.fShieldHealth-=100
		else:
			self.fShieldHealth-=25
		b.die()
		if fShieldHealth<=0:
			self.goAway()
		
func setupLine2d():
	if self.type==Types.Photo:$line2D.visible=false
	elif self.type==Types.Laser:$line2D.default_color=global.colors['white']
	elif self.type==Types.Homing:$line2D.default_color=global.colors['orange']
	elif self.type==Types.Spread:$line2D.default_color=global.colors['green']
	elif self.type==Types.Shield:$line2D.default_color=global.colors['pink']
	$line2D.points=self.dictCollisionPolygons[self.type]
	$reach/collisionPolygon2D.polygon=$line2D.points
	$line2D.default_color.a=0
	$tween.interpolate_property($line2D,'default_color:a',0,1,0.33,Tween.TRANS_QUINT,Tween.EASE_IN,0.05)
	$tween.start()
func selectColor():
	return
	#if self.type==Types.Photo:$sprite.modulate=global.colors['yellow']
	#elif self.type==Types.Laser:$sprite.modulate=global.colors['white']
	#elif self.type==Types.Homing:$sprite.modulate=global.colors['orange']
	#elif self.type==Types.Spread:$sprite.modulate=global.colors['green']
func goAway():
#	nPanelClickToDelete.visible=false
	var _v = $tween.interpolate_property(self,'scale',self.scale,Vector2(),0.44,Tween.TRANS_BACK,Tween.EASE_IN)
	_v = $tween.start()
	_v = $tween.connect("tween_all_completed",self,'queue_free')
func shakeScreen():
#	print_debug('ads')
	global.nCamera.medShake()
func mouseEnter():
	#print_debug('Tower: mouse entered')
	if self.state!=self.States.Creation:
		nPanelClickToDelete.visible=true
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	self.bMouseIn=true
	$line2D.modulate.a=0.33
func mouseExit():
	#print_debug('Tower: mouse exited')
	nPanelClickToDelete.visible=false
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	self.bMouseIn=false
	$line2D.modulate.a=0
	
func _on_timer_timeout():
	self.bCooldown = false

func bodyEnter(b):
	if self.state!=self.States.Creation:
		if b.is_in_group('Enemy'):
			if self.type!=self.Types.Shield:
				self.queue_free()
				b.die()
func showOptions():
	return
	#$controlOptions.show()

func stateRoutinePhoto(delta:float) -> void:
	if $photocell.get_overlapping_areas().size() > 0:
		global.fEnergy += self.fEnergyGain * delta
		#global.fEnergy = lerp(global.fEnergy, 1000.0, self.fEnergyGain * delta * delta)
		$sprite/sprPhoto/photoParticles.emitting = true
		#$sprite.modulate = Color('#ffffff')
		$sprite.modulate = lerp($sprite.modulate, Color('#ffffff'), 0.1)
	else:
		$sprite/sprPhoto/photoParticles.emitting = false
		#$sprite.modulate=Color('#555555')
		$sprite.modulate = lerp($sprite.modulate, Color('#555555'), 0.1)

func stateRoutineShield(_delta:float) -> void:
	$progressBar.value=lerp($progressBar.value,self.fShieldHealth,0.1)

func stateRoutineHoming(_delta:float) -> void:
	$progressBar.value=$timerCooldown.wait_time-$timerCooldown.time_left
	if not self.bCooldown:
		if global.fEnergy>=self.dictEnergyCosts[self.Types.Homing]:
			var closestEnemy=findClosestEnemy()
			if closestEnemy!=null:
				if not closestEnemy.is_in_group('Marked'):
					homingShoot(closestEnemy)
		else:
			self.bCooldown = true
			$timerCooldown.start()
			var i=sprMissingEnergy.instance()
			i.global_position=self.global_position
			global.nDebug2droot.add_child(i)

func stateRoutineLaser(_delta:float) -> void:
	$progressBar.value = $timerCooldown.wait_time - $timerCooldown.time_left
	if not self.bCooldown:
		if global.fEnergy >= self.dictEnergyCosts[self.Types.Laser]:
			laserShoot()
		else:
			self.bCooldown = true
			$timerCooldown.start()
			var i = sprMissingEnergy.instance()
			i.global_position=self.global_position
			global.nDebug2droot.add_child(i)

func stateRoutineSpread(_delta:float) -> void:
	$progressBar.value = $timerCooldown.wait_time - $timerCooldown.time_left
	if not self.bCooldown:
		if global.fEnergy >= self.dictEnergyCosts[self.Types.Spread]:
			spreadShoot()
		else:
			self.bCooldown = true
			$timerCooldown.start()
			var i = sprMissingEnergy.instance()
			i.global_position = self.global_position
			global.nDebug2droot.add_child(i)

func homingShoot(target):
	var closestEnemy=target
	target.add_to_group('Marked')
	global.fEnergy-=self.dictEnergyCosts[self.Types.Homing]
	self.bCooldown=true
	var aa=(-$cannon.global_position+closestEnemy.global_position).angle()
	$tween.interpolate_property($sprite/sprHoming/sprTower,
								'rotation',
								$sprite/sprHoming/sprTower.rotation,
								wrapf(aa-self.rotation-global.nPlanetBase.rotation+PI/2,-PI,PI),
								0.6,
								Tween.TRANS_BACK,
								Tween.EASE_OUT)
	$tween.start()
	yield($tween,"tween_all_completed")
	$timerCooldown.start()
	global.nDebug2droot.add_child(sfxHoming.instance())
	var i=homingProjectile.instance()
	i.global_position=$sprite/sprHoming/sprTower/cannonHoming.global_position
	i.nTarget=target
	global.nDebug2droot.add_child(i)
	$sprite/sprHoming/sprTower/cannonHoming/homingParticles.restart();$sprite/sprHoming/sprTower/cannonHoming/homingParticles.emitting=true
	global.nPlanetBase.global_position-=0.02*self.global_position
	global.nCamera.minorShake()
	$tween.interpolate_property($sprite/sprHoming/sprTower,'position:y',20,16,0.6,Tween.TRANS_QUINT,Tween.EASE_IN)
	$tween.start()
	
func laserShoot() -> void:
	global.fEnergy -= self.dictEnergyCosts[self.Types.Laser]
	self.bCooldown = true
	$timerCooldown.start()
	var i = laserBeam.instance()
	add_child(i)
	i.global_position = $sprite/sprLaser/sprTower/cannonLaser.global_position
	i.rotation = -PI/2
	$tween.interpolate_property($sprite/sprLaser/sprTower,'position:y',20,16,0.6,Tween.TRANS_QUINT,Tween.EASE_IN)
	$tween.start()
	
func spreadShoot():
	self.bCooldown = true
	global.fEnergy -= self.dictEnergyCosts[self.Types.Spread]
	$timerCooldown.start()
	global.nDebug2droot.add_child(sfxSpread.instance())
	for a in [-2*PI/6,-PI/6,0,PI/6,2*PI/6]:
		var i=spreadBullet.instance()
		var aa=a+(-self.global_position+$cannon.global_position).angle()
		i.global_position=$sprite/sprSpread/sprTower/cannonSpread.global_position
		i.vDirection=Vector2(1,0).rotated(aa)
		global.nDebug2droot.add_child(i)
	global.nPlanetBase.global_position-=0.04*self.global_position
	global.nCamera.minorShake()
	$sprite/sprSpread/sprTower/cannonSpread/spreadParticles.emitting = true
	$tween.interpolate_property($sprite/sprSpread/sprTower,'position:y',20,16,0.6,Tween.TRANS_QUINT,Tween.EASE_IN)
	$tween.start()
