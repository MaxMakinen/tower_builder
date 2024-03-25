extends PanelContainer
class_name Tooltip

@onready var margin_container: MarginContainer = $MarginContainer
@onready var item_name: Label = %ItemName
@onready var item_description: Label = %ItemDescription


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	position = get_global_mouse_position() + Vector2.ONE * 4


func display_info(item: ItemResource) -> void:
	item_name.text = item.name
	item_description.text = item.description

