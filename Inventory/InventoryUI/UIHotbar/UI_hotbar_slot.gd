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

# Override to change item_amount.text to total amount instead of stack size
func display_contents() -> void:
	if _contents != null and !_contents.is_empty():
		item_icon.texture = _contents.get_texture()
		item_amount.text = str(_total_amount) if _contents.is_stackable() else ""
	else:
		item_icon.texture = null
		item_amount.text = ""

# Setter for Hotbar slot with signal emit
func set_hotbar_slot(item: InventorySlot) -> void:
	_total_amount = get_parent().get_total_amount(item)
	set_contents(item)
	new_content.emit(self)
	display_contents()

func unghost() -> void:
	_ghost = false
	display_contents()

func slot_moved() -> void:
	if _ghost && _contents:
		set_hotbar_slot(null)
	unghost()


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
