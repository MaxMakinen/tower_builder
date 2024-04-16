extends Control


@onready var option_button: OptionButton = %OptionButton
@onready var crafting_title: Label = $PanelContainer/VBoxContainer/HBoxContainer/PanelContainer/VBoxContainer/CraftingTitle
@onready var crafting_details: Label = $PanelContainer/VBoxContainer/HBoxContainer/PanelContainer/VBoxContainer/CraftingDetails
@onready var craft_button: Button = $PanelContainer/VBoxContainer/HBoxContainer/PanelContainer/VBoxContainer/CraftButton
@onready var requirements: Label = $PanelContainer/VBoxContainer/HBoxContainer/PanelContainer/VBoxContainer/Requirements
@onready var amount: Label = $PanelContainer/VBoxContainer/HBoxContainer/PanelContainer/VBoxContainer/Amount

const RECIPE_INGOT = preload("res://Crafting/CraftingRecipes/RecipeIngot.tres")
var target: int = 0
var output: ItemResource
var ingredients: String
var ingredient_amount: int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	option_button.add_item("Choose recipe", 1)
	option_button.add_item("ingot", 2)
	option_button.add_item("Item2", 3)
	option_button.add_item("Item3", 4)


func _on_option_button_item_selected(index: int) -> void:
	if index == 1:
		target = index
		output = RECIPE_INGOT.output
		ingredients = RECIPE_INGOT.required_flags["TYPE"][0]
		ingredient_amount = RECIPE_INGOT.required_flags["AMOUNT"]
		crafting_title.text = RECIPE_INGOT.name
		crafting_details.text = RECIPE_INGOT.description
		requirements.text = "Requirements: " + RECIPE_INGOT.required_flags["TYPE"][0]
		amount.text = "Amount: " + str(RECIPE_INGOT.required_flags["AMOUNT"])


func _on_craft_button_pressed() -> void:
	var slots: Array[InventorySlot]
	if target == 1:
		slots = Global.player_inventory.type_in_inventory(ingredients)
		if !slots.is_empty():
			if Global.player_inventory.consume(slots[0].get_item(), ingredient_amount):
				Global.player_inventory.insert(output)
			else:
				print("Not enough ingredients")
		else:
			print("No ingredients found")
	else:
		print("NO CRAEFT!")


