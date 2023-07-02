extends Polygon2D

func _ready() -> void:
	set_process(true)

func _process(_delta:float) -> void:
	self.rotation = get_parent().global_position.angle()
	self.global_position = 64*get_parent().global_position.normalized()
