tool
extends TileMap
export(bool) var bGenerate=false
var grid_size=Vector2()
var fRadius=0
var vMin=Vector2(1,1)*1000;var vMax=Vector2()
const North = 1; const West = 2; const East = 4; const South = 8
const tile=preload("res://scenes/tile.tscn")
func _ready():set_process(true)
func _process(delta):
	if bGenerate:
		bGenerate=false
		self.z_index=1
		var size=self.get_used_cells().size()
		getMinMaxVectors()
		var fPerimeter=(vMax.x-vMin.x)
		var aAngles=getTileAngles(fPerimeter)
		grid_size.x=int(vMax.x*1.2)+16
		grid_size.y=int(vMax.y*1.2)+16
		fRadius=self.cell_size.x*fPerimeter/(2*PI)
#		get_parent().get_parent().fRadius=self.fRadius
		for x in range(-1,grid_size.x):
			for y in range(-1,grid_size.y):
				if get_cell(x,y)!=INVALID_CELL:
					var north_tile = 1 if get_cell(x,y-1) != INVALID_CELL else 0
					var west_tile = 1 if get_cell(x-1,y) != INVALID_CELL else 0
					var east_tile = 1 if get_cell(x+1,y) != INVALID_CELL else 0
					var south_tile = 1 if get_cell(x,y+1) != INVALID_CELL else 0
					var tile_index = 0 + North * north_tile + West * west_tile + East * east_tile + South * south_tile
					var a=aAngles[int(x-1)]
					var i=tile.instance()
					var ss=y/vMax.y
					i.z_index=vMax.y-y
					i.scale=Vector2.ONE*(1.33 - 0.4*ss)
					i.global_position=(fRadius-9*i.scale.y*y+rand_range(-4,4)/(y+1))*Vector2(cos(a),sin(a))
					i.rotation=a-PI/2
					i.scale*=rand_range(0.9,1.1)
					i.rotation*=rand_range(0.98,1.02)
					i.texture=self.tile_set.tile_get_texture(self.get_cell(x,y))
					i.modulate=self.modulate
					i.vframes=3;i.hframes=20
					if tile_index==15:
						i.frame=0 if randf()<0.8 else 1+randi()%3
						i.flip_h=true if randf()<0.2 else false
						i.flip_v=true if randf()<0.2 else false
						i.get_node("staticBody2D").queue_free()
					else:
						i.frame=7+randi()%4
					#get_parent().call_deferred('add_child',i)
					get_parent().add_child(i)
					i.set_owner(get_tree().get_edited_scene_root())
		global.fPlanetRadius=self.fRadius
	#self.queue_free()
func getMinMaxVectors():
	for v in self.get_used_cells():
		vMin.x=min(vMin.x,v.x)
		vMax.x=max(vMax.x,v.x)
		vMin.y=min(abs(vMin.y),abs(v.y))
		vMax.y=max(abs(vMax.y),abs(v.y))
func getTileAngles(fPerimeter):
	var aAngles=[]
	for i in range(fPerimeter):
		aAngles.append(i*2*PI/fPerimeter)
	return aAngles
func updateTileset():self.tile_set=get_parent().get_parent().tileset
