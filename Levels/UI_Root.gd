extends CanvasLayer

@onready var player = %Player
@onready var inventory_ui = %Inventory_UI

func _ready() -> void:
	visible = true

func _unhandled_input(event) -> void:
	if event.is_action_released("inventory"):
		inventory_ui.toggle()
