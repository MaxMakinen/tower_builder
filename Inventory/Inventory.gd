extends Resource

class_name Inventory

signal update

@export var item_slots: Array[InventorySlot]

func insert(item: ItemResource):
	var slots = item_slots.filter(func(slot): return slot.item == item)
	if !slots.is_empty():
		slots[0].amount += 1
	else:
		var emptyslots = item_slots.filter(func(slot): return slot.item == null)
		if !emptyslots.is_empty():
			emptyslots[0].item = item
			emptyslots[0].amount = 1
	update.emit()

