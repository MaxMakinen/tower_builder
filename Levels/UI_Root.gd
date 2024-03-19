extends CanvasLayer

@onready var player = %Player
@onready var inventory_ui = %Inventory_UI

func _unhandled_input(event):
	if event.is_action_released("inventory"):
		inventory_ui.toggle()
