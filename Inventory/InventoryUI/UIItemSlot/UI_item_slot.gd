class_name UIItemSlot
extends TextureRect


@onready var item_icon: TextureRect = %ItemIcon
@onready var item_amount: Label = %ItemAmount

signal selected_changed()
var _selected: bool = false:
	set(new_selected):
		selected_changed.emit()
		_selected = new_selected

# Display item sprite and amount that are found inside the InventorySlot If nothing found in slot then display empty
func display_item(item: InventorySlot) -> void:
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
	if !_selected:
		modulate = Color(0.9, 1, 0.9)

# Remove highlight when mouse leaves slot, unless the slot is already selected
func _on_mouse_exited() -> void:
	if !_selected:
		modulate = Color(1, 1, 1)

