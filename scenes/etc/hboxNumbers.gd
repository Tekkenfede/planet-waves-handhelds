extends HBoxContainer

func _ready():
	global.connect("oneKill",self,'oneKill')
	global.connect("threeKills",self,'threeKills')
	global.connect("fiveKills",self,'fiveKills')
	if not global.bTutorialDone:
		$panelContainer3.visible=false
		$panelContainer4.visible=false
		$panelContainer5.visible=false
	set_process(true)
func _process(delta):pass
func oneKill():$panelContainer3.visible=true
func threeKills():$panelContainer4.visible=true
func fiveKills():$panelContainer5.visible=true
