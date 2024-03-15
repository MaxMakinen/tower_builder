extends Resource


class_name ItemResource

@export var name: String = "Default name"
@export_enum("Stone", "Wood", "Ore", "Metal", "Ingot", "fuel", "misc") var type: String = "Wood"
@export var texture: Texture2D
@export var spritesheet: bool = true
@export var frame: int = 0
@export var Hframes := 11
@export var Vframes := 11
@export var max_stack_size: int = 99
@export var description: String = "Default description"
@export var consumable: bool = false
