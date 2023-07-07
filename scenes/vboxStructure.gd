extends VBoxContainer
class_name VboxStructure

enum Types {Photo, Homing, Laser, Spread, Shield}
export(Types) var type = Types.Photo
const dictPrices := {
	Types.Photo: 20,
	Types.Homing: 200,
	Types.Laser: 75,
	Types.Spread: 50,
	Types.Shield: 50,
}

onready var nTexBtnStructure:ClassTextureButtonStructure = $texBtnStructure
onready var nLabel:Label = $label

func _ready() -> void:
	nTexBtnStructure.type = self.type
	nTexBtnStructure.refreshIcon()
	nLabel.text = str(dictPrices[self.type])
