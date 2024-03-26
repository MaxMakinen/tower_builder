extends SlotContainer

#TODO : for highlighting
var selected_item: int


func _ready() -> void:
	columns = 4
	_set_selected(-1)
	display_items()

