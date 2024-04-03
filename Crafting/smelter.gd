extends CraftingNode

@onready var progress_bar: ProgressBar = $ProgressBar

const COPPER = preload("res://Item/Items/Copper.tres")
const COPPER_INGOT = preload("res://Item/Items/Copper_ingot.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Called when player interacts with interaction area
func _on_interact():
	var ore = Global.player_inventory.in_inventory(COPPER)
	if ore:
		print("Can Smelt")
	else:
		print("Can't do Shit")

