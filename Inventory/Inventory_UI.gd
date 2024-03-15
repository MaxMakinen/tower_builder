extends Control

@onready var inventory: Inventory = preload("res://Inventory/player_inventory.tres")
@onready var grid_container = $Inventory_BG/GridContainer
@onready var slots: Array = $Inventory_BG/GridContainer.get_children()
#@onready var player = get_tree().get_first_node_in_group("player")

# Ensure inventory starts closed
var is_open := false

# Drag and Drop
var dragged_slot: Control = null

func _ready():
	inventory.inventory_update.connect(update_slots)
	update_slots()
	close()

func _process(delta):
	if Input.is_action_just_pressed("inventory"):
		if is_open:
			#player.open_hotbar()
			close()
		else:
			#player.close_hotbar()
			open()

func _on_drag_start(slot_control: Control):
	dragged_slot = slot_control
	print("Drag started from slot: ", dragged_slot)


#TODO : make version where we can drag split stacks etc. Spawn new stack for moving? Flags for questions?
func _on_drag_end():
	var target_slot = _get_slot_under_mouse()
	if target_slot and dragged_slot != target_slot:
		_drop_slot(dragged_slot, target_slot)
	dragged_slot = null


# Get the slot under the mouse if applicable
func _get_slot_under_mouse() -> Control:
	var mouse_position = get_global_mouse_position()
	for slot in slots:
		var slot_rect = Rect2(slot.global_position, slot.size)
		if slot_rect.has_point(mouse_position):
			return slot
	return null


func _get_slot_index(slot: Control) -> int:
	for i in range(grid_container.get_child_count()):
		if grid_container.get_child(i) == slot:
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
			print("Dropping slot items: ", slot1, slot2_index)


func update_slots():
	for i in range(min(inventory.item_slots.size(), slots.size())):
		slots[i].drag_start.connect(_on_drag_start)
		slots[i].drag_end.connect(_on_drag_end)
		slots[i].update(inventory.item_slots[i])


func open():
	visible = true
	is_open = true


func close():
	visible = false
	is_open = false

