extends Panel


@onready var item_visual: Sprite2D = $CenterContainer/Panel/Item_display
@onready var selection: Sprite2D = $Selection
@onready var stack_size: Label = $CenterContainer/Panel/Stack_size
var selected := false


func update(item_slot: InventorySlot):
	if !item_slot.item:
		item_visual.visible = false
		stack_size.visible = false
	else:
		item_visual.visible = true
		if item_slot.amount > 1:
			stack_size.visible = true
		else:
			stack_size.visible = false
		item_visual.texture = item_slot.item.texture
		stack_size.text = str(item_slot.amount)
		if item_slot.item.spritesheet == true:
			item_visual.hframes = item_slot.item.Hframes
			item_visual.vframes = item_slot.item.Vframes
			item_visual.frame = item_slot.item.frame


#func _on_mouse_entered():
#	print("Mouse entered slot")
#	selection.visible = true

