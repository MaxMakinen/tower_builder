extends Control

# ONREADY VARIABLES
@onready var inventory_container: GridContainer = %UIInvSlotContainer
@onready var item_name: Label = %ItemName
@onready var item_description: Label = %ItemDescription
@onready var player = get_tree().get_first_node_in_group("player")

const DEFAULT_NAME: String = "ItemName"
const DEFAULT_DESCRIPTION: String = "Lorem Ipsum Est"

# Ensure inventory starts closed
var _is_open: bool = false


func _ready() -> void:
	inventory_container.set_inventory(Global.player_inventory)
	close()
	_display_default()
	#inventory_container.connect_to_inventory()
	inventory_container.selected_changed.connect(_display_selected)
	

# Toggle if inventory open or closed
func toggle() -> void:
	print("inv toggle")
	if _is_open == true:
		close()
	else:
		open()

func _display_selected(index: int = -1) -> void:
#	_selected = index
	if index >= 0 and index < Global.player_inventory.get_inventory_size():
		var selected: InventorySlot = Global.player_inventory.get_item_at(index)
		if selected == null:
			_display_default()
			return
		item_name.text = selected.get_item_name()
		item_description.text = selected.get_item_description()
	else:
		_display_default()

func _display_default() -> void:
	item_name.text = DEFAULT_NAME
	item_description.text = DEFAULT_DESCRIPTION + "\nInventory Size : " + str(inventory_container.get_inventory_size())

func get_slot_container() -> SlotContainer:
	return inventory_container


func open() -> void:
	inventory_container.display_items()
	visible = true
	_is_open = true
	print("Open inventory: ", Global.player_inventory)
	print("contents: ")
	for item in Global.player_inventory.get_items():
		if item and !item.is_empty():
			print("name : ", item.get_item_name())
#	print("Done opening inv")


func close() -> void:
	inventory_container.clear_items()
	visible = false
	_is_open = false


func _on_drop_button_pressed() -> void:
	var selected = inventory_container.get_selected()
	if selected >= 0:
		var target_slot = inventory_container.get_inventory().get_item_at(selected)
		if target_slot and !target_slot.is_empty():
			var world = get_parent().get_parent()
			var pickup = Global.pickup.instantiate()
			pickup.spawn_item(target_slot.get_item(), self.global_position)
			target_slot.change_amount(-1)
			world.add_child(pickup)
		else:
			item_description.text = "Slot empty"
	else:
		item_description.text = "Nothing selected"


func _on_use_button_pressed() -> void:
	var selected = inventory_container.get_selected()
	if selected >= 0:
		var item = inventory_container.get_inventory().get_item_at(selected)
		if !item:
			item_description.text = "Slot empty"
			#get_tree().create_timer(1).timeout.connect(_display_selected)
			#print("Slot empty")
		elif !item or !item.use_item():
			item_description.text = "Item not consumable"
			#print("Item not consumable")
			#get_tree().create_timer(1).timeout.connect(_display_selected)
	else:
		item_description.text = "Nothing selected"
		#print("Nothing selected")
	get_tree().create_timer(1).timeout.connect(_display_selected)




func _on_sort_button_pressed() -> void:
	inventory_container.get_inventory().sort()
	pass # Replace with function body.
