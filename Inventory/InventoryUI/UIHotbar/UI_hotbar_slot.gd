class_name UIHotbarSlot
extends UIItemSlot

@onready var selection: TextureRect = $Selection

# Keeps track of total amount of items of same type in inventory
var total_amount: int
var content: InventorySlot

func _ready() -> void:
	_slot_type = SlotManager.SlotType.HOTBAR

# Display item sprite and amount that are found inside the InventorySlot If nothing found in slot then display empty
func display_item(item: InventorySlot) -> void:
	if item != null and item.get_item() != null:
		content = item
		item_icon.texture = item.get_texture()
		item_amount.text = str(total_amount) if item.is_stackable() else ""
		# TODO : Should we replace custom tooltip with built-in option and customize that?
		#set_tooltip_text(item.item.name)
	else:
		item_icon.texture = null
		item_amount.text = ""

# Sets total amount to new value
func set_total_amount(new_amount: int) -> void:
	total_amount = new_amount

# Toggle whether slot is selected, modulate color accordingly
func select() -> void:
	_selected = true
	selection.visible = true


func unselect() -> void:
	_selected = false
	selection.visible = false


func get_content() -> InventorySlot:
	return content

# TODO : This might be useless
# Return selected status of slot
func is_selected() -> bool:
	return _selected
