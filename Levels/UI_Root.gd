extends CanvasLayer


@onready var inventory_ui: Control = %Inventory_UI
@onready var player: PersistentState = %Player
@onready var drag_preview: DragPreview = %DragPreview
@onready var ui_hotbar: UIHotbar = %UIHotbar
@onready var mouse_timer: Timer = %MouseTimer

@export var tooltip_scene: PackedScene = preload("res://UI/Tooltip/tooltip.tscn")
var tooltip: Tooltip = null

var target_slot: int = 0
var target_slot_container: SlotContainer = null
var left_mouse_pressed: bool = false

func _ready() -> void:
	mouse_timer.one_shot = true
	visible = true
	_link_slot_container(ui_hotbar)
	_link_slot_container(inventory_ui.get_slot_container())

func _link_slot_container(slot_container: SlotContainer) -> void:
	slot_container.mouse_entered.connect(_follow_slot_container.bind(slot_container))
	slot_container.mouse_exited.connect(_follow_slot_container.bind(null))
	for item_slot in slot_container.get_children():
		item_slot.gui_input.connect(_on_ItemSlot_gui_input.bind(item_slot.get_index()))
		item_slot.mouse_entered.connect(_follow_mouse.bind(item_slot.get_index()))
		item_slot.mouse_exited.connect(_follow_mouse.bind(-1))
		item_slot.mouse_entered.connect(_show_tooltip.bind(item_slot.get_index()))
		item_slot.mouse_exited.connect(_hide_tooltip)

func _follow_slot_container(container: SlotContainer) -> void:
	target_slot_container = container
	if container:
		print("Entering Container : ", container.name)
	else:
		print("Leaving Container")

func _unhandled_input(event) -> void:
	if event.is_action_released("inventory"):
		if inventory_ui.visible and drag_preview.get_dragged_item() != null:
			return
		inventory_ui.toggle()
	if event is InputEventMouseButton:
		if event.is_action_pressed("left_click"):
			mouse_timer.start(0.2)


func _follow_mouse(index: int) -> void:
	target_slot = index
	print("Target slot : ", target_slot)


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
				_drag_item(index)
				_hide_tooltip()
		# Release dragged item when mouse is released
		elif mouse_timer.is_stopped() and event.is_action_released("left_click"):
			if inventory_ui.visible and drag_preview.get_dragged_item():
				if target_slot >= 0:
					_drag_item(target_slot)


func _select_item(index: int) -> void:
	player.inventory.set_selected(index)

func _drag_item(index: int) -> void:
	var target_inventory = target_slot_container.get_inventory()
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
		if inventory_item.item == dragged_item.item and dragged_item.item != null:
			target_inventory.increase_item_amount(index, dragged_item.amount)
			drag_preview.set_dragged_item(null)
		# Swap items
		else:
			drag_preview.set_dragged_item(target_inventory.set_item(index, dragged_item))


func _split_item(index: int) -> void:
	var target_inventory = target_slot_container.get_inventory()
	var inventory_item = target_inventory.get_item_at(index)
	var dragged_item = drag_preview.get_dragged_item()
	var split_amount: int = 0
	# If no item in slot or item not stackable, then fail split attempt
	if inventory_item and (!inventory_item.is_stackable() or !inventory_item.get_item()):
		return
	# Find size of stack that will be split off target item
	if inventory_item and inventory_item.get_item():
		split_amount = ceil(inventory_item.get_amount() / 2)
		if dragged_item and inventory_item.get_item() == dragged_item.get_item():
			if split_amount > 0:
				drag_preview.change_amount(split_amount)
				target_inventory.increase_item_amount(index, -split_amount)
			# Split off new Inventory slot duplicate and adjust amounts left
		elif !dragged_item:
			var item = inventory_item.duplicate()
			item.amount = split_amount
			drag_preview.set_dragged_item(item)
			target_inventory.increase_item_amount(index, -split_amount)

	elif dragged_item and (!inventory_item or !inventory_item.get_item()):
		split_amount = ceil(dragged_item.get_amount() / 2)
		if dragged_item and (!inventory_item or !inventory_item.get_item()):
			if split_amount > 0:
				drag_preview.change_amount(-split_amount)
				target_inventory.insert_at(dragged_item.get_item(), index, split_amount)


func _show_tooltip(index: int) -> void:
	var inventory_item: ItemResource = null
	if player.inventory.item_slots[index]:
		inventory_item = player.inventory.item_slots[index].item
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
