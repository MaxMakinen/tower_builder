extends Control

@onready var inventory: Inventory = preload("res://Inventory/player_inventory.tres")
@onready var slots: Array = $NinePatchRect/HBoxContainer.get_children()


var hotbar_size = 5
var hotbar_inventory: Array[InventorySlot]

# Called when the node enters the scene tree for the first time.
func _ready():
	# Initialize hotbar with correct size
	hotbar_inventory.resize(hotbar_size)


func add_hotbar_item(item: InventorySlot):
	for i in range(hotbar_size):
		if hotbar_inventory[i] == null:
			hotbar_inventory[i] = item
			return true
	return false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
# Get the slot under the mouse if applicable
func _get_slot_under_mouse() -> Control:
	var mouse_position = get_global_mouse_position()
	for slot in slots:
		var slot_rect = Rect2(slot.global_position, slot.size)
		if slot_rect.has_point(mouse_position):
			return slot
	return null
