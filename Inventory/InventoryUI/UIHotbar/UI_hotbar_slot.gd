class_name UIHotbarSlot
extends UIItemSlot

@onready var selection: TextureRect = $Selection


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
	# TODO : Might be better to move selected bool from inventory to slot container.
	# If slot selected and in hotbar, modulate accordingly
#	if get_parent() and get_parent().name == "UIHotbar":
#		if get_index() == get_parent().inventory.selected:
#			modulate = Color(0.8, 0.8, 0.8)
#		else:
#			modulate = Color(1, 1, 1)

# Toggle whether slot is selected, modulate color accordingly
func select() -> void:
	_selected = true
	selection.visible = true


func unselect() -> void:
	_selected = false
	selection.visible = false


# TODO : This might be useless
#Return selected status of slot
func is_selected() -> bool:
	return _selected
