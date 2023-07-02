extends Node2D

func _ready() -> void:
	randomize()
	self.scale=Vector2(1,1)*rand_range(0.8,1.6)
	$explosion.rotation=rand_range(-PI,PI)
	$explosion2.rotation=rand_range(-PI,PI)
	if randf() < 0.5:
		$explosion.visible = false
	else:
		$explosion2.visible = false
		
func _on_animationPlayer_animation_finished(_anim_name) -> void:
	queue_free()
