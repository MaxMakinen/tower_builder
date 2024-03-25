extends TextureRect

class_name UIItemSlot

@onready var item_icon: TextureRect = %ItemIcon
@onready var item_amount: Label = %ItemAmount

# Display item sprite and amount that are found inside the InventorySlot If nothing founid in slot then display empty
func display_item(item: InventorySlot) -> void:
	if item != null and item.item != null:
		item_icon.texture = item.item.texture
		item_amount.text = str(item.amount) if item.is_stackable() else ""
		# TODO : Should we replace custom tooltip with built-in option and customize that?
		#set_tooltip_text(item.item.name)
	else:
		item_icon.texture = null
		item_amount.text = ""
	if get_parent() and get_parent().name == "UIHotbar":
		if get_index() == get_parent().inventory.selected:
			modulate = Color(0.8, 0.8, 0.8)
		else:
			modulate = Color(1, 1, 1)

