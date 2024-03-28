class_name UIHotbar
extends SlotContainer


#const UI_HOTBAR_SLOT = preload("res://Inventory/InventoryUI/UIHotbar/UI_hotbar_slot.tscn")
var hotbar_size = 6

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	columns = hotbar_size
	if !inventory or !inventory.item_slots:
		inventory = Inventory.new(hotbar_size)
	inventory.set_selected(_selected) 
	connect_to_inventory()
	display_items()
	#_hotbar_selection = 0
	_selected = 0


func set_hotbar_size(new_size: int) -> void:
	hotbar_size = new_size
	columns = hotbar_size


func get_hotbar_size() -> int:
	return hotbar_size


func load_hotbar(new_inventory: Inventory) -> void:
	inventory = new_inventory
	columns = inventory.get_inventory_size()
	display_items()

# Overload parent version. Set new value for selected
func _set_selected(new_selected: int) -> void:
	get_child(_selected).unselect()
	get_child(new_selected).select()
	_selected = new_selected
	selected_changed.emit(_selected)


# Highlight selected slot
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action_pressed("1"):
			#_hotbar_selection = 0
			_selected = 0
		if event.is_action_pressed("2"):
			#_hotbar_selection = 1
			_selected = 1
		if event.is_action_pressed("3"):
			#_hotbar_selection = 2
			_selected = 2
		if event.is_action_pressed("4"):
			#_hotbar_selection = 3
			_selected = 3
		if event.is_action_pressed("5"):
			#_hotbar_selection = 4
			_selected = 4
		if event.is_action_pressed("6"):
			#_hotbar_selection = 5
			_selected = 5
#		if event.is_action_pressed("7"):
#			inventory.set_selected(6)
#		if event.is_action_pressed("8"):
#			inventory.set_selected(7)
#		if event.is_action_pressed("9"):
#			inventory.set_selected(8)

