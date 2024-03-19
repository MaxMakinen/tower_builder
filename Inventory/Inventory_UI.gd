extends Control

@export var inventory: Inventory

@onready var grid_container = %GridContainer
@export var slot_scene: PackedScene

# Ensure inventory starts closed
var is_open := false

# Drag and Drop
var dragged_slot: InventoryUISlot = null
var selected_slot: InventoryUISlot = null

func _ready():
	for item in inventory.get_items():
		var slot = slot_scene.instantiate()
		grid_container.add_child(slot)

	inventory.inventory_update.connect(update_slots)
	update_slots()
	close()

# Toggle if inventory open or closed
func toggle():
	if is_open == true:
		close()
	else:
		open()


func _on_drag_start(slot_control: InventoryUISlot):
	dragged_slot = slot_control
	print("Drag started from slot: ", dragged_slot)


#TODO : make version where we can drag split stacks etc. Spawn new stack for moving? Flags for questions?
func _on_drag_end():
	var target_slot = _get_slot_under_mouse()
	if target_slot and dragged_slot != target_slot:
		_drop_slot(dragged_slot, target_slot)
	dragged_slot = null


# Get the slot under the mouse if applicable
func _get_slot_under_mouse() -> InventoryUISlot:
	var mouse_position = get_global_mouse_position()
	var slots: Array = %GridContainer.get_children()
	for slot in slots:
		var slot_rect = Rect2(slot.global_position, slot.size)
		if slot_rect.has_point(mouse_position):
			return slot
	return null


func _get_slot_index(slot: InventoryUISlot) -> int:
	var slots: Array = %GridContainer.get_children()
	for i in range(slots.size()):
		if slots[i] == slot:
			# Valid slot found
			return i
#	for i in range(grid_container.get_child_count()):
#		if grid_container.get_child(i) == slot:
#			# Valid slot found
#			return i
	# Invalid slot
	return -1


func _drop_slot(slot1: InventoryUISlot, slot2: InventoryUISlot):
	var slot1_index = _get_slot_index(slot1)
	var slot2_index = _get_slot_index(slot2)
	if slot1_index == -1 or slot2_index == -1:
		print("Invalid slots found")
		return
	else:
		if inventory.swap_items(slot1_index, slot2_index):
			print("Dropping slot items: ", slot2, " ", slot2_index)


func _select_slot(slot: InventoryUISlot):
	selected_slot = slot

func update_slots():
	var slots: Array = %GridContainer.get_children()
	for i in range(min(inventory.item_slots.size(), inventory.inventory_size)):
		slots[i].selected.connect(_select_slot)
		slots[i].drag_start.connect(_on_drag_start)
		slots[i].drag_end.connect(_on_drag_end)
		slots[i].update(inventory.item_slots[i])


func open():
	visible = true
	is_open = true


func close():
	visible = false
	is_open = false

