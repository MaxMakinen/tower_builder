class_name UIHotbar
extends SlotContainer

@onready var player = get_tree().get_first_node_in_group("player")
#const UI_HOTBAR_SLOT = preload("res://Inventory/InventoryUI/UIHotbar/UI_hotbar_slot.tscn")
var hotbar_size = 6

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	columns = hotbar_size
	set_inventory(Global.player_inventory)
	instantiate_hotbar()
	refresh_hotbar()
	_selected = 0

# Populate slot container with item_slots according to inventory size and display all items in inventory
func instantiate_hotbar() -> void:
	for index in range(hotbar_size):
		var item_slot = item_slots.instantiate()
		add_child(item_slot)
		item_slot.new_content.connect(new_slot)


# Clear all children of hotbar
func clear_hotbar() -> void:
	for child in get_children():
		child.queue_free()

# Checks if there are duplicate contents of hotbat slot in hotbar. Returns slot if found, otherwise returns null
func in_hotbar(item: UIHotbarSlot) -> UIHotbarSlot:
	for child in get_children():
		if child != item and !child.is_empty() and child.get_item_type() == item.get_item_type():
			return child
	return null

# Checks if slot has new content, if its not wmpty, checks if there are pre-existing slots with same content and empties them if fond.
func new_slot(slot: UIHotbarSlot) -> void:
	if !slot.is_empty():
		var prev_slot: UIHotbarSlot = in_hotbar(slot)
		if prev_slot != null:
			prev_slot.set_contents(null)

# Goes thorugh all hotbar slots and displays current contents
func refresh_hotbar() -> void:
	for child in get_children():
		child.display_contents()

# Changes lenght of hotbar
func set_hotbar_size(new_size: int) -> void:
	hotbar_size = new_size
	columns = hotbar_size

# Returns size of hotbar
func get_hotbar_size() -> int:
	return hotbar_size

# creates new hotbar based on loaded inventory file
# TODO : No idea if this actually works
func load_hotbar(new_inventory: Inventory) -> void:
	inventory = new_inventory
	columns = inventory.get_inventory_size()
	instantiate_hotbar()

# Overload parent version. Set new value for selected
func _set_selected(new_selected: int) -> void:
	get_child(_selected).unselect()
	get_child(new_selected).select()
	_selected = new_selected
	selected_changed.emit(_selected)


func add_item(item: InventorySlot, index: int) -> void:
	if item == null:
		get_child(index).display_item(null)
		return
	var target_child = get_child(index)
	var total_amount = inventory.get_total_amount(item.get_item())
	if total_amount > 0:
		target_child.set_total_amount(total_amount)
		target_child.display_item(item)

func get_total_amount(item: InventorySlot) -> int:
	if item:
		return inventory.get_total_amount(item.get_item())
	return 0


func get_slot_content(index: int) -> InventorySlot:
	var target = get_child(index).get_content()
	return target

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

