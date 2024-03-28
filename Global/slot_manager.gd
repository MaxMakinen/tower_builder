extends Node


enum SlotType {
	INVENTORY,
	HOTBAR,
}

# TODO : Might be useless
var _previous_slot: UIItemSlot = null

var _slot_under_mouse: UIItemSlot = null
var _slot_type: SlotType = SlotType.INVENTORY


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
