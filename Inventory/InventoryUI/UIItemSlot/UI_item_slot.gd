class_name UIItemSlot
extends TextureRect


@onready var item_icon: TextureRect = %ItemIcon
@onready var item_amount: Label = %ItemAmount

var _slot_type: SlotManager.SlotType = SlotManager.SlotType.INVENTORY
var _contents: InventorySlot = null

signal selected_changed()
var _selected: bool = false:
	set(new_selected):
		selected_changed.emit()
		_selected = new_selected

# TODO : Change into two separate functions: set_contents and display_contents
func set_contents(item: InventorySlot) -> void:
	_contents = item

func display_contents() -> void:
	if _contents != null and _contents.get_item() != null:
		item_icon.texture = _contents.get_texture()
		item_amount.text = str(_contents.get_amount()) if _contents.is_stackable() else ""
	else:
		item_icon.texture = null
		item_amount.text = ""


# Display item sprite and amount that are found inside the InventorySlot If nothing found in slot then display empty
func display_item(item: InventorySlot) -> void:
	_contents = item
	if item != null and item.get_item() != null:
		item_icon.texture = item.get_texture()
		item_amount.text = str(item.get_amount()) if item.is_stackable() else ""
		# TODO : Should we replace custom tooltip with built-in option and customize that?
		#set_tooltip_text(item.item.name)
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

# TODO: Display_item needs to be replaced by a display contents function
func pickup_slot() -> InventorySlot:
	var temp = _contents.duplicate()
	_contents.empty()
	display_contents()
	return temp

# TODO : We might want to rename these things
func copy_slot(slot: InventorySlot) -> void:
	if _contents:
		_contents.copy_slot(slot)
	else:
		_contents = slot.duplicate()
	display_contents()

# Return true if slot empty
func is_empty() -> bool:
	if _contents == null or _contents.is_empty():
		return true
	return false

