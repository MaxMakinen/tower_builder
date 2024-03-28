extends Control

class_name DragPreview

@onready var item_icon: TextureRect = %ItemIcon
@onready var item_amount: Label = %ItemAmount

var _previous_slot: UIItemSlot = null
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


func change_amount(amount: int) -> void:
	_dragged_item.change_amount(amount)
	item_amount.text = str(_dragged_item.get_amount())
	if _dragged_item.get_amount() < 1:
		set_dragged_item(null)


func get_amount() -> int:
	return _dragged_item.get_amount()


func get_dragged_item() -> InventorySlot:
	return _dragged_item

# Duplicate slot information from target and then empties target. logs previous slot reference.
func pickup_slot(slot: UIItemSlot) -> void:
	set_dragged_item(slot.pickup_slot())
	_previous_slot = slot

# Copy dragged item information to target
func drop_slot(target: UIItemSlot) -> void:
	target.copy_slot(_dragged_item)
	set_dragged_item(null)

# Swap slot conents with target and _dragged item
func swap_slot(target: UIItemSlot) -> void:
	var temp = _dragged_item.duplicate()
	set_dragged_item(target.pickup_slot())
	target.copy_slot(temp)

# Stack stackable items and empty _draggable if all items fit in one stack
func stack_slot(target: InventorySlot) -> void:
	var difference = target.change_amount(_dragged_item.get_amount())
	print("Difference : ", difference)
	if difference > 0:
		_dragged_item.set_amount(difference)
	else:
		set_dragged_item(null)

# TODO : Might need some visual queues. Add in Tweens, red for failed interactions like stacking unstackables
func attempt_interaction(target_slot: UIItemSlot) -> void:
	if target_slot:
		# Attempt to pick up item
		if !target_slot.is_empty() and is_empty():
			pickup_slot(target_slot)
		# Attempt to drop item
		elif target_slot.is_empty() and !is_empty():
			drop_slot(target_slot)
		# Attempt to swap item
		elif !target_slot.is_empty() and !is_empty():
			if compare_slots(target_slot.get_contents()) and target_slot.get_contents().is_stackable():
				stack_slot(target_slot.get_contents())
			else:
				swap_slot(target_slot)


func compare_slots(slot: InventorySlot) -> bool:
	if slot.get_item() == _dragged_item.get_item():
		return true
	return false


func undo_drag() -> void:
	drop_slot(_previous_slot)


func is_empty() -> bool:
	if _dragged_item == null:
		return true
	return false

