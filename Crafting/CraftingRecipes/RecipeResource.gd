extends Resource


class_name RecipeResource


@export var output: ItemResource
@export var name: String = "Unnamed Object"
@export var description: String = "Make thing from stuff"

@export var required_flags: Dictionary = {
	"TYPE" : ["ORE"],
	"NATURE" : ["METAL"],
	"SOLIDITY" : ["SOLID"],
	"AMOUNT" : 3,
}
