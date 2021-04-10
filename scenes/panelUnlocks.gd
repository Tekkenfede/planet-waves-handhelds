extends PanelContainer
func _ready():
	if global.bTutorialDone:self.queue_free()
	global.connect("oneKill",self,'oneKill')
	global.connect("threeKills",self,'threeKills')
	global.connect("fiveKills",self,'fiveKills')
	global.nUnlockPanel=self
func showMessage(message):
	$label.text=message
	$tween.interpolate_property(self,'rect_global_position:y',self.rect_global_position.y,210,0.3,Tween.TRANS_QUINT,Tween.EASE_OUT)
	$tween.start()
	yield(get_tree().create_timer(3.0),"timeout")
	$tween.interpolate_property(self,'rect_global_position:y',self.rect_global_position.y,360,0.3,Tween.TRANS_QUINT,Tween.EASE_IN)
	$tween.start()
func oneKill():showMessage('Unlocked SHIELD')
func threeKills():showMessage('Unlocked LASER')
func fiveKills():showMessage('Unlocked SPREAD')
