@tool
extends Area2D

@export var item: ItemResource
@onready var item_sprite: Sprite2D = $ItemSprite

@onready var player = get_tree().get_first_node_in_group("player")


func _init(new_item: ItemResource) -> void:
	item = new_item

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	item_sprite.texture = item.texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if !item_sprite.texture:
		item_sprite.texture = item.texture



func _on_body_entered(_body: Node2D) -> void:
	print("Banana encounter!")
	var error = player.inventory.insert(item)
	if error == true:
		print("Tasty fruit salad")
		queue_free()

