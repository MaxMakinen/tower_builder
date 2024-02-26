extends CharacterBody2D

class_name PersistentState

# Varables for movement
@export var speed = 100.0
@export var accel = 10.0
var direction
var facing

# Variables for state manager
var state
#var state_machine = preload("res://State_machine/StateMachine.tscn")
var animation
var state_machine = StateMachine.new()

func _ready():
	animation = get_node("AnimatedSprite2D")
	facing = Vector2(0, 1)
#	state_machine = state_machine_scn.new()
#	change_state("Idle")

func _physics_process(delta):
	# Directions like "left" etc. need to be added to input map
	# Upper is copied from source, bottom dir is guessing what might work
	#var direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	direction = Vector2(Input.get_vector("left", "right", "up", "down"))
	if direction.x == 0 && direction.y == 0:
		pass
	else:
		facing = direction
		
#	print("Direction = " + str(direction))
#	print("Facing = " + str(facing))
	velocity.x = move_toward(velocity.x, speed * direction.x, accel)
	velocity.y = move_toward(velocity.y, speed * direction.y, accel)
#	print("velocity = " + str(velocity))
	#if velocity.length() > 0:
	#	state_machine.transition_to("Movement")
#	if velocity.x < 0:
#		state.move_left()
#	if velocity.x > 0:
#		state.move_right()
#	if velocity.y < 0:
#		state.move_up()
#	if velocity.y > 0:
#		state.move_down()

	move_and_slide()

#func change_state(new_state_name):
#	if state != null:
#		state.queue_free()
#	state = stateManager.get_state(new_state_name).new()
#	state.setup(Callable(self, "change_state"), $AnimatedSprite2D, self)
#	state.name = str(new_state_name)
#	add_child(state)
#	print("State = " + str(state))
#		
