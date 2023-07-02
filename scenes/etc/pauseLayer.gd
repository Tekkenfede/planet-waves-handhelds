extends CanvasLayer

func _ready() -> void:
	$control.visible = false
	set_process(true)

func _process(_delta:float) -> void:
	if Input.is_action_just_pressed('ui_pause'):
		get_tree().paused = !get_tree().paused
		$control.visible = get_tree().paused
