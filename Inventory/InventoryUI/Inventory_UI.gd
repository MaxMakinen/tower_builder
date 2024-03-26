extends Control

# EXPORT VARIABLES
@export var inventory: Inventory
@export var slot_scene: PackedScene

# ONREADY VARIABLES
@onready var inventory_container: GridContainer = %UIInvSlotContainer
@onready var item_name: Label = %ItemName
@onready var item_description: Label = %ItemDescription

const DEFAULT_NAME: String = "ItemName"
const DEFAULT_DESCRIPTION: String = "Lorem Ipsum Est"

# Ensure inventory starts closed
var _is_open: bool = false

var _selected: int = -1

func _ready() -> void:
	close()
	_display_default()
	

# Toggle if inventory open or closed
func toggle() -> void:
	if _is_open == true:
		close()
	else:
		open()

func _display_selected(index: int) -> void:
	_selected = index
	if index >= 0 and index < inventory_container.get_inventory().get_inventory_size():
		var selected: InventorySlot = inventory_container.get_inventory().get_item_at(index)
		if selected == null:
			_display_default()
			return
		item_name.text = selected.get_item_name()
		item_description.text = selected.get_item_description()
	else:
		_display_default()

func _display_default() -> void:
	item_name.text = DEFAULT_NAME
	item_description.text = DEFAULT_DESCRIPTION

func get_slot_container() -> SlotContainer:
	return inventory_container


func open() -> void:
	inventory_container.display_items()
	inventory_container.selected_changed.connect(_display_selected)
	visible = true
	_is_open = true


func close() -> void:
	inventory_container.clear_items()
	visible = false
	_is_open = false


func _on_drop_button_pressed() -> void:
	if _selected >= 0:
		var world = get_parent().get_parent()
		var pickup = Global.pickup.instantiate()
		pickup.spawn_item(inventory_container.get_inventory().remove_item(_selected).get_item(), self.global_position)
		world.add_child(pickup)
	else:
		print("Nothing selected")
	#print(get_tree_string_pretty())
#drag_preview.set_dragged_item(target_inventory.remove_item(index))

func _on_use_button_pressed() -> void:
	if _selected >= 0:
		if !inventory_container.get_inventory().get_item_at(_selected).use_item():
			print("Item not consumable")
	
#	print("Inventory size : ", inventory.get_inventory_size())
#	print("Inventory contents : ")
#	for index in inventory.get_inventory_size():
#		if inventory.item_slots[index]:
#			var item = inventory.item_slots[index]
#			#if item.item:
#			#	print("name : ", item.item.name)
#			print("index : ", index," item : ", item.get_item_name(), " amount : ", item.amount)
#		else:
#			print("index : ", index, " Slot empty")

