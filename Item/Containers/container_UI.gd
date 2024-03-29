extends Control


# ONREADY VARIABLES
@onready var inventory_container: GridContainer = %ContainerContents
@onready var title_bar: Label = %TitleBar


# Ensure inventory starts closed
var _is_open: bool = false


func _ready() -> void:
	close()
	inventory_container.selected_changed.connect(_display_selected)

func _display_selected(index: int = -1) -> void:
	if index >= 0 and index < inventory_container.get_inventory().get_inventory_size():
		var selected: InventorySlot = inventory_container.get_inventory().get_item_at(index)
		if selected == null:
			return
#			_display_default()
#		item_name.text = selected.get_item_name()
#		item_description.text = selected.get_item_description()
#	else:
#		_display_default()


func open(new_inventory: Inventory) -> void:
	if inventory_container.get_inventory() != new_inventory:
		inventory_container.set_inventory(new_inventory)
	inventory_container.display_items()
	visible = true
	_is_open = true


func close() -> void:
	inventory_container.clear_items()
	visible = false
	_is_open = false


func set_inventory(new_inventory: Inventory) -> void:
	inventory_container.set_inventory(new_inventory)


func set_container_name(new_name: String) -> void:
	title_bar.text = new_name


func get_slot_container() -> SlotContainer:
	return inventory_container


func _on_sort_pressed() -> void:
	inventory_container.get_inventory().sort()

