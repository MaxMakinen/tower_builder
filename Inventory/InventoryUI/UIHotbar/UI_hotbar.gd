class_name UIHotbar
extends SlotContainer


#const UI_HOTBAR_SLOT = preload("res://Inventory/InventoryUI/UIHotbar/UI_hotbar_slot.tscn")
var hotbar_size = 6

# TODO : Testing setter and getters, might be useful, might not
# Keep track of selected hotbar slot, send signal in case of change
signal hotbar_changed(selection)
var _hotbar_selection: int = 0: set = _set_hotbar_selection
#	set(selection):
#		hotbar_changed.emit(selection)
#		_hotbar_selection = selection
#	get:
#		return _hotbar_selection

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	columns = hotbar_size
	if !inventory or !inventory.item_slots:
		inventory = Inventory.new(hotbar_size)
	inventory.set_selected(_selected) 
	connect_to_inventory()
	display_items()
	_hotbar_selection = 0


func set_hotbar_size(new_size: int) -> void:
	hotbar_size = new_size
	columns = hotbar_size


func get_hotbar_size() -> int:
	return hotbar_size


func load_hotbar(new_inventory: Inventory) -> void:
	inventory = new_inventory
	columns = inventory.get_inventory_size()
	display_items()


func _set_hotbar_selection(new_selection: int) -> void:
	get_child(_hotbar_selection).unselect()
	get_child(new_selection).select()
	_hotbar_selection = new_selection
	hotbar_changed.emit(_hotbar_selection)

# Highlight selected slot
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action_pressed("1"):
			_hotbar_selection = 0
		if event.is_action_pressed("2"):
			_hotbar_selection = 1
		if event.is_action_pressed("3"):
			_hotbar_selection = 2
		if event.is_action_pressed("4"):
			_hotbar_selection = 3
		if event.is_action_pressed("5"):
			_hotbar_selection = 4
		if event.is_action_pressed("6"):
			_hotbar_selection = 5
#		if event.is_action_pressed("7"):
#			inventory.set_selected(6)
#		if event.is_action_pressed("8"):
#			inventory.set_selected(7)
#		if event.is_action_pressed("9"):
#			inventory.set_selected(8)

