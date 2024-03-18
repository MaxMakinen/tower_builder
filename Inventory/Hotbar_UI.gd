extends Control

@onready var inventory: Inventory = preload("res://Inventory/player_inventory.tres")
@onready var hotbar: Hotbar = preload("res://Inventory/player_hotbar.tres")
@onready var slot_container = $NinePatchRect/HBoxContainer
@onready var slots: Array = $NinePatchRect/HBoxContainer.get_children()



# Drag and Drop
var dragged_slot: Control = null

# Called when the node enters the scene tree for the first time.
func _ready():
	hotbar.hotbar_update.connect(update_slots)
	update_slots()

# Get the slot under the mouse if applicable
func _get_slot_under_mouse() -> Control:
	var mouse_position = get_global_mouse_position()
	for slot in slots:
		var slot_rect = Rect2(slot.global_position, slot.size)
		if slot_rect.has_point(mouse_position):
			return slot
	return null


func update_slots():
	for i in range(min(inventory.item_slots.size(), slots.size())):
		slots[i].drag_start.connect(_on_drag_start)
		slots[i].drag_end.connect(_on_drag_end)
		slots[i].update(inventory.item_slots[i])


func _on_drag_start(slot_control: Control):
	dragged_slot = slot_control
	print("Drag started from slot: ", dragged_slot)


#TODO : make version where we can drag split stacks etc. Spawn new stack for moving? Flags for questions?
func _on_drag_end():
	var target_slot = _get_slot_under_mouse()
	if target_slot and dragged_slot != target_slot:
		_drop_slot(dragged_slot, target_slot)
	dragged_slot = null


func _get_slot_index(slot: Control) -> int:
	for i in range(slots.size()):
		if slots[i] == slot:
			# Valid slot found
			return i
	# Invalid slot
	return -1


func _drop_slot(slot1: Control, slot2: Control):
	var slot1_index = _get_slot_index(slot1)
	var slot2_index = _get_slot_index(slot2)
	if slot1_index == -1 or slot2_index == -1:
		print("Invalid slots found")
		return
	else:
		if inventory.swap_items(slot1_index, slot2_index):
			print("Dropping slot items: ", slot2, " ", slot2_index)

