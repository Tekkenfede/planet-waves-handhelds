extends PanelContainer
func _ready():
	if global.bTutorialDone:self.queue_free()
	var _v = global.connect("oneKill",self,'oneKill')
	_v = global.connect("threeKills",self,'threeKills')
	_v = global.connect("fiveKills",self,'fiveKills')
	global.nUnlockPanel=self
func showMessage(message):
	var targetY=240 if global.nCtnStructures.bHidden else 210
	$label.text=message
	$tween.interpolate_property(self,'rect_global_position:y',self.rect_global_position.y,targetY,0.3,Tween.TRANS_QUINT,Tween.EASE_OUT)
	$tween.start()
	yield(get_tree().create_timer(3.0),"timeout")
	$tween.interpolate_property(self,'rect_global_position:y',self.rect_global_position.y,360,0.3,Tween.TRANS_QUINT,Tween.EASE_IN)
	$tween.start()
func oneKill():showMessage('Unlocked SHIELD')
func threeKills():showMessage('Unlocked LASER')
func fiveKills():showMessage('Unlocked SPREAD')
