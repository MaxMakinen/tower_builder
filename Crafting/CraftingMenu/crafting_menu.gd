extends Control


@onready var option_button: OptionButton = %OptionButton
@onready var crafting_title: Label = $PanelContainer/VBoxContainer/HBoxContainer/PanelContainer/VBoxContainer/CraftingTitle
@onready var crafting_details: Label = $PanelContainer/VBoxContainer/HBoxContainer/PanelContainer/VBoxContainer/CraftingDetails
@onready var craft_button: Button = $PanelContainer/VBoxContainer/HBoxContainer/PanelContainer/VBoxContainer/CraftButton
@onready var requirements: Label = $PanelContainer/VBoxContainer/HBoxContainer/PanelContainer/VBoxContainer/Requirements
@onready var amount: Label = $PanelContainer/VBoxContainer/HBoxContainer/PanelContainer/VBoxContainer/Amount

const RECIPE_INGOT = preload("res://Crafting/CraftingRecipes/RecipeIngot.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	option_button.add_item("Choose recipe", 1)
	option_button.add_item("ingot", 2)
	option_button.add_item("Item2", 3)
	option_button.add_item("Item3", 4)


func _on_option_button_item_selected(index: int) -> void:
	print("Int sent by signal : ", index)
	if index == 1:
		print("Ingot")
		crafting_title.text = "Ingot"
		var details: String = "smelt ingot from ore"
		var reqs = RECIPE_INGOT.required_flags["TYPE"][0]
		
		requirements.text = "Requirements: " + reqs
		amount.text = "Amount: " + str(RECIPE_INGOT.required_flags["AMOUNT"])
		crafting_details.text = details 
	pass # Replace with function body.


func _on_craft_button_pressed() -> void:
	pass # Replace with function body.
