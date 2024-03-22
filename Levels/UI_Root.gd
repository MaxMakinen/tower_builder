extends CanvasLayer


@onready var inventory_ui: Control = %Inventory_UI
@onready var player: PersistentState = %Player
@onready var drag_preview: DragPreview = %DragPreview


func _ready() -> void:
	visible = true
	for item_slot in get_tree().get_nodes_in_group("item_slot"):
		var index = []
		index.append(item_slot.get_index())
		item_slot.gui_input.connect(_on_ItemSlot_gui_input.bind(item_slot.get_index()))


func _unhandled_input(event) -> void:
	if event.is_action_released("inventory"):
		if inventory_ui.visible and drag_preview.dragged_item:
			return
		inventory_ui.toggle()


func _on_ItemSlot_gui_input(event: InputEvent, index: int) -> void:
	if event is InputEventMouseButton:
		if event.is_action_pressed("ctrl_click"):# and event.pressed:
			if inventory_ui.visible:
				_split_item(index)
			elif !inventory_ui.visible:
				_select_item(index)
		elif event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if inventory_ui.visible:
				_drag_item(index)

func _select_item(index: int) -> void:
	player.inventory.set_selected(index)

func _drag_item(index: int) -> void:
	# TODO : Needs to work across inventories, not just player inventory
	var target_inventory = player.inventory
	var inventory_item = target_inventory.get_item_at(index)
	var dragged_item = drag_preview.dragged_item
	# Pick item
	if inventory_item and !dragged_item:
		drag_preview.set_dragged_item(target_inventory.remove_item(index))
	# Drop item
	elif !inventory_item and dragged_item:
		drag_preview.set_dragged_item(target_inventory.set_item(index, dragged_item))
	elif inventory_item and dragged_item:
		# Stack item
		if inventory_item.item == dragged_item.item:
			target_inventory.increase_item_amount(index, dragged_item.amount)
			drag_preview.set_dragged_item(null)
		# Swap items
		else:
			drag_preview.set_dragged_item(target_inventory.set_item(index, dragged_item))

func _split_item(index: int) -> void:
	# TODO : Needs to work across inventories, not just player inventory
	var target_inventory = player.inventory
	var inventory_item = target_inventory.get_item_at(index)
	var dragged_item = drag_preview.dragged_item
	# If no item in slot or item not stackable, then fail split attempt
	if !inventory_item or !inventory_item.is_stackable():
		return
	# Find size of stack that will be split off target item
	var split_amount: int = ceil(inventory_item.amount / 2)
	if dragged_item and inventory_item.item == dragged_item.item:
		print("Dragged item\nsplit amount : ", split_amount)
		drag_preview.change_amount(split_amount)
		target_inventory.increase_item_amount(index, -split_amount)
	# Split off new Inventory slot duplicate and adjust amounts of STUFF
	if !dragged_item:
		print("No dragged item\nSplit amount : ", split_amount)
		var item = inventory_item.duplicate()
		item.amount = split_amount
		drag_preview.set_dragged_item(item)
		target_inventory.increase_item_amount(index, -split_amount)


func print_inv() -> void:
	var inv = player.inventory
	print("Inventory")
	for index in inv.inventory_size:
		if inv.item_slots[index]:
			print("Index: ", index, " 	item : ", inv.item_slots[index].item.name, "  	amount : ", inv.item_slots[index].amount)
		else:
			print("Index: ", index, " 	", inv.item_slots[index])
