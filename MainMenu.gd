extends Node2D

@onready var button_animation: AnimatedSprite2D = $Button/AnimatedSprite2D

func _on_button_pressed():
	button_animation.play("button_pressed")
	_go_to_game()


func _go_to_game():
	get_tree().change_scene_to_file("res://Levels/World.tscn")

func _input(event):
	if event.is_action_pressed("ui_accept"):
		_go_to_game()
