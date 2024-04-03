extends CraftingNode

@onready var progress_bar: ProgressBar = $ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Called when player interacts with interaction area
func _on_interact():
	print("INTERACTION")
	print("Start Crafting")
	pass
