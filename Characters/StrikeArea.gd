extends Area2D

@onready var state_machine: StateMachine = $"../State_machine"
var target: Area2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_machine.take_action.connect(strike)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func strike() -> void:
	if target != null:
		target.interact()
		print("STRIKE")
	pass

func _on_area_entered(area: Area2D) -> void:
	if area.name == "HitBox":
		print("Found HitBox")
		target = area
		pass
	pass # Replace with function body.


func _on_area_exited(area: Area2D) -> void:
	print("Area left")
	if target != null:
		target = null
	pass # Replace with function body.
