extends Node


enum SlotType {
	INVENTORY,
	HOTBAR,
}


var _slot_under_mouse: UIItemSlot = null
var _slot_type: SlotType = SlotType.INVENTORY

func set_slot_under_mouse(slot: UIItemSlot) -> void:
	_slot_under_mouse = slot

func get_slot_under_mouse() -> UIItemSlot:
	return _slot_under_mouse

func get_type_under_mouse() -> SlotType:
	return _slot_under_mouse.get_type()

