extends GridContainer

class_name SlotContainer

@export var item_slots: PackedScene = preload("res://Inventory/InventoryUI/UIItemSlot/UI_item_slot.tscn")
@export var inventory: Inventory = null


var _selected: int = -1: set = _set_selected, get = get_selected

signal selected_changed(index)

# TODO : Will we implement rows and cols for more grid control?

func _init(new_inventory: Inventory = inventory) -> void:
	inventory = new_inventory
	if !inventory:
		set_inventory(Inventory.new())


func _ready() -> void:
	connect_to_inventory()
	pass

# Populate slot container with item_slots according to inventory size and display all items in inventory
func display_items() -> void:
	inventory.refresh()
	for index in range(inventory.get_inventory_size()):
		var item_slot = item_slots.instantiate()
		add_child(item_slot)
		item_slot.set_contents(inventory.get_item_at(index))
		item_slot.display_contents()

# Connect to inventory signals
func connect_to_inventory() -> void:
	inventory.inventory_update.connect(_on_inventory_update)
	inventory.selected_changed.connect(_set_selected)

# Remove all child item_slot nodes
func clear_items() -> void:
	for child in get_children():
		child.queue_free()

# Return reference to inventory
func get_inventory() -> Inventory:
	return inventory

func get_inventory_size() -> int:
	return inventory.get_inventory_size()

func set_inventory(new_inventory: Inventory) -> void:
	inventory = new_inventory
	connect_to_inventory()

# Updates display for item_slot referenced by index
func _on_inventory_update(indices: Array[int]) -> void:
	for index in indices:
		if get_child_count() == inventory.get_inventory_size() and index >= 0 and index < inventory.get_inventory_size():
			var item_slot = get_child(index)
			if item_slot:
				item_slot.display_contents()
				#item_slot.display_item(inventory.get_item_at(index))
				#print("Inv Update at index : ", index)

# Set new value for selected
func _set_selected(new_selected: int) -> void:
	# If there is already a selected slot, unselect slot.
	if _selected >= 0:
		get_child(_selected).unselect()
	# If target is already selected, de-select target.
	if new_selected == _selected:
		_selected = -1
	else:
		_selected = new_selected
		get_child(_selected).select()
	selected_changed.emit(_selected)

# Return selected as Int
func get_selected() -> int:
	return _selected

# Return item from inventory at index
func get_item_at(index: int) -> InventorySlot:
	return inventory.get_item_at(index)
