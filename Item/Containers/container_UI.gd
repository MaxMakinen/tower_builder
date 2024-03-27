extends PanelContainer

# EXPORT VARIABLES
@export var slot_scene: PackedScene

# ONREADY VARIABLES
@onready var inventory_container: GridContainer = %UIInvSlotContainer
@onready var title_bar: Label = %TitleBar


const DEFAULT_NAME: String = "ItemName"
const DEFAULT_DESCRIPTION: String = "Lorem Ipsum Est"

# Ensure inventory starts closed
var _is_open: bool = false

#var _selected: int = -1

func _ready() -> void:
	close()
	inventory_container.connect_to_inventory()
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


func open() -> void:
	inventory_container.display_items()
	visible = true
	_is_open = true


func close() -> void:
	inventory_container.clear_items()
	visible = false
	_is_open = false
