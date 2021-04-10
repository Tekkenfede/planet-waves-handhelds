extends Area2D
const sfxLaser=preload("res://scenes/sfxLaser.tscn")
func _ready():pass
func _on_laserBeam_body_entered(body):
	if body.is_in_group('Enemy'):
		body.queue_free()
func checkHits():
	for b in self.get_overlapping_bodies():
		if b.is_in_group('Enemy'):
			b.die()
func addSfx():
	global.nDebug2droot.add_child(sfxLaser.instance())
