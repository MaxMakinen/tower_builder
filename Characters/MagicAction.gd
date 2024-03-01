extends Node2D

var found_target := false
var target: ResourceNode

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func mine():
	if found_target == true:
		target.mining()


func finished():
	if found_target == true:
		pass
		#target.finished_mining()

func _on_area_2d_body_entered(body):
	if (body is ResourceNode):
		found_target = true
		target = body
		print("Hit a node!")
		

func _on_area_2d_body_exited(body):
	if (body is ResourceNode):
		found_target = false
		print("Lost node")

