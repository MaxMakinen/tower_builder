extends State

class_name IdleState


func _process(delta):
	if persistent_state.facing.x == -1 && persistent_state.velocity.x == 0:
		animation.play("IdleLeft")
	
func move_left():
	change_state.call("Walk")

func move_right():
	change_state.call("Walk")

func move_up():
	change_state.call("Walk")

func move_down():
	change_state.call("Walk")
