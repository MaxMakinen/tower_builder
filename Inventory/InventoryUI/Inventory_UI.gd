extends Control

# EXPORT VARIABLES
@export var inventory: Inventory
@export var slot_scene: PackedScene

# ONREADY VARIABLES
@onready var ui_inv_slot_container: GridContainer = %UIInvSlotContainer
@onready var item_name: Label = %ItemName
@onready var item_description: Label = %ItemDescription

const DEFAULT_NAME: String = "ItemName"
const DEFAULT_DESCRIPTION: String = "Lorem Ipsum Est"

# Ensure inventory starts closed
var _is_open: bool = false

#var _selected: int = -1

func _ready() -> void:
	close()
	_display_selected(-1)
	ui_inv_slot_container.selected_changed.connect(_display_selected)

# Toggle if inventory open or closed
func toggle() -> void:
	if _is_open == true:
		close()
	else:
		open()

func _display_selected(index: int) -> void:
	var inv: Inventory = ui_inv_slot_container.get_inventory()
	var selected: InventorySlot = inv.get_item_at(index)
	if selected == null:
		return
	if index >= 0 and index < inv.get_inventory_size():
		item_name.text = inv.get_item_at(index).get_item_name()
		item_description.text = inv.get_item_at(index).get_item_description()
	else:
		item_name.text = DEFAULT_NAME
		item_description.text = DEFAULT_DESCRIPTION


func get_slot_container() -> SlotContainer:
	return ui_inv_slot_container


func open() -> void:
	visible = true
	_is_open = true


func close() -> void:
	visible = false
	_is_open = false


func _on_drop_button_pressed() -> void:
	pass # Replace with function body.


func _on_use_button_pressed() -> void:
	print("Inventory size : ", inventory.get_inventory_size())
	print("Inventory contents : ")
	for index in inventory.get_inventory_size():
		if inventory.item_slots[index]:
			var item = inventory.item_slots[index]
			#if item.item:
			#	print("name : ", item.item.name)
			print("index : ", index," item : ", item.get_item_name(), " amount : ", item.amount)
		else:
			print("index : ", index, " Slot empty")

