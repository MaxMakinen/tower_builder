extends Area2D

enum OWNER_TYPE {RESOURCE, INTERACTABLE, ENEMY, NPC}
@export var owner_type : OWNER_TYPE
var is_target: bool = false : set = _set_target


signal attempt_harvest
signal targeted(is_target)

func _set_target(target: bool) -> void:
	is_target = target
	targeted.emit(is_target)

# Detect incoming interaction attempt and respond accordingly
func _on_area_entered(area: Area2D) -> void:
	print("Area Entry detected")
	if owner_type == OWNER_TYPE.RESOURCE and area.name == "StrikeArea":
		is_target = true
		print("Resource Gathering Attack")


func _on_area_exited(area: Area2D) -> void:
	if is_target == true:
		is_target = false
	pass # Replace with function body.

func interact() -> void:
	if owner_type == OWNER_TYPE.RESOURCE:
		attempt_harvest.emit()
