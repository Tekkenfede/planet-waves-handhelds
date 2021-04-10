extends HBoxContainer

func _ready():
	global.connect("oneKill",self,'oneKill')
	global.connect("threeKills",self,'threeKills')
	global.connect("fiveKills",self,'fiveKills')
	if not global.bTutorialDone:
		$vBoxContainer5.visible=false
		$vBoxContainer3.visible=false
		$vBoxContainer4.visible=false
	set_process(true)
func _process(delta):pass
func oneKill():$vBoxContainer5.visible=true
func threeKills():$vBoxContainer3.visible=true
func fiveKills():$vBoxContainer4.visible=true
