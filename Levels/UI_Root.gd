extends CanvasLayer


@onready var inventory_ui: Control = %Inventory_UI
@onready var player: PersistentState = %Player
@onready var drag_preview: DragPreview = %DragPreview

@export var tooltip_scene = preload("res://UI/Tooltip/tooltip.tscn")
var tooltip : Tooltip = null
var dragging : int = 0


func _ready() -> void:
	visible = true
	for item_slot in get_tree().get_nodes_in_group("item_slot"):
		#var index = []
		#index.append(item_slot.get_index())
		item_slot.gui_input.connect(_on_ItemSlot_gui_input.bind(item_slot.get_index()))
		item_slot.mouse_entered.connect(_follow_mouse.bind(item_slot.get_index()))
		item_slot.mouse_entered.connect(show_tooltip.bind(item_slot.get_index()))
		#item_slot.mouse_exited.connect(hide_tooltip.bind(item_slot.get_index()))
		item_slot.mouse_exited.connect(hide_tooltip)



func _unhandled_input(event) -> void:
	if event.is_action_released("inventory"):
		if inventory_ui.visible and drag_preview.get_dragged_item():
			return
		inventory_ui.toggle()

func _follow_mouse(index: int) -> void:
	dragging = index	
	print("Testing mouse motion index : ", index)

# TODO : If we switch from indexes to references to individual slots. I think we can fix the dragging/swapping issue. It should also enable us to figure out inter inventory movement.
func _on_ItemSlot_gui_input(event: InputEvent, index: int) -> void:
	if event is InputEventMouseButton:
		if event.is_action_pressed("ctrl_click"):# and event.pressed:
			if inventory_ui.visible:
				_split_item(index)
				hide_tooltip()
			elif !inventory_ui.visible:
				_select_item(index)
		# Drag item while button is being held
		elif event.is_action_pressed("left_click"):
			if inventory_ui.visible:
				_drag_item(index)
				hide_tooltip()
		# Release dragged item when mouse is released
		elif event.is_action_released("left_click"):
			if inventory_ui.visible and drag_preview.get_dragged_item():
				_drag_item(dragging)
#	else:
#		dragging = index

func _select_item(index: int) -> void:
	player.inventory.set_selected(index)

func _drag_item(index: int) -> void:
	# TODO : Needs to work across inventories, not just player inventory
	var target_inventory = player.inventory
	var inventory_item = target_inventory.get_item_at(index)
	var dragged_item = drag_preview.get_dragged_item()
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
		drag_preview.change_amount(split_amount)
		target_inventory.increase_item_amount(index, -split_amount)
	# Split off new Inventory slot duplicate and adjust amounts of STUFF
	if !dragged_item:
		var item = inventory_item.duplicate()
		item.amount = split_amount
		drag_preview.set_dragged_item(item)
		target_inventory.increase_item_amount(index, -split_amount)


func show_tooltip(index: int) -> void:
	var inventory_item: ItemResource = null
	if player.inventory.item_slots[index]:
		inventory_item = player.inventory.item_slots[index].item
	if inventory_item and !drag_preview.get_dragged_item():
		tooltip = tooltip_scene.instantiate()
		add_child(tooltip)
		tooltip.display_info(inventory_item)
		tooltip.show()
	else:
		hide_tooltip()


func hide_tooltip() -> void:
	if tooltip:
		tooltip.hide()
		tooltip.queue_free()
		tooltip = null

# FOR DEBUGGING. Print contents of given inventory
func print_inv(inv: Inventory) -> void:
	print("Inventory")
	for index in inv.inventory_size:
		if inv.item_slots[index]:
			print("Index: ", index, " 	item : ", inv.item_slots[index].item.name, "  	amount : ", inv.item_slots[index].amount)
		else:
			print("Index: ", index, " 	", inv.item_slots[index])
