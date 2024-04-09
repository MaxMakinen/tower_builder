extends Resource


class_name MaterialResource

@export var name: String = "Default name"
@export var color : Color = Color.HOT_PINK
@export var description: String = "Default description"

@export_enum("METAL", "MINERAL", "ORGANIC", "MISC") var nature: String = "ORGANIC"
@export_enum("SOLID", "LIQUID", "GAS") var solidity: String = "SOLID"

@export var hardness: int = 3
@export var magic_conduction: int = 1
@export var magic_resistance: int = 1

var groups: Dictionary
var flags: Dictionary
