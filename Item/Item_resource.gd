extends Resource


class_name ItemResource

@export var name: String = ""
@export_enum("Stone", "Wood", "Ore", "Metal", "Ingot", "fuel", "misc") var type: String = "Wood"
@export var texture: Texture2D
@export var frame: int = 0
@export var stackable: bool = true
