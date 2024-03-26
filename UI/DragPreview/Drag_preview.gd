extends Control

class_name DragPreview

@onready var item_icon: TextureRect = %ItemIcon
@onready var item_amount: Label = %ItemAmount

var _dragged_item: InventorySlot = null


# If we are dragging an item, _dragged_item is not null, make node follow mouse position
func _process(_delta: float) -> void:
	if _dragged_item != null:
		position = get_global_mouse_position()


func set_dragged_item(item: InventorySlot) -> void:
	_dragged_item = item
	if _dragged_item != null and _dragged_item.item != null:
		item_icon.texture = item.item.texture
		item_amount.text = str(item.get_amount()) if item.is_stackable() else ""
	else:
		item_icon.texture = null
		item_amount.text = ""

# TODO : Possible that this is never used
func change_amount(amount: int) -> void:
	_dragged_item.change_amount(amount, 0)
	item_amount.text = str(_dragged_item.get_amount())
	if _dragged_item.get_amount() < 1:
		set_dragged_item(null)

func get_amount() -> int:
	return _dragged_item.get_amount()

func get_dragged_item() -> InventorySlot:
	return _dragged_item

