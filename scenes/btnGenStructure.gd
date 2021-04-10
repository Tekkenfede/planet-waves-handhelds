extends TextureButton
enum Types {Photo,Homing,Laser,Spread,Shield}
export(Types) var type=Types.Photo
var dPrices={
	Types.Photo:20,
	Types.Homing:50,
	Types.Laser:75,
	Types.Spread:100,
	Types.Shield:50,
}
var tower=preload("res://scenes/tower.tscn")
var twn=Tween.new()
var bPhotoBlink=true
var t=0
const sfxNewStructure=preload("res://scenes/sfxNewStructure.tscn")
func _ready():
	add_child(twn)
	self.rect_pivot_offset=self.rect_size/2
	self.connect("pressed",self,'btnPressed')
	self.connect("mouse_entered",self,'mouseEnter')
	self.connect("mouse_exited",self,'mouseExit')
	global.connect("photoPlaced",self,'disableBlink')
	set_process(true)
func disableBlink():
	self.bPhotoBlink=false
	self.rect_scale=Vector2(1,1)
func _process(delta):
	if self.type==self.Types.Photo:
		if self.bPhotoBlink:
			t+=1
			self.rect_scale=Vector2(1,1)+Vector2(0.1,0.1)*pow(sin(t*PI/128),2)
			
	if global.fEnergy<self.dPrices[self.type]:
		self.self_modulate=Color('#555555')
	else:
		self.self_modulate=Color('#ffffff')
func mouseEnter():
	twn.interpolate_property(self,'rect_scale',self.rect_scale,Vector2(1.2,1.2),0.5,Tween.TRANS_CUBIC,Tween.EASE_OUT)
	twn.start()
func mouseExit():
	twn.interpolate_property(self,'rect_scale',self.rect_scale,Vector2(1,1),1.0,Tween.TRANS_CUBIC,Tween.EASE_IN)
	twn.start()
func btnPressed():
	if (not global.bTowerQueued) and (global.fEnergy>=self.dPrices[self.type]):
		global.fEnergy-=self.dPrices[self.type]
		var i=tower.instance()
		i.type=self.type
		global.nStructures.add_child(i)
		global.nDebug2droot.add_child(sfxNewStructure.instance())
