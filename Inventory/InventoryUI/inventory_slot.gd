class_name InventorySlot
extends Resource

# EXPORT VARIABLES
@export var item: ItemResource
@export var amount: int

# SIGNALS
signal slot_empty(index)
# TODO : Slot_full might be useless signal. Maybe for UI to highlight maxed out stacks?
signal slot_full(index)

# Sets new item info
func _init(new_item: ItemResource = null, new_amount: int = 0) -> void:
	item = new_item
	amount = new_amount

## Sets new item info
#func new_item(new_item: ItemResource, new_amount: int) -> void:
#	item = new_item
#	amount = new_amount

# Change amout of current slot, emit signal with index of current placement in inventory array if amount reaches 0 or if max_stack_size reached
func change_amount(new_amount: int, index: int) -> int:
	amount += new_amount
	if !item:
		return 0
	var difference : int = amount - item.max_stack_size
	if amount <= 0:
		slot_empty.emit(index)
	elif amount == item.max_stack_size:
		slot_full.emit(index)
	elif amount > item.max_stack_size:
		amount = item.max_stack_size
	return difference

# Return item texture. If no item present, return null
func get_texture() -> Texture2D:
	if item:
		return item.texture
	return null

# Return amount of items in slot
func get_amount() -> int:
	return amount

# Returns Max_stack_size of item. If no item present, return 0
func get_max_stack_size() -> int:
	if item:
		return item.max_stack_size
	return 0

# Returns item
func get_item() -> ItemResource:
	return item

# Return true if amount has reached max_stack_size
func is_full() -> bool:
	if item and amount >= item.max_stack_size:
		return true
	return false

# Return true if max_stack_size is large enough to allow stacking
func is_stackable() -> bool:
	if item and item.max_stack_size > 1:
		return true
	return false
