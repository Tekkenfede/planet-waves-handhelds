extends StaticBody2D
var iNumberOfRings=3
var aRadius=[]
const fRadiusSpeed=5
export(float) var fPlanetMass=10
func _ready():
	for r in range(iNumberOfRings):
		aRadius.append((1.0*r/iNumberOfRings)*($areaGravity/collisionShape2D.shape.radius-$collisionShape2D.shape.radius))
		pass
	set_physics_process(true)
func _physics_process(delta):
	for r in range(iNumberOfRings):
		aRadius[r]=wrapf(aRadius[r]-fPlanetMass*fRadiusSpeed*delta,$collisionShape2D.shape.radius,$areaGravity/collisionShape2D.shape.radius)
	update()
	for body in $areaGravity.get_overlapping_bodies():
		if body.is_in_group('Player'):
			body.vGravity=self.fPlanetMass*(self.global_position-body.global_position).normalized()
func _draw():
	for n in self.iNumberOfRings:
		draw_arc(Vector2(),aRadius[n],0,2*PI,360,Color.white,1.0,true)
	
