extends AudioStreamPlayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	global.connect('photoPlaced',self,'start')
#	set_process(true)
#func _process(delta):
#	if Input.is_action_just_pressed('ui_mute'):
#		self.playing=!self.playing
func start():
	$tween.interpolate_property(self,'volume_db',-80,0,5,Tween.TRANS_QUAD,Tween.EASE_OUT)
	$tween.start()
	self.play()
	global.disconnect('photoPlaced',self,'start')
