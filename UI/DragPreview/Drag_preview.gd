extends Control

class_name DragPreview

@onready var item_icon: TextureRect = %ItemIcon
@onready var item_amount: Label = %ItemAmount

var _dragged_item: InventorySlot = null
enum drag_ID {
	EMPTY,
	INV_ITEM,
	HOTBAR_ITEM
	}
var _dragged_ID: drag_ID

var previous_inventory: Inventory = null
var previous_index: int = 0


# If we are dragging an item, _dragged_item is not null, make node follow mouse position
func _process(_delta: float) -> void:
	if _dragged_item != null:
		position = get_global_mouse_position()


func set_dragged_item(item: InventorySlot, id: drag_ID) -> void:
	_dragged_item = item
	_dragged_ID = id
	if _dragged_item != null and _dragged_item.item != null:
		item_icon.texture = item.item.texture
		item_amount.text = str(item.get_amount()) if item.is_stackable() else ""
	else:
		item_icon.texture = null
		item_amount.text = ""
		previous_inventory = null
		previous_index = 0

func set_backup(inventory: Inventory, index: int) -> void:
	previous_inventory = inventory
	previous_index = index

func get_drag_id() -> int:
	return _dragged_ID

func change_amount(amount: int) -> void:
	_dragged_item.change_amount(amount)
	item_amount.text = str(_dragged_item.get_amount())
	if _dragged_item.get_amount() < 1:
		set_dragged_item(null, 0)

func get_amount() -> int:
	return _dragged_item.get_amount()

func get_dragged_item() -> InventorySlot:
	return _dragged_item

