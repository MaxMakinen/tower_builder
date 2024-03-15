extends Resource


class_name InventorySlot

@export var item: ItemResource
@export var amount: int

func erase():
	item = null
	amount = 0
