extends State


const anim := "Action"
var dir: String

func enter(_msg := {}) -> void:
	pass
	#_check_facing()

func update(delta: float) -> void:
	_check_facing()
	owner.animation.play(anim + dir)
	if owner.Input.get_pressed:
		pass
		
	if owner.direction.length() > 0:
		state_machine.transition_to("Idle")

func _check_facing() -> void:
	if owner.facing.y < 0:
		dir = "Up"
	if owner.facing.y > 0:
		dir = "Down"
	if owner.facing.x < 0:
		dir = "Left"
	if owner.facing.x > 0:
		dir = "Right"
