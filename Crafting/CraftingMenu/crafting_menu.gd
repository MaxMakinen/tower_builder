extends Control


@onready var option_button: OptionButton = %OptionButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	option_button.add_item("Item1", 2)
	option_button.add_item("Item2", 3)
	option_button.add_item("Item3", 4)




func _on_option_button_item_selected(index: int) -> void:
	print("Int sent by signal : ", index)
	pass # Replace with function body.
