extends State

class_name WalkState

func get_input():
	if Input.is_action_just_released("left"):
		change_state.call("Idle")
		animation.play("IdleLeft")
	if Input.is_action_just_released("right"):
		change_state.call("Idle")
		animation.play("IdleRight")
	if Input.is_action_just_released("up"):
		change_state.call("Idle")
		animation.play("IdleUp")
	if Input.is_action_just_released("down"):
		change_state.call("Idle")
		animation.play("IdleDown")

func _physics_process(_delta):
	get_input()

func move_left():
	persistent_state.direction.x -= 1
	animation.play("WalkLeft")
	
func move_right():
	persistent_state.direction.x += 1
	animation.play("WalkRight")

func move_up():
	persistent_state.direction.y -= 1
	animation.play("WalkUp")

func move_down():
	persistent_state.direction.y += 1
	animation.play("WalkDown")
