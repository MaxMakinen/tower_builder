class_name InventoryUISlot
extends PanelContainer


#@onready var item_visual = %ItemDisplay
@onready var item_visual = %Item_display

@onready var slot_background = %SlotBackground
#@onready var item_visual: Sprite2D = $CenterContainer/Panel/Item_display
#@onready var selection: Sprite2D = $CenterContainer/Panel/Selection
#@onready var stack_size: Label = $CenterContainer/Panel/Stack_size

@onready var item_description: Label = $Item_details/Item_description
@onready var selection = %Selection
@onready var stack_size = %Stack_size

# Signals
signal drag_start(slot)
signal drag_end()
signal selected(slot)

# Contained item and item stack size
var contents: InventorySlot = null
var slot_selected: bool = false

func  _ready():
	# Ensure item_details starts out invisible for all slots
	pass


func update(item_slot: InventorySlot):
	if !item_slot.item or item_slot.amount < 1:
		contents = null
		item_visual.visible = false
		stack_size.visible = false
	else:
		# Store contained slot. Necessary? Yes, for drag and drop.
		# TODO Or is it!? clean up if necessary
		contents = item_slot
		item_visual.visible = true
		_set_texture(item_slot)

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


func _on_item_button_mouse_entered():
#	print("Mouse entered button")
	selection.visible = true


func _on_item_button_mouse_exited():
#	print("Mouse exited button")
	if slot_selected == false:
		selection.visible = false


func _toggle_selected():
	slot_selected = !slot_selected


func unselect():
	slot_selected = false
	selection.visible = false


func _on_item_button_gui_input(event):
	if event is InputEventMouseButton:
		# Details display
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			if contents != null:
				#item_details.visible = !item_details.visible
				_toggle_selected()
				selected.emit(self)
		# Dragging item
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.is_pressed():
				slot_background.modulate = Color(0.8, 0.8, 1)
				drag_start.emit(self)
			else:
				slot_background.modulate = Color(1, 1, 1)
				drag_end.emit()


