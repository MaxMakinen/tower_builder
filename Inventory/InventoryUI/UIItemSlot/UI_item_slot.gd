class_name UIItemSlot
extends TextureRect


@onready var item_icon: TextureRect = %ItemIcon
@onready var item_amount: Label = %ItemAmount

var _slot_type: SlotManager.SlotType = SlotManager.SlotType.INVENTORY
var _contents: InventorySlot = null
var _ghost: bool = false

signal selected_changed()
var _selected: bool = false:
	set(new_selected):
		selected_changed.emit()
		_selected = new_selected

func grab_item() -> InventorySlot:
	_ghost = true
	display_contents()
	return _contents

func put_item(item: InventorySlot) -> InventorySlot:
	print("Item put")
	# If no contents, set new item as contents and return null
	if (!_contents or _contents.is_empty()) and item != null:
		print("Item put2")
		set_contents(item)
		return null
	# If there is contents, swap with new item and return old contents
	if _contents and !_contents.is_empty() and item != null:
		# If new item is the same as contents, attempt to stack and return whatever is left over
		if item.get_item_name() == _contents.get_item_name():
			print("Item put4")
			return _attempt_stack(item)
		else:
			return _swap_content(item)
	return item

func _swap_content(item: InventorySlot) -> InventorySlot:
	return _contents.swap_slot(item)

func _attempt_stack(item:InventorySlot) -> InventorySlot:
	if _contents.is_stackable() and !_contents.is_full():
		# If there is anything left over after attempting to stack, return stack with leftovers. Otherwise return null.
		var difference = _contents.change_amount(item.get_amount())
		if difference > 0:
			item.set_amount(difference)
			return item
		return null
	return _swap_content(item)


# TODO : Change into two separate functions: set_contents and display_contents
func set_contents(item: InventorySlot) -> void:
	if _contents == null:
		_contents = item
	else:
		_contents.put_slot(item)
	if _contents and !_contents.is_connected("slot_changed", display_contents):
		_contents.slot_changed.connect(display_contents)
	display_contents()

func get_contents() -> InventorySlot:
	return _contents

func display_contents() -> void:
	if _contents != null and !_contents.is_empty():
		item_icon.texture = _contents.get_texture()
		item_amount.text = str(_contents.get_amount()) if _contents.is_stackable() else ""
		if _ghost:
			item_icon.modulate = Color(1, 1, 1, 0.2)
		elif !_ghost:
			item_icon.modulate = Color(1, 1, 1, 1)
	else:
		item_icon.texture = null
		item_amount.text = ""

# Toggle whether slot is selected, modulate color accordingly
func select() -> void:
	_selected = true
	modulate = Color(0.9, 0.9, 0.9)


func unselect() -> void:
	_selected = false
	modulate = Color(1, 1, 1)


# TODO : This might be useless
#Return selected status of slot
func is_selected() -> bool:
	return _selected
	
# Highlight slot under mouse, unless the slot is already selected
func _on_mouse_entered() -> void:
	SlotManager.set_slot_under_mouse(self)
	if !_selected:
		modulate = Color(0.9, 1, 0.9)


# Remove highlight when mouse leaves slot, unless the slot is already selected
func _on_mouse_exited() -> void:
	SlotManager.set_slot_under_mouse(null)
	if !_selected:
		modulate = Color(1, 1, 1)


func get_type() -> SlotManager.SlotType:
	return _slot_type

func get_item_type() -> ItemResource:
	return _contents.get_item()

func slot_moved() -> void:
	if _ghost and _contents:
		_contents.empty()
	unghost()


func unghost() -> void:
	_ghost = false
	display_contents()

func is_ghost() -> bool:
	return _ghost

func pickup_slot() -> InventorySlot:
	#var temp = _contents.duplicate()
	#_contents.empty()
	_ghost = true
	display_contents()
	return _contents

# TODO : We might want to rename these things
func copy_slot(slot: InventorySlot) -> void:
	if _contents:
		_contents.copy_slot(slot)
	else:
		_contents = slot.duplicate()

# Return true if slot empty
func is_empty() -> bool:
	if _contents == null or _contents.is_empty():
		return true
	return false

