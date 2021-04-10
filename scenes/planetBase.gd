extends Node2D
var t:=0
export(float)var fRadius:=190.986
var fRotationSpeed:=0.0
const fMaxRotationSpeed:=PI/3
const fxExplosions:=preload("res://scenes/fxExplosions.tscn")
const sfxDamage:=preload("res://scenes/sfxEnemyDeath.tscn")
func _ready():
	global.nPlanetBase=self
	global.fPlanetRadius=self.fRadius
	set_process(true)
func _process(delta):
	# Handle input and rotation
	if Input.is_action_pressed("ui_right"):self.fRotationSpeed=lerp(self.fRotationSpeed,self.fMaxRotationSpeed,0.1)
	elif Input.is_action_pressed("ui_left"):self.fRotationSpeed=lerp(self.fRotationSpeed,-self.fMaxRotationSpeed,0.1)
	else:self.fRotationSpeed=lerp(self.fRotationSpeed,0,0.1)
	self.rotation+=self.fRotationSpeed*delta
	# Return to origin always (useful for when the planet shakes)
	self.global_position=self.global_position.linear_interpolate(Vector2(),0.1)
	# Explosions and stuff
	if global.iPlanetLife<=0:
		t+=1
		if t%10==0:createExplosion()
func createExplosion():
	global.nCamera.minorShake()
	var i=fxExplosions.instance()
	var aa=rand_range(-PI,PI)
	i.global_position=rand_range(16,256)*Vector2(cos(aa),sin(aa))
	add_child(i)
	global.add_child(sfxDamage.instance())
