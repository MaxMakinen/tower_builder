extends TextureRect

@onready var item_icon: TextureRect = %ItemIcon
@onready var item_amount: Label = %ItemAmount



func display_item(item: InventorySlot) -> void:
	if item != null and item.item != null:
		# TODO : In case we decide for proper individual sprites
		#item_icon.texture = load("res://Assets/crafting_materials/%s" % item.item.name)
		item_icon.texture = item.item.texture
		item_amount.text = str(item.amount) if item.is_stackable() else ""
	else:
		item_icon.texture = null
		item_amount.text = ""
