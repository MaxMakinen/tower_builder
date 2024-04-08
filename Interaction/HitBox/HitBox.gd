extends Area2D

enum OWNER_TYPE {RESOURCE, INTERACTABLE, ENEMY, NPC}
@export var owner_type : OWNER_TYPE

signal attempt_harvest

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# Detect incoming interaction attempt and respond accordingly
func _on_area_entered(area: Area2D) -> void:
	print("Area Entry detected")
	print("area name : ", area.name)
	if owner_type == OWNER_TYPE.RESOURCE and area.name == "StrikeArea":
		print("Resource Gathering Attack")
		attempt_harvest.emit()
		pass
	pass # Replace with function body.
