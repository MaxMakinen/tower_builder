extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	_go_to_game()


func _go_to_game():
	get_tree().change_scene_to_file("res://Levels/World.tscn")

func _input(event):
	if event.is_action_pressed("ui_accept"):
		_go_to_game()
