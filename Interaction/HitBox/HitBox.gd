extends Area2D

enum OWNER_TYPE {RESOURCE, INTERACTABLE, ENEMY, NPC}
@export var owner_type : OWNER_TYPE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	print("Entry detected")
	if owner_type == OWNER_TYPE.RESOURCE and body.name == "player":
		print("Resource Gathering Attack")
		pass
	pass # Replace with function body.


func _on_area_entered(area: Area2D) -> void:
	print("Area Entry detected")
	if owner_type == OWNER_TYPE.RESOURCE and area.name == "player":
		print("Resource Gathering Attack")
		pass
	pass # Replace with function body.
