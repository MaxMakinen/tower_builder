extends Control

# EXPORT VARIABLES
@export var inventory: Inventory
@export var slot_scene: PackedScene

# ONREADY VARIABLES
@onready var description = %Description
@onready var item_description: PanelContainer = $PanelContainer/VBoxContainer/HBoxContainer/ItemDescription
@onready var ui_inv_slot_container: GridContainer = $PanelContainer/VBoxContainer/HBoxContainer/UIInvSlotContainer

# Ensure inventory starts closed
var is_open: bool = false

func _ready() -> void:
	close()

# Toggle if inventory open or closed
func toggle() -> void:
	if is_open == true:
		close()
	else:
		open()

func get_slot_container() -> SlotContainer:
	return ui_inv_slot_container

func open() -> void:
	visible = true
	is_open = true


func close() -> void:
	visible = false
	is_open = false


func _on_button_pressed() -> void:
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

