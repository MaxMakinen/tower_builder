extends State


const anim := "Action"
var dir: String
var event

func enter(_msg := {}) -> void:
	#owner.speed = 0
	#owner.velocity = Vector2.ZERO
	#owner.direction = Vector2.ZERO
	_check_facing()
	owner.animation.play(anim + dir)
	
	#owner.action_animation.play("Action")


func exit() -> void:
	#owner.action_animation.play("Idle")
	pass


func update(_delta: float) -> void:
	pass
	#owner.magic_action.mine()

#	if owner.action_animation.is_playing() == true or owner.animation.is_playing() == true:
#		owner.velocity = Vector2.ZERO
#		owner.direction = Vector2.ZERO
#		owner.animation.play(anim + dir)
#		owner.speed = 0
#	else:
#		owner.speed = 100
##		owner.action_animation.play("Idle")
##		state_machine.transition_to("Idle")
#	if owner.direction.length() > 0:# and owner.action_animation.is_playing() == false:
#		owner.direction = Vector2.ZERO
#		#state_machine.transition_to("Movement")

func handle_input(_event: InputEvent) -> void:
	state_machine.transition_to("Idle")
#	if _event.is_action_released("action"):
#		owner.speed = 100
#		owner.magic_action.finished()
#		state_machine.transition_to("Idle")
#	if owner.action_animation.is_playing() == false:
#		if _event.is_action_released("action"):
#			state_machine.transition_to("Idle")

func _check_facing() -> void:
	if owner.facing.y < 0:
		dir = "Up"
	if owner.facing.y > 0:
		dir = "Down"
	if owner.facing.x < 0:
		dir = "Left"
	if owner.facing.x > 0:
		dir = "Right"
