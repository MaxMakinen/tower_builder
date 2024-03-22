extends ColorRect

class_name Tooltip

@onready var margin_container: MarginContainer = $MarginContainer
@onready var item_name: Label = $MarginContainer/ItemName

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	position = get_global_mouse_position() + Vector2(4, 4)


func display_info(item: ItemResource) -> void:
	item_name.text = item.description

