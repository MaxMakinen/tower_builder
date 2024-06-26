extends Area2D

enum OWNER_TYPE {RESOURCE, INTERACTABLE, ENEMY, NPC}
@export var owner_type : OWNER_TYPE
var is_target: bool = false : set = _set_target


signal attempt_harvest
signal attempt_interaction
signal targeted(is_target)

func _set_target(target: bool) -> void:
	is_target = target
	targeted.emit(is_target)

# Detect incoming interaction attempt and respond accordingly
func _on_area_entered(area: Area2D) -> void:
	print("Area Entry detected")
	if area.name == "StrikeArea":
		is_target = true


func _on_area_exited(_area: Area2D) -> void:
	if is_target == true:
		is_target = false
	pass # Replace with function body.

func interact() -> void:
	if owner_type == OWNER_TYPE.RESOURCE:
		attempt_harvest.emit()
	if owner_type == OWNER_TYPE.INTERACTABLE:
		print("Attempt interact")
		attempt_interaction.emit()
