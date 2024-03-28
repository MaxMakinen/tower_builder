class_name UIHotbar
extends SlotContainer


#const UI_HOTBAR_SLOT = preload("res://Inventory/InventoryUI/UIHotbar/UI_hotbar_slot.tscn")
var hotbar_size = 6

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	columns = hotbar_size
	if !inventory or !inventory.item_slots:
		inventory = Inventory.new(hotbar_size)
	inventory.set_selected(0) 
	connect_to_inventory()
	display_items()


func set_hotbar_size(new_size: int) -> void:
	hotbar_size = new_size
	columns = hotbar_size


func get_hotbar_size() -> int:
	return hotbar_size


func load_hotbar(new_inventory: Inventory) -> void:
	inventory = new_inventory
	columns = inventory.get_inventory_size()
	display_items()

# TODO : Needs to reference slots, not inventory
# Highlight selected slot
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action_pressed("1"):
			inventory.set_selected(0)
		if event.is_action_pressed("2"):
			inventory.set_selected(1)
		if event.is_action_pressed("3"):
			inventory.set_selected(2)
		if event.is_action_pressed("4"):
			inventory.set_selected(3)
		if event.is_action_pressed("5"):
			inventory.set_selected(4)
		if event.is_action_pressed("6"):
			inventory.set_selected(5)
#		if event.is_action_pressed("7"):
#			inventory.set_selected(6)
#		if event.is_action_pressed("8"):
#			inventory.set_selected(7)
#		if event.is_action_pressed("9"):
#			inventory.set_selected(8)

