class_name InventorySlot
extends Resource

# EXPORT VARIABLES
@export var item: ItemResource
@export var amount: int

# SIGNALS
signal slot_empty()
signal slot_changed()
# TODO : Slot_full might be useless signal. Maybe for UI to highlight maxed out stacks?
signal slot_full()

# Sets new item info
func _init(new_item: ItemResource = null, new_amount: int = 0) -> void:
	item = new_item
	amount = new_amount

# Sets new item info
#func new_item(new_item: ItemResource, new_amount: int) -> void:
#	item = new_item
#	amount = new_amount

# Change amout of current slot, emit signal with index of current placement in inventory array if amount reaches 0 or if max_stack_size reached
func change_amount(new_amount: int) -> int:
	amount += new_amount
	var difference = amount - item.max_stack_size
	if !item:
		return 0
	elif amount > item.max_stack_size:
		amount = item.max_stack_size
	slot_changed.emit()
	return difference

# Return amount of items in slot
func get_amount() -> int:
	return amount

# Set amount to specific number and return true. Ignore if invalid number and return false.
func set_amount(new_amount: int = amount) -> bool:
	if new_amount >= 0 and new_amount <= item.max_stack_size:
		amount = new_amount
		if amount == 0:
			slot_empty.emit()
		return true
	return false

# Return item texture. If no item present, return null
func get_texture() -> Texture2D:
	if item:
		return item.texture
	return null

# Returns Max_stack_size of item. If no item present, return 0
func get_max_stack_size() -> int:
	if item:
		return item.max_stack_size
	return 0

# Returns item
func get_item() -> ItemResource:
	return item

func get_item_name() -> String:
	if item:
		return item.name
	return ""

func get_item_description() -> String:
	if item:
		return item.description
	return ""

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

# Return true if amount is slot has no item or has invalid amount
func is_empty() -> bool:
	if item == null or amount <= 0:
		return true
	return false

# Return true if slot not empty and has enough amount to be split
func can_split() -> bool:
	if item and amount > 1:
		return true
	return false

func use_item() -> bool:
	if item and item.consumable == true:
		change_amount(-1)
		print("Item : ", item.name, " Consumed")
		return true
	return false

func empty() -> void:
	item = null
	amount = 0
#	slot_empty.emit()

func copy_slot(new_slot: InventorySlot) -> void:
	item = new_slot.get_item()
	amount = new_slot.get_amount()
	slot_changed.emit()

