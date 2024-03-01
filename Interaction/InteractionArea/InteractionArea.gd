extends Area2D
class_name InteractionArea


@export var action_name: String = "Interact"
@onready var player = get_tree().get_first_node_in_group("player")


var interact: Callable = func ():
	pass


func _on_body_entered(body):
	if body == player:
		InteractionManager.register_area(self)


func _on_body_exited(body):
	if body == player:
		InteractionManager.unregister_area(self)

