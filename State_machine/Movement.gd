extends State


const anim := "Walk"
var dir: String

func enter(_msg := {}) -> void:
	pass
	#_check_facing()

func update(delta: float) -> void:
	_check_facing()
	owner.animation.play(anim + dir)
	if owner.direction.length() <= 0 and owner.velocity.length() <= 0:
		state_machine.transition_to("Idle")
	pass

func _check_facing() -> void:
	if owner.facing.y < 0:
		dir = "Up"
	if owner.facing.y > 0:
		dir = "Down"
	if owner.facing.x < 0:
		dir = "Left"
	if owner.facing.x > 0:
		dir = "Right"
