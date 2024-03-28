class_name UIHotbarSlot
extends UIItemSlot

@onready var selection: TextureRect = $Selection

var total_amount: int

# Display item sprite and amount that are found inside the InventorySlot If nothing found in slot then display empty
func display_item(item: InventorySlot) -> void:
	if item != null and item.get_item() != null:
		item_icon.texture = item.get_texture()
		item_amount.text = str(total_amount) if item.is_stackable() else ""
		# TODO : Should we replace custom tooltip with built-in option and customize that?
		#set_tooltip_text(item.item.name)
	else:
		item_icon.texture = null
		item_amount.text = ""


func set_total_amount(amount: int) -> void:
	total_amount = amount

# Toggle whether slot is selected, modulate color accordingly
func select() -> void:
	_selected = true
	selection.visible = true


func unselect() -> void:
	_selected = false
	selection.visible = false

# TODO : This might be useless
# Return selected status of slot
func is_selected() -> bool:
	return _selected
