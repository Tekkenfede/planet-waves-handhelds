extends Area2D

const sfxDamage := preload("res://scenes/sfxEnemyDeath.tscn")

func _ready() -> void:
	var _v = self.connect("body_entered",self,'bodyEnter')

func bodyEnter(b:PhysicsBody2D) -> void:
	if b.is_in_group('Enemy'):
		global.iPlanetLife -= 1
		b.queue_free()
		get_parent().createExplosion()
