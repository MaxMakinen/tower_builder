extends Resource

class_name Inventory

signal inventory_update

@export var item_slots: Array[InventorySlot]
@export var inventory_size: int = 8

func _ready():
	_resize_inventory()

func get_items() -> Array[InventorySlot]:
	return item_slots

func get_item_at(index: int) -> InventorySlot:
	return item_slots[index]

# Go through inventory and remove items with amount < 1
func _update():
	for item in item_slots:
		if item.amount < 1:
			print("erased ", item.item)
			_erase(item)

# Empty out inventory slot
func _erase(slot: InventorySlot):
	slot.item = null
	slot.amount = 0
	inventory_update.emit()

# TODO : Return false if insert fails.
# TODO : Detect stack_size and attempt to insert new stack if stack full.
# Insert item into inventory array or increase item amount if already present
func insert(item: ItemResource):
	var slots = item_slots.filter(func(slot): return slot.item == item)
	if !slots.is_empty():
		slots[0].amount += 1
	else:
		var emptyslots = item_slots.filter(func(slot): return slot.item == null)
		if !emptyslots.is_empty():
			emptyslots[0].item = item
			emptyslots[0].amount = 1
	inventory_update.emit()

# Set new inventory size and then resize inventory slot array
func set_inventory_size(new_size: int):
	inventory_size = new_size
	_resize_inventory()

# Resize inventory size and connect every slots slot_update signal to the _update function
func _resize_inventory():
	item_slots.resize(inventory_size)
	for i in range(inventory_size):
		item_slots[i].slot_update.connect(_update)
	_update()

# TODO : Split existing stack into new stack of size x and reduce amount of original stack. Retun new stack.
func split_stack_to_size(item: InventorySlot, size: int):
	pass

# TODO : Merge two stacks into one. If max_stack_size reached, leave remainder in start_slot. Otherwise delete start_slot
func merge_stacks(start_slot: InventorySlot, target_slot: InventorySlot):
	pass

# Get total amount of all stacks of same item
func get_total_amount(target: InventorySlot) -> int:
	var total: int = 0
	for item in item_slots:
		if target.item == item.item:
			total += item.amount
	return total

## TODO : Is this used at all?
#func decrease(item: InventorySlot):
#	item.decrease()
#	inventory_update.emit()
#
## TODO : Is this used at all?
#func increase(item: InventorySlot):
#	item.increase()
#	inventory_update.emit()

# Swap item_slots in inventory array based on their indices
func swap_items(index1, index2) -> bool:
	if index1 < 0 or index1 > inventory_size or index2 < 0 or index2 > inventory_size:
		return false
	var temp_slot = item_slots[index1]
	item_slots[index1] = item_slots[index2]
	item_slots[index2] = temp_slot
	inventory_update.emit()
	return true
