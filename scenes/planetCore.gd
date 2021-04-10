extends Area2D
const sfxDamage=preload("res://scenes/sfxEnemyDeath.tscn")
func _ready():self.connect("body_entered",self,'bodyEnter')
func bodyEnter(b):
	if b.is_in_group('Enemy'):
		global.iPlanetLife-=1
		b.queue_free()
		get_parent().createExplosion()
