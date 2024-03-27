extends StaticBody2D

class_name WorldItemContainer

@onready var interaction_area: InteractionArea = $InteractionArea

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_interact():
	pass
#	effect_animation.show()
#	effect_animation.play("PlayerMined")
#	interactable = false
#	harvest_timer.start(harvest_time)
