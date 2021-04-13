extends CanvasLayer
func _ready():
	$control.visible=false
	set_process(true)
func _process(delta):
	if Input.is_action_just_pressed('ui_pause'):
		get_tree().paused=!get_tree().paused
		$control.visible=get_tree().paused
