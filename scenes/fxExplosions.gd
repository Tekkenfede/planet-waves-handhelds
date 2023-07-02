extends Node2D

export(int) var iNumberOfExplosions := 5
const fxExplosion := preload("res://scenes/fxExplosion.tscn")
const fxExplosionSprite := preload("res://scenes/fxExplosionSprites.tscn")

func _ready() -> void:
	randomize()
	for _idx in range(iNumberOfExplosions):
		var i = fxExplosion.instance()
		i.global_position = self.global_position+Vector2(rand_range(-8,8),rand_range(-8,8))
		i.fDelay = rand_range(0,0.2)
		global.nDebug2droot.add_child(i)
		
	var j = fxExplosionSprite.instance()
	j.global_position = self.global_position
	global.nDebug2droot.add_child(j)
	self.queue_free()
