extends Control

@onready var item_icon: TextureRect = %ItemIcon
@onready var item_amount: Label = %ItemAmount

var dragged_item: InventorySlot = null


# If we are dragging an item, dragged_item is not null, make node follow mouse position
func _process(delta: float) -> void:
	if dragged_item != null:
		position = get_global_mouse_position()


func set_dragged_item(item: InventorySlot) -> void:
	dragged_item = item
	if dragged_item != null:
		item_icon.texture = item.item.texture
		item_amount.text = str(item.amount) if item.is_stackable() else ""
	else:
		item_icon.texture = null
		item_amount.text = ""
