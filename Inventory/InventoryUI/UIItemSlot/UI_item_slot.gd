extends TextureRect

class_name ItemSlot

@onready var item_icon: TextureRect = %ItemIcon
@onready var item_amount: Label = %ItemAmount

# Display item sprite and amount that are found inside the InventorySlot
func display_item(item: InventorySlot) -> void:
	if item != null and item.item != null:
		item_icon.texture = item.item.texture
		item_amount.text = str(item.amount) if item.is_stackable() else ""
	else:
		item_icon.texture = null
		item_amount.text = ""
