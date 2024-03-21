class_name InventorySlot
extends Resource

# TODO : Might remove entrie thing and only use ItemResources

@export var item: ItemResource
@export var amount: int

signal slot_update


func decrease():
	amount -= 1
	slot_update.emit()


func increase():
	amount += 1
	slot_update.emit()


func is_stackable():
	if item.max_stack_size > 1:
		return true
	else:
		return false
