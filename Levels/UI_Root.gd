extends CanvasLayer

@onready var pickup = preload("res://Item/pickup.tscn")

@onready var inventory_ui: Control = %Inventory_UI
@onready var player: PersistentState = %Player
@onready var drag_preview: DragPreview = %DragPreview
@onready var ui_hotbar: UIHotbar = %UIHotbar
@onready var mouse_timer: Timer = %MouseTimer
@onready var container_ui: Control = %Container_UI

@export var tooltip_scene: PackedScene = preload("res://UI/Tooltip/tooltip.tscn")
var tooltip: Tooltip = null

var target_slot: int = 0
var target_slot_container: SlotContainer = null
var previous_slot_container: SlotContainer = null
var left_mouse_pressed: bool = false

func _ready() -> void:
	mouse_timer.one_shot = true
	visible = true
	_link_slot_container(ui_hotbar)
	_link_mouse_to_containers(ui_hotbar)
	_link_mouse_to_containers(inventory_ui.get_slot_container())
	_link_mouse_to_containers(container_ui.get_slot_container())
	for cont in get_tree().get_nodes_in_group("world_item_container"):
		cont.open_container.connect(_open_container_ui)
		cont.close_container.connect(_close_container_ui)


func _open_container_ui(inventory: Inventory) -> void:
	container_ui.open(inventory)
	_open_inventory()
	_link_slot_container(container_ui.get_slot_container())


func _close_container_ui() -> void:
	inventory_ui.close()
	container_ui.close()

func _link_mouse_to_containers(slot_container: SlotContainer) -> void:
	slot_container.mouse_entered.connect(_follow_slot_container.bind(slot_container))
	slot_container.mouse_exited.connect(_follow_slot_container.bind(null))


# Link all item_slot signals from slot_container to observing functions.
func _link_slot_container(slot_container: SlotContainer) -> void:
	for item_slot in slot_container.get_children():
		item_slot.gui_input.connect(_on_ItemSlot_gui_input.bind(item_slot.get_index()))
		item_slot.mouse_entered.connect(_follow_mouse.bind(item_slot.get_index()))
		item_slot.mouse_exited.connect(_follow_mouse.bind(-1))
		item_slot.mouse_entered.connect(_show_tooltip.bind(item_slot.get_index()))
		item_slot.mouse_exited.connect(_hide_tooltip)

# Follow mouse to get slot_container currently under the mouse
func _follow_slot_container(container: SlotContainer) -> void:
	target_slot_container = container
	if target_slot_container:
		print("container name : ", target_slot_container.name)

func _follow_mouse(index: int) -> void:
	target_slot = index
	print("target slot = ", target_slot)

func _unhandled_input(event) -> void:
	if event.is_action_released("inventory"):
		_show_inventory()

func _show_inventory() -> void:
		if inventory_ui.visible and drag_preview.get_dragged_item() != null:
			return
#		_open_inventory()
		inventory_ui.toggle()
		if inventory_ui.visible:
			_link_slot_container(inventory_ui.get_slot_container())
		else:
			container_ui.close()

func _open_inventory() -> void:
	if inventory_ui.visible or drag_preview.get_dragged_item() != null:
		return
	inventory_ui.open()
	_link_slot_container(inventory_ui.get_slot_container())


func _on_ItemSlot_gui_input(event: InputEvent, index: int) -> void:
	if event is InputEventMouseButton:
		if event.is_action_pressed("right_click"):
			if inventory_ui.visible:
				_split_item(index)
				_hide_tooltip()
			elif !inventory_ui.visible:
				_select_item(index)
		# Drag item while button is being held
		elif event.is_action_pressed("left_click"):
			if inventory_ui.visible:
				previous_slot_container = target_slot_container
				get_tree().create_timer(0.2).timeout.connect(_start_drag.bind(index))
				if !drag_preview.get_dragged_item():
					_select_item(index)
		# Release dragged item when mouse is released
		elif event.is_action_released("left_click"):
			if inventory_ui.visible and drag_preview.get_dragged_item():
				if target_slot >= 0:
					_drag_item(target_slot, target_slot_container.get_inventory())


func _start_drag(index: int) -> void:
	if Input.is_action_pressed("left_click"):
		_drag_item(index, previous_slot_container.get_inventory())
		_hide_tooltip()


func _select_item(index: int) -> void:
	target_slot_container._set_selected(index)


func _drag_item(index: int, target_inventory: Inventory) -> void:
	var inventory_item = target_inventory.get_item_at(index)
	var dragged_item = drag_preview.get_dragged_item()
	# Pick item
	if target_inventory.get_item_at(index) and !dragged_item:
		drag_preview.set_dragged_item(target_inventory.remove_item(index))
	# Drop item
	if !inventory_item and dragged_item:
		drag_preview.set_dragged_item(target_inventory.set_item(index, dragged_item))
	if inventory_item and dragged_item:
		# Stack item
		if inventory_item.item == dragged_item.item and dragged_item.item != null:
			target_inventory.change_item_amount(index, dragged_item.get_amount())
			drag_preview.set_dragged_item(null)
		# Swap items
		else:
			drag_preview.set_dragged_item(target_inventory.set_item(index, dragged_item))


func _split_item(index: int) -> void:
	var target_inventory: Inventory = target_slot_container.get_inventory()
	var inventory_item: InventorySlot = target_inventory.get_item_at(index)
	var dragged_item: InventorySlot = drag_preview.get_dragged_item()
	var split_amount: int = 0
	# If no item in slot or item not stackable, then fail split attempt
	if inventory_item and !inventory_item.can_split():
		return
	# Find size of stack that will be split off target item
	if inventory_item and inventory_item.get_item():
		split_amount = ceil(inventory_item.get_amount() / 2.0)
		if dragged_item and inventory_item.get_item() == dragged_item.get_item():
			if split_amount > 0:
				drag_preview.change_amount(split_amount)
				target_inventory.change_item_amount(index, -split_amount)
			# Split off new Inventory slot duplicate and adjust amounts left
		elif !dragged_item:
			var item = inventory_item.duplicate()
			item.set_amount(split_amount)
			drag_preview.set_dragged_item(item)
			target_inventory.change_item_amount(index, -split_amount)
	# If slot below mouse is empty, split stack in dragged_item into it
	elif dragged_item and (!inventory_item or !inventory_item.get_item()):
		split_amount = ceil(dragged_item.get_amount() / 2.0)
		if dragged_item and (!inventory_item or !inventory_item.get_item()):
			if split_amount > 0:
				drag_preview.change_amount(-split_amount)
				target_inventory.insert_at(dragged_item.get_item(), index, split_amount)


func _show_tooltip(index: int) -> void:
	var inventory_item: ItemResource = null
	if target_slot_container.get_item_at(index):
		inventory_item = target_slot_container.get_item_at(index).get_item()
	if inventory_item and !drag_preview.get_dragged_item():
		tooltip = tooltip_scene.instantiate()
		add_child(tooltip)
		tooltip.display_info(inventory_item)
		tooltip.show()
	else:
		_hide_tooltip()


func _hide_tooltip() -> void:
	if tooltip:
		tooltip.hide()
		tooltip.queue_free()
		tooltip = null
