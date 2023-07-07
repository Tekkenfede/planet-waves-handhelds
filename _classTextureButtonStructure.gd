extends TextureButton
class_name ClassTextureButtonStructure

enum Types {Photo, Homing, Laser, Spread, Shield}
export(Types) var type = Types.Photo
const dictPrices := {
	Types.Photo: 20,
	Types.Homing: 200,
	Types.Laser: 75,
	Types.Spread: 50,
	Types.Shield: 50,
}

var t := 0
var twn := Tween.new()
var bPhotoBlink := true

const tower := preload("res://scenes/tower.tscn")
const sfxNewStructure := preload("res://scenes/sfxNewStructure.tscn")

onready var nTexBg:Control = $texBg
onready var nTexIcon:Control = $texIcon

func _ready() -> void:
	add_child(twn)
	
	refreshIcon()
	
	var _v = self.connect("pressed", self, 'onPressed')
	_v = self.connect("mouse_entered", self, 'onMouseEnter')
	_v = self.connect("mouse_exited", self, 'onMouseExit')
	_v = global.connect("photoPlaced", self, 'disableBlink')
	set_process(true)

func refreshIcon() -> void:
	match self.type:
		Types.Photo:
			nTexIcon.texture = load("res://resources/textures/sprites/iconPhoto.png")
			nTexIcon.modulate = Color('#FCBF49')
		Types.Homing:
			nTexIcon.texture = load("res://resources/textures/sprites/iconHoming.png")
			nTexIcon.modulate = Color('#F77F00')
		Types.Shield:
			nTexIcon.texture = load("res://resources/textures/sprites/iconShield.png")
			nTexIcon.modulate = Color('#E8AEB7')
		Types.Laser:
			nTexIcon.texture = load("res://resources/textures/sprites/iconLaser.png")
			nTexIcon.modulate = Color('#EAE2B7')
		Types.Spread:
			nTexIcon.texture = load("res://resources/textures/sprites/iconSpread.png")
			nTexIcon.modulate = Color('#84B082')

func disableBlink() -> void:
	#self.set_process(false)
	self.bPhotoBlink = false
	self.rect_scale = Vector2(1,1)

func _process(_delta:float) -> void:
	self.modulate = lerp(self.modulate, Color('#555555') if global.fEnergy < self.dictPrices[self.type] else Color('#ffffff'), 0.1)
	
	if self.type == self.Types.Photo and self.bPhotoBlink:
		t += 1
		$texBg.rect_scale = Vector2(1,1) + Vector2.ONE*0.05 * sin(t*PI / 128.0)
		$texIcon.rect_scale = Vector2(1,1) + Vector2.ONE*0.05 * sin(t*PI / 128.0)

func onMouseEnter() -> void:
	if self.bPhotoBlink:
		return
	var _v = twn.interpolate_property(self,'rect_scale',self.rect_scale,Vector2(1.2,1.2),0.3,Tween.TRANS_CUBIC,Tween.EASE_OUT)
	_v = twn.start()
	
func onMouseExit() -> void:
	if self.bPhotoBlink:
		return
	var _v = twn.interpolate_property(self,'rect_scale',self.rect_scale,Vector2(1,1),0.4,Tween.TRANS_CUBIC,Tween.EASE_IN_OUT)
	_v = twn.start()

func onPressed() -> void:
	if (not global.bTowerQueued) and (global.fEnergy >= self.dictPrices[self.type]):
		global.fEnergy -= self.dictPrices[self.type]
		
		var i := tower.instance()
		i.type = self.type
		global.nStructures.add_child(i)
		global.nDebug2droot.add_child(sfxNewStructure.instance())
