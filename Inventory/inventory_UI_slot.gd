extends Control


@onready var item_visual: Sprite2D = $CenterContainer/Panel/Item_display
@onready var selection: Sprite2D = $CenterContainer/Panel/Selection
@onready var stack_size: Label = $CenterContainer/Panel/Stack_size
@onready var item_display: NinePatchRect = $Item_display
@onready var item_name: Label = $Item_display/Item_name
@onready var item_type: Label = $Item_display/Item_type
@onready var item_description: Label = $Item_display/Item_description


# Contained item and item stack size
var contents: InventorySlot = null


func  _ready():
	# Ensure item_display starts out invisible for all slots
	item_display.visible = false


func update(item_slot: InventorySlot):
	if !item_slot.item:
		item_visual.visible = false
		stack_size.visible = false
	else:
		# Store contained slot. Necessary? Yes, for drag and drop.
		contents = item_slot
		item_visual.visible = true
		_set_texture(item_slot)
		_set_details(item_slot.item)


func _set_texture(item_slot: InventorySlot):
	item_visual.texture = item_slot.item.texture
	stack_size.text = str(item_slot.amount)
	if item_slot.amount > 1:
		stack_size.visible = true
	else:
		stack_size.visible = false
	if item_slot.item.spritesheet == true:
		item_visual.hframes = item_slot.item.Hframes
		item_visual.vframes = item_slot.item.Vframes
		item_visual.frame = item_slot.item.frame


func _set_details(item: ItemResource):
	item_name.text = item.name
	item_type.text = item.type
	item_description.text = item.description

func _on_item_button_mouse_entered():
#	print("Mouse entered button")
	selection.visible = true


func _on_item_button_mouse_exited():
#	print("Mouse exited button")
	selection.visible = false


func _on_item_button_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			if contents != null:
				item_display.visible = !item_display.visible

