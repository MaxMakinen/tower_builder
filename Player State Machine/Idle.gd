extends State


const anim := "Idle"
var dir: String

func enter(_msg := {}) -> void:
	pass
	#_check_facing()

func update(delta: float) -> void:
	_check_facing()
	owner.animation.play(anim + dir + "New")
	if owner.direction.length() > 0:
		state_machine.transition_to("Movement")

func handle_input(_event: InputEvent) -> void:
	if _event.is_action_pressed("action"):
		state_machine.transition_to("Action")

func _check_facing() -> void:
	if owner.facing.y < 0:
		dir = "Up"
	if owner.facing.y > 0:
		dir = "Down"
	if owner.facing.x < 0:
		dir = "Left"
	if owner.facing.x > 0:
		dir = "Right"
