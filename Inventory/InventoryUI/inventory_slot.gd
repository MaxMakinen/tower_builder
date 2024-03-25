class_name InventorySlot
extends Resource


@export var item: ItemResource
@export var amount: int

# TODO : Is this signal useful at all?
signal slot_update


func change_amount(new_amount) -> int:
	amount += new_amount
	slot_update.emit()
	return amount


func is_stackable() -> bool:
	if item.max_stack_size > 1:
		return true
	else:
		return false
