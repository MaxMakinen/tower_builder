extends Resource

class_name Inventory


@export var inventory_size: int = 16
@export var item_slots: Array[InventorySlot]
signal inventory_update(indices: Array[int])
signal selected_changed(selected: int)


# TODO : Should we care? Can it be exported to the UI?
# Keep track of selected slot
var selected: int = -1

# PRIVATE FUNCTIONS
func _init(size: int = inventory_size) -> void:
	inventory_size = size
	item_slots.resize(inventory_size)
	for index in range(inventory_size):
		if item_slots[index] == null:
			item_slots[index] = InventorySlot.new()

func _ready():
	if item_slots.size() != inventory_size:
		item_slots.resize(inventory_size)
	for index in range(inventory_size):
		if item_slots[index] == null:
			item_slots[index] = InventorySlot.new()
		if item_slots[index] != null:
			item_slots[index].slot_empty.connect(remove_item.bind(index))


# TODO : This feels dumb. Can it be better?	  Improved 27/03/24
func refresh()-> void:
	for index in range(inventory_size):
		if item_slots[index] != null and item_slots[index].get_amount() <= 0:
			remove_item(index)
		if item_slots[index] != null and !item_slots[index].is_connected("slot_empty", remove_item):
			pass
		#	item_slots[index].slot_empty.connect(remove_item.bind(index))
		if item_slots[index] == null:
			item_slots[index] = InventorySlot.new()


# Send signals
func _signal_change(indices: Array[int]) -> void:
	inventory_update.emit(indices)
	if selected in indices:
		selected_changed.emit(selected)

# PUBLIC FUNCTIONS
# Return entire array of item_slots
func get_items() -> Array[InventorySlot]:
	return item_slots

# Return item at index from item_slots array
func get_item_at(index: int) -> InventorySlot:
	return item_slots[index]

# Set new inventory size and then resize inventory slot array
func set_inventory_size(new_size: int) -> void:
	inventory_size = new_size
	item_slots.resize(inventory_size)

# Return inventory size as int
func get_inventory_size() -> int:
	return inventory_size

# Insert item stack into array at index
func set_item(index: int, item: InventorySlot):
	var previous_item = item_slots[index]
	item_slots[index] = item.duplicate()
	#item_slots[index].slot_empty.connect(remove_item.bind(index))
	_signal_change([index])
	return previous_item

# Remove item stack from array at index
func remove_item(index: int) -> InventorySlot:
	var previous_item = item_slots[index].duplicate()
	item_slots[index].empty()
	_signal_change([index])
	return previous_item

# TODO : This should probably be completely removed
# Change stack size of inventory slot and remove item if stack size falls below 1
func change_item_amount(index: int, amount: int) -> void:
	item_slots[index].change_amount(amount)
	_signal_change([index])

# Attempt to insert new item into inventory. Otherwise return false
func insert(new_item: ItemResource, amount: int = 1) -> bool:
	var empty_slot_index: int = -1
	for index in range(inventory_size):
		# Look for first empty InventorySlot and remember its index
		if empty_slot_index < 0:
			if !item_slots[index] or !item_slots[index].get_item():
				empty_slot_index = index
		# Look for existing InventorySlot with resource and increase amount if possible, then return to break loop
		if item_slots[index] and item_slots[index].get_item() == new_item and item_slots[index].get_amount() < item_slots[index].get_max_stack_size():
			change_item_amount(index, amount)
			return true
	# No existing resource of type new_item found so add new item at index of first empty InventorySlot
	if empty_slot_index > -1:
		var new_slot = InventorySlot.new(new_item, amount)
		set_item(empty_slot_index, new_slot)
		return true
	# Insert has failed, inform caller
	return false

# Insert item into empty slot in inventory at index. Otherwise return false
func insert_at(new_item: ItemResource, index: int , amount: int = 1) -> bool:
	if item_slots[index] == null or item_slots[index].is_empty():
		var new_slot = InventorySlot.new(new_item, amount)
		set_item(index, new_slot)
		print("new item : ", new_item, " amount : ", amount, " at index : ", index)
		return true
	print("Insert of ", new_item.name, " failed at index : ", index, ", Slooot : ", item_slots[index])
	return false

func attempt_insert_at(new_item: ItemResource, index: int , amount: int = 1) -> bool:
	if item_slots[index] == null or item_slots[index].is_empty():
		if insert_at(new_item, index, amount) or insert(new_item, amount):
			return true
	return false

# Get total amount of all stacks of same item
func get_total_amount(target: ItemResource) -> int:
	var total: int = 0
	for item in item_slots:
		if !item.is_empty() and item.get_item() == target:
			total += item.get_amount()
	return total

# Get list of unique ItemResources in inventory
func get_all_types() -> Array[ItemResource]:
	var types: Array[ItemResource] = []
	for item in item_slots:
		if item.item not in types:
			types.append(item)
	return types


func set_selected(new_selected: int) -> void:
	var last_selected = selected
	selected = new_selected
	_signal_change([selected, last_selected])

func get_selected() -> InventorySlot:
	return item_slots[selected]


func sort() -> void:
	item_slots.sort_custom(mysort)
	var temp: Array[int] = []
	temp.assign(range(inventory_size))
	_signal_change(temp)


func mysort(a: InventorySlot, b: InventorySlot):
	if !a.is_empty() and !b.is_empty():
		if a.get_item_name() < b.get_item_name():
			return true
	elif a.is_empty():
		return false
	return false


func in_inventory(item: ItemResource) -> InventorySlot:
	for slot in item_slots:
		if slot.get_item() == item and !slot.is_empty():
			return slot
	return null


func type_in_inventory(type: String) -> Array[InventorySlot]:
	var slots : Array[InventorySlot] = []
	for slot in item_slots:
		if !slot.is_empty() and slot.get_item().type == type:
			slots.append(slot)
	return slots


func consume(item: ItemResource, amount: int) -> bool:
#	print("Totes : ", get_total_amount(item))
#	print("Amount : ", amount)
	if get_total_amount(item) >= amount:
		var slots : Array[InventorySlot] = []
		amount = -amount
		for slot in item_slots:
			if !slot.is_empty() and slot.get_item() == item:
				slots.append(slot)
		for slot in slots:
			var diff = slot.change_amount(amount)
#			print("Diff : ", diff, " amount : ", amount)
			if diff < 0:
				amount = diff
			elif diff >= 0:
				return true
	return false

