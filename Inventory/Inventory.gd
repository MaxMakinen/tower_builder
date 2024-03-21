extends Resource

class_name Inventory


@export var item_slots: Array[InventorySlot]
@export var inventory_size: int = 16

signal inventory_update(indices: Array[int])

var indices: Array[int]

func _ready():
	if item_slots.size() != inventory_size:
		item_slots.resize(inventory_size)
	_refresh()


func _refresh()-> void:
	for index in range(inventory_size):
		if item_slots[index] and item_slots[index].amount <= 0:
			remove_item(index)

# Return entire array of item_slots
func get_items() -> Array[InventorySlot]:
	return item_slots

# Return item at index from item_slots array
func get_item_at(index: int) -> InventorySlot:
	return item_slots[index]

# Set new inventory size and then resize inventory slot array
func set_inventory_size(new_size: int) -> void:
	inventory_size = new_size
	item_slots.resize(inventory_size)

# Insert item stack into array at index
func set_item(index: int, item: InventorySlot):
	var previous_item = item_slots[index]
	item_slots[index] = item
	_signal_change(index)
	return previous_item

# Remove item stack from array at index
func remove_item(index: int) -> InventorySlot:
	var previous_item = item_slots[index].duplicate()
	item_slots[index] = null
	_signal_change(index)
	return previous_item

# Change stack size of inventory slot and remove item if stack size falls below 1
func set_item_amount(index: int, amount: int) -> void:
	item_slots[index].amount += amount
	if item_slots[index].amount <= 0:
		remove_item(index)
	else:
		_signal_change(index)

# Get total amount of all stacks of same item
func get_total_amount(target: ItemResource) -> int:
	var total: int = 0
	for item in item_slots:
		if item.item == target:
			total += item.amount
	return total


func get_all_types() -> Array[ItemResource]:
	var types: Array[ItemResource]
	for item in item_slots:
		if item.item not in types:
			types.append(item)
	return types


func _signal_change(index: int) -> void:
	_refresh()
	indices.clear()
	indices.append(index)
	inventory_update.emit(indices)
	indices.clear()

# Old shit
# TODO : Return false if insert fails.
# TODO : Detect stack_size and attempt to insert new stack if stack full.
# Insert item into inventory array or increase item amount if already present
#func insert(item: ItemResource):
#	var slots = item_slots.filter(func(slot): return slot.item == item)
#	if !slots.is_empty():
#		slots[0].amount += 1
#	else:
#		var emptyslots = item_slots.filter(func(slot): return slot.item == null)
#		if !emptyslots.is_empty():
#			emptyslots[0].item = item
#			emptyslots[0].amount = 1
#	inventory_update.emit()
#
#
## Swap item_slots in inventory array based on their indices
#func swap_items(index1, index2) -> bool:
#	if index1 < 0 or index1 > inventory_size or index2 < 0 or index2 > inventory_size:
#		return false
#	var temp_slot = item_slots[index1]
#	item_slots[index1] = item_slots[index2]
#	item_slots[index2] = temp_slot
#	inventory_update.emit()
#	return true
