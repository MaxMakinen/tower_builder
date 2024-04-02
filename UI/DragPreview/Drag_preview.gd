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
	if item:
		_dragged_item = item.duplicate()
	else:
		_dragged_item = item
	display_dragged_item()

func display_dragged_item() -> void:
	if _dragged_item != null and _dragged_item.get_item() != null:
		item_icon.texture = _dragged_item.get_texture()
		item_amount.text = str(_dragged_item.get_amount()) if _dragged_item.is_stackable() else ""
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
	if target.get_type() == SlotManager.SlotType.INVENTORY:
		target.copy_slot(_dragged_item)
		if _previous_slot:
			print("inv slot drop")
			_previous_slot.slot_moved()
	elif target.get_type() == SlotManager.SlotType.HOTBAR:
		target.set_hotbar_slot(_dragged_item)
		print("hotbar slot drag")
		if _previous_slot.get_type() == SlotManager.SlotType.INVENTORY:
			#_previous_slot.copy_slot(_dragged_item)
			print("inv slot unghost")
			_previous_slot.unghost()
		else:
			print("hotbar slot drop")
			_previous_slot.slot_moved()
	set_dragged_item(null)

# Swap slot conents with target and _dragged item
func swap_slot(target: UIItemSlot) -> void:
	var temp = _dragged_item
	set_dragged_item(target.pickup_slot())
	target.unghost()
	if target.get_type() == SlotManager.SlotType.HOTBAR:
		target.set_hotbar_slot(temp)
	else:
		target.copy_slot(temp)
	_previous_slot.slot_moved()


# Stack stackable items and empty _draggable if all items fit in one stack
func stack_slot(target: InventorySlot) -> void:
	var difference = target.change_amount(_dragged_item.get_amount())
	if difference > 0:
		_dragged_item.set_amount(difference)
		display_dragged_item()
	else:
		_previous_slot.slot_moved()
		set_dragged_item(null)

# TODO : Might need some visual queues. Add in Tweens, red for failed interactions like stacking unstackables
func attempt_interaction(target_slot: UIItemSlot) -> void:
	if target_slot and !target_slot.is_ghost():# and target_slot.get_type() == SlotManager.SlotType.INVENTORY:
		# Attempt to pick up item
		if !target_slot.is_empty() and is_empty():
			#pickup_slot(target_slot)
			_previous_slot = target_slot
			set_dragged_item(target_slot.grab_item())
		# Attempt to drop item
#		elif target_slot.is_empty() and !is_empty():
			#drop_slot(target_slot)
		else:
			set_dragged_item(target_slot.put_item(_dragged_item))
			if target_slot.get_type() == SlotManager.SlotType.INVENTORY:
				_previous_slot.slot_moved()
			else:
				undo_drag()
	#	# Attempt to swap item
	#	elif !target_slot.is_empty() and !is_empty() and target_slot.get_type() == SlotManager.SlotType.HOTBAR:
	#		swap_slot(target_slot)
	#	elif !target_slot.is_empty() and !is_empty() and target_slot.get_type():
	#		if compare_slots(target_slot.get_contents()) and target_slot.get_contents().is_stackable() and !target_slot.get_contents().is_full():
	#			stack_slot(target_slot.get_contents())
	#		else:
	#			swap_slot(target_slot)
	elif target_slot:
		undo_drag()
	#if target_slot and target_slot.get_type() == SlotManager.SlotType.HOTBAR:
		# Attempt hotbar interaction
	#	pass


func compare_slots(slot: InventorySlot) -> bool:
	if slot.get_item() == _dragged_item.get_item():
		return true
	return false


func undo_drag() -> void:
	_previous_slot.unghost()
	set_dragged_item(null)
	#drop_slot(_previous_slot)


func is_empty() -> bool:
	if _dragged_item == null:
		return true
	return false

