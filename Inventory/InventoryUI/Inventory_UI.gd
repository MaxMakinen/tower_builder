extends Control

@export var inventory: Inventory
@export var slot_scene: PackedScene

@onready var description = %Description

# Ensure inventory starts closed
var is_open := false

func _ready():
	description.text = ""
	close()

# Toggle if inventory open or closed
func toggle():
	if is_open == true:
		close()
	else:
		open()


func open():
	visible = true
	is_open = true


func close():
	visible = false
	is_open = false


func _on_button_pressed():
	print("Inventory contents : ")
	for item in inventory.item_slots:
		if item:
			if item.item:
				print("name : ", item.item.name)
			print("item : ", item.item, " amount : ", item.amount)

