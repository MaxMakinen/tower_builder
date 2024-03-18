extends Resource

class_name Hotbar

signal hotbar_update

@export var inventory: Inventory
# TODO : add spells to correct class once it's created/implemented
#@export var spells: Inventory
@export var hotbar_slots: Array[InventorySlot]
@export var hotbar_size: int = 8
# TODO : In case we implement multiple hotbars
#@export var hotbars: Array
#@export var hotbars_amount: int = 2

func _ready():
	_resize_hotbar()

func set_hotbar_size(new_size: int):
	hotbar_size = new_size
	_resize_hotbar()

# Resize inventory size and connect every slots slot_update signal to the _update function
func _resize_hotbar():
	hotbar_slots.resize(hotbar_size)
	for i in range(hotbar_size):
		#TODO : Does this do anything?
		hotbar_slots[i].slot_update.connect(_update)

# Go through inventory and remove items with amount < 1
func _update():
	for i in range(hotbar_size):
		if hotbar_slots[i].amount < 1:
			_erase(hotbar_slots[i])

# Remove target item from hotbar array
func _erase(item: InventorySlot):
	for i in range(hotbar_size):
		if hotbar_slots[i] == item:
			hotbar_slots[i] = null
			return

# Swap item_slots in inventory array based on their indices
func swap_items(index1, index2):
	if index1 < 0 or index1 > hotbar_size or index2 < 0 or index2 > hotbar_size:
		return false
	# TODO remove print statements
	print("index1: ", index1 ," slot1: ", hotbar_slots[index1])
	print("index2: ", index2, " slot2: ", hotbar_slots[index2])
	var temp_slot = hotbar_slots[index1]
	hotbar_slots[index1] = hotbar_slots[index2]
	hotbar_slots[index2] = temp_slot
	hotbar_update.emit()
	return true

# TODO : Use usable item in slot, consume consumable etc.
func activate(item: InventorySlot):
	pass

# TODO : Insert target into array at index, else return false
func insert_at(item: InventorySlot, index: int):
	pass

# TODO : Insert item at first empty slot in hotbar array, else return false
func insert(item: InventorySlot):
	pass

# TODO : Switch between hotbars in case we implement multiple hotbars
func change_hotbar():
	pass

