extends GridContainer

class_name SlotContainer

@export var item_slot: PackedScene = preload("res://Inventory/InventoryUI/UIItemSlot/UI_item_slot.tscn")
@export var inventory: Inventory


# TODO : Will we implement rows and cols for more grid control?


func display_items() -> void:
	for index in range(inventory.inventory_size):
		var item_slot = item_slot.instantiate()
		add_child(item_slot)
		item_slot.display_item(inventory.get_item_at(index))
	inventory.inventory_update.connect(_on_inventory_update)


func _on_inventory_update(indices: Array[int]) -> void:
	for index in indices:
		if index < inventory.inventory_size:
			var item_slot = get_child(index)
			item_slot.display_item(inventory.get_item_at(index))
