class_name InventorySlot
extends Resource


@export var item: ItemResource
@export var amount: int

signal slot_update


func change_amount(new_amount):
	amount += new_amount
	slot_update.emit()


func is_stackable() -> bool:
	if item.max_stack_size > 1:
		return true
	else:
		return false
