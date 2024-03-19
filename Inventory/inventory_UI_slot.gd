class_name InventorySlot
extends PanelContainer


#@onready var item_visual = %ItemDisplay
@onready var item_visual = %Item_display

@onready var slot_background = %SlotBackground
#@onready var item_visual: Sprite2D = $CenterContainer/Panel/Item_display
#@onready var selection: Sprite2D = $CenterContainer/Panel/Selection
#@onready var stack_size: Label = $CenterContainer/Panel/Stack_size
@onready var item_details: NinePatchRect = $Item_details
@onready var item_name: Label = $Item_details/Item_name
@onready var item_type: Label = $Item_details/Item_type
@onready var item_description: Label = $Item_details/Item_description
@onready var selection = %Selection
@onready var stack_size = %Stack_size

# Signals
signal drag_start(slot)
signal drag_end()

# Contained item and item stack size
var contents: InventorySlot = null


func  _ready():
	# Ensure item_details starts out invisible for all slots
	item_details.visible = false


func update(item_slot: InventorySlot):
	if !item_slot.item or item_slot.amount < 1:
		contents = null
		item_visual.visible = false
		stack_size.visible = false
		item_details.visible = false
	else:
		# Store contained slot. Necessary? Yes, for drag and drop.
		# TODO Or is it!? clean up if necessary
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


func _clear_details():
	item_name.text = ""
	item_type.text = ""
	item_description.text = ""


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
		# Details display
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			if contents != null:
				item_details.visible = !item_details.visible
		# Draggin item
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.is_pressed():
				slot_background.modulate = Color(0.8, 0.8, 1)
				drag_start.emit(self)
			else:
				slot_background.modulate = Color(1, 1, 1)
				drag_end.emit()


func _on_button_pressed():
	contents.decrease()
	update(contents)

