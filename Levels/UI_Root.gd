extends CanvasLayer


@onready var inventory_ui: Control = %Inventory_UI
@onready var player: PersistentState = %Player
@onready var drag_preview: Control = $DragPreview


func _ready() -> void:
	visible = true
	for item_slot in get_tree().get_nodes_in_group("item_slot"):
		var index = item_slot.get_index()
		item_slot.gui_input.connect(_on_ItemSlot_gui_input, index)


func _unhandled_input(event) -> void:
	if event.is_action_released("inventory"):
		if inventory_ui.visible and drag_preview.dragged_item: return
		inventory_ui.toggle()


func _on_ItemSlot_gui_input(event: InputEvent, index: Array[int]) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if inventory_ui.visible:
				drag_item(index[0])


func drag_item(index: int) -> void:
	var inventory_item = player.inventory.get_item_at(index)
	var dragged_item = drag_preview.dragged_item
	# Pick item
	if inventory_item and !dragged_item:
		drag_preview.set_dragged_item(player.inventory.remove_item(index))
	# Drop item
	elif !inventory_item and dragged_item:
		drag_preview.set_dragged_item(player.inventory.set_item(index, dragged_item))
	# Swap items
	elif inventory_item and dragged_item:
		drag_preview.set_dragged_item(player.inventory.set_item(index, dragged_item))

