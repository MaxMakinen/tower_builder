class_name UIHotbarSlot
extends UIItemSlot

@onready var selection: TextureRect = $Selection

# Keeps track of total amount of items of same type in inventory
var _total_amount: int
var content: InventorySlot

# SIGNALS
signal hotbar_slot_changed()
signal new_content(slot)

func _ready() -> void:
	_slot_type = SlotManager.SlotType.HOTBAR

func put_item(item: InventorySlot) -> InventorySlot:
	if item:
		# If no contents, set new item as contents and return null
		if (!content or content.is_empty()) and item != null:
			set_contents(item)
			return null
		# If there is contents, swap with new item and return old contents
		if content and !content.is_empty() and item != null:
			var temp = _contents.duplicate()
			set_contents(item)
			return temp
		#If new item is the same as contents, attempt to stack and return whatever is left over
		if item.get_item_name() == _contents.get_item_name():
			return item
	return item



# Override to change item_amount.text to total amount instead of stack size
func display_contents() -> void:
	if _contents != null and !_contents.is_empty():
		item_icon.texture = _contents.get_texture()
		item_amount.text = str(_total_amount) if _contents.is_stackable() else ""
	else:
		item_icon.texture = null
		item_amount.text = ""


# Overload Setter for Hotbar slot with signal emit
func set_contents(item: InventorySlot) -> void:
	_total_amount = Global.player_inventory.get_total_amount(item.get_item())
	_contents = item
	if _contents and !_contents.is_connected("slot_changed", display_contents):
		_contents.slot_changed.connect(display_contents)
	new_content.emit(self)
	display_contents()


# Sets total amount to new value
func set_total_amount(new_amount: int) -> void:
	_total_amount = new_amount
	display_contents()

# Returns total amount as int
func get_total_amount() -> int:
	return _total_amount

# Toggle whether slot is selected, modulate color accordingly
func select() -> void:
	_selected = true
	selection.visible = true

# Toggle whether slot is unselected, modulate color accordingly
func unselect() -> void:
	_selected = false
	selection.visible = false


func get_content() -> InventorySlot:
	return content

# TODO : This might be useless
# Return selected status of slot
func is_selected() -> bool:
	return _selected
