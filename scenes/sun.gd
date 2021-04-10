extends Light2D
var fAngle=PI/4
const fAngularSpeed=PI/24
func _ready():set_process(true)
func _process(delta):
	fAngle-=fAngularSpeed*delta
	self.global_position=2795*Vector2(cos(fAngle),sin(fAngle))
	$sprite.global_position=350*Vector2(cos(fAngle),sin(fAngle))
	$sprite.rotation=$sprite.global_position.angle()#+PI/2
	$sprite/sprite.rotation=-$sprite.rotation
