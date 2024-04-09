extends Resource


class_name ItemResource

@export var name: String = "Default name"
#@export_enum("Stone", "Wood", "Ore", "Metal", "Ingot", "fuel", "misc") var type: String = "Wood"
@export_enum("LOG", "ORE", "INGOT", "CHUNK", "WEAPON", "TOOL", "MISC") var type: String = "Log"
@export var material: MaterialResource
@export var texture: Texture2D
@export var max_stack_size: int = 99
@export var description: String = "Default description"
@export var consumable: bool = false
