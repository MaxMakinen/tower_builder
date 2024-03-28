extends Node

# Identifires for different slot types
enum SlotType {
	INVENTORY,
	HOTBAR,
}

# varable for kleeping track of what slot is under the mouse
var _slot_under_mouse: UIItemSlot = null

# Setter for _slot_under_mouse varable
func set_slot_under_mouse(slot: UIItemSlot) -> void:
	_slot_under_mouse = slot

# Getter for _slot_under_mouse varable
func get_slot_under_mouse() -> UIItemSlot:
	return _slot_under_mouse

# Returns slot type of slot under mouse
func get_type_under_mouse() -> SlotType:
	return _slot_under_mouse.get_type()

