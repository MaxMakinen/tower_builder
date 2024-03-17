extends Resource


class_name InventorySlot

@export var item: ItemResource
@export var amount: int

signal slot_update


func decrease():
	amount -= 1
	slot_update.emit()


func increase():
	amount += 1
	slot_update.emit()
