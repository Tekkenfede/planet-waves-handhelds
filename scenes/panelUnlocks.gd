extends PanelContainer

func _ready() -> void:
	if global.bTutorialDone:self.queue_free()
	var _v = global.connect("oneKill",self,'oneKill')
	_v = global.connect("threeKills",self,'threeKills')
	_v = global.connect("fiveKills",self,'fiveKills')
	global.nUnlockPanel=self

func showMessage(message) -> void:
	var targetY = 228#240 if global.nCtnStructures.bHidden else 210
	$label.text = message
	var _v = $tween.interpolate_property(self, 'rect_global_position:y', self.rect_global_position.y, targetY, 0.3, Tween.TRANS_QUINT, Tween.EASE_OUT)
	_v = $tween.start()
	
	yield(get_tree().create_timer(3.0), "timeout")
	_v = $tween.interpolate_property(self, 'rect_global_position:y', self.rect_global_position.y, 360, 0.3, Tween.TRANS_QUINT, Tween.EASE_IN)
	_v = $tween.start()

func oneKill() -> void:
	showMessage('Unlocked SHIELD')

func threeKills() -> void:
	showMessage('Unlocked LASER')

func fiveKills() -> void:
	showMessage('Unlocked HOMING')
