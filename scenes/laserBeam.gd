extends Area2D

const sfxLaser := preload("res://scenes/sfxLaser.tscn")

func _ready() -> void:
	set_process(true)

func _process(_delta: float) -> void:
	$sprite/sprite.position.y = rand_range(-1,1)

func _on_laserBeam_body_entered(body) -> void:
	if body.is_in_group('Enemy'):
		body.queue_free()

func checkHits() -> void:
	for b in self.get_overlapping_bodies():
		if b.is_in_group('Enemy'):
			b.die()

func addSfx() -> void:
	global.nDebug2droot.add_child(sfxLaser.instance())
