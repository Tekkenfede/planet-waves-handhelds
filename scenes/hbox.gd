extends HBoxContainer

func _ready() -> void:
	var _v = global.connect("oneKill",self,'oneKill')
	_v = global.connect("threeKills",self,'threeKills')
	_v = global.connect("fiveKills",self,'fiveKills')
	
	if not global.bTutorialDone:
		pass
#		$vboxShield.visible = false
#		$vboxLaser.visible = false
#		$vboxHoming.visible = false
	
	set_process(true)
	
func _process(_delta:float) -> void:
	pass

func oneKill() -> void:
	$vboxShield.visible = true

func threeKills() -> void:
	$vboxLaser.visible = true

func fiveKills() -> void:
	$vboxHoming.visible = true
