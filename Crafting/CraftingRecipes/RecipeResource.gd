extends Resource


class_name RecipeResource

@export var name: String
@export var output: ItemResource


var required_flags: Dictionary = {
	"TYPE" : ["ORE"],
	"NATURE" : ["METAL"],
	"SOLIDITY" : ["SOLID"],
	"AMOUNT" : 3,
}
