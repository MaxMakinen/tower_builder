extends Resource

class_name Inventory

signal inventory_update

@export var item_slots: Array[InventorySlot]
@export var inventory_size: int = 8

func _ready():
	item_slots.resize(inventory_size)

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

func decrease(item: InventorySlot):
	var target = item_slots[item]
	if item.amount > 1:
		item.amount -= 1
	else:
		item_slots.erase(item)
		item_slots.resize(inventory_size)

# TODO : Only useful for debug, possibly delete
func _print_inventory():
	for slot in item_slots:
		print("Slot: ", slot, " item: ", slot.item)

# Swap items_slots in inventory based on their indices
func swap_items(index1, index2):
	if index1 < 0 or index1 > item_slots.size() or index2< 0 or index2 > item_slots.size():
		return false
	print("index1: ", index1 ,"slot1: ", item_slots[index1])
	print("index2: ", index2, "slot2: ", item_slots[index2])
	var temp_slot = item_slots[index1]
	item_slots[index1] = item_slots[index2]
	item_slots[index2] = temp_slot
	inventory_update.emit()
	return true
