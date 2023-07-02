extends HBoxContainer

func _ready() -> void:
	var _v = global.connect("oneKill",self,'oneKill')
	_v = global.connect("threeKills",self,'threeKills')
	_v = global.connect("fiveKills",self,'fiveKills')
	if not global.bTutorialDone:
		$panelContainer3.visible=false
		$panelContainer4.visible=false
		$panelContainer5.visible=false
	set_process(true)

func _process(_delta:float) -> void:
	pass

func oneKill() -> void:
	$panelContainer3.visible = true

func threeKills() -> void:
	$panelContainer4.visible = true

func fiveKills() -> void:
	$panelContainer5.visible = true
