extends Node2D
var fRadius := 0
var fLerp := 0.1
var t := 1
var idxColor := 0
var aColors = [
	global.colors['white'],
	global.colors['blue'],
	global.colors['orange'],
	global.colors['orange'],
	global.colors['yellow'],
	global.colors['yellow']
]
var fDelay := 0.0

func _ready() -> void:
	#yield(get_tree().create_timer(fDelay),'timeout')
	randomize()
# warning-ignore:narrowing_conversion
	fRadius = rand_range(64.0,128.0)
	fLerp = rand_range(0.2,0.3)
	set_process(true)

func _process(_delta:float) -> void:
	t += 1
	if t % 4 == 0:
		idxColor += 1 if idxColor < 4 else 0
	fRadius = lerp(fRadius, 0, fLerp)
	update()
	
	if t > 30:
		self.queue_free()
	
func _draw() -> void:
	draw_circle(Vector2(),fRadius,aColors[idxColor])
