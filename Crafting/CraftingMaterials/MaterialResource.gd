extends Resource


class_name MaterialResource

@export var name: String = "Default name"
@export_enum("Stone", "Wood", "Ore", "Metal", "Ingot", "fuel", "misc") var type: String = "Wood"
@export var texture: Texture2D
@export var max_stack_size: int = 99
@export var description: String = "Default description"

var groups: Dictionary
var flags: Dictionary
