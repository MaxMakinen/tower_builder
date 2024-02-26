extends Node2D

class_name State

# Variables for state information
var change_state
var animation
var persistent_state
#var velocity = 0

func _process(_delta):
	#persistent_state.move_and_slide(persistent_state.velocity, Vector2.UP)
	#persistent_state.move_and_slide()
	pass

func setup(new_change_state, new_animation, new_persistent_state):
	self.change_state = new_change_state
	self.animation = new_animation
	self.persistent_state = new_persistent_state
	
