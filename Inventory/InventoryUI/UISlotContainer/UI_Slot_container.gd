extends GridContainer

class_name SlotContainer

@export var item_slots: PackedScene = preload("res://Inventory/InventoryUI/UIItemSlot/UI_item_slot.tscn")
@export var inventory: Inventory = null


var _selected: int = -1

signal selected_changed(index)

# TODO : Will we implement rows and cols for more grid control?

# Populate slot container with item_slots according to inventory size and display all items in inventory
func display_items() -> void:
	inventory.refresh()
	for index in range(inventory.get_inventory_size()):
		var item_slot = item_slots.instantiate()
		add_child(item_slot)
		item_slot.display_item(inventory.get_item_at(index))
	inventory.inventory_update.connect(_on_inventory_update)
	inventory.selected_changed.connect(_set_selected)

func clear_items() -> void:
	for child in get_children():
		child.queue_free()

# Return reference to inventory
func get_inventory() -> Inventory:
	return inventory

# Updates display for item_slot referenced by index
func _on_inventory_update(indices: Array[int]) -> void:
	for index in indices:
		if index >= 0 and index < inventory.inventory_size:
			var item_slot = get_child(index)
			item_slot.display_item(inventory.get_item_at(index))

# Set new value for selected
func _set_selected(new_selected: int) -> void:
	# If target is already selected, de-select target.
	if _selected >= 0:
		get_child(_selected).unselect()
	if new_selected == _selected:
		_selected = -1
	else:
		_selected = new_selected
		get_child(_selected).select()
	selected_changed.emit(_selected)

# Return selected as Int
func get_selected() -> int:
	return _selected
