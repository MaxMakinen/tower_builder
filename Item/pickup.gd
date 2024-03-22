@tool
extends Area2D

@export var item: ItemResource
@onready var item_sprite: Sprite2D = $ItemSprite

@onready var player: PersistentState = get_tree().get_first_node_in_group("player")

#func _init(new_item: ItemResource) -> void:
#	if not Engine.is_editor_hint():
#		item = new_item


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not Engine.is_editor_hint():
		item_sprite.set_texture(item.texture)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		item_sprite.set_texture(item.texture)

#	if false:
#		var tween = get_tree().create_tween()
#		tween.tween_property(
#			self, "position", position + Vector2(0, -3), 0.25
#		).set_ease(Tween.EASE_IN_OUT)

func _on_body_entered(_body: Node2D) -> void:
	if not Engine.is_editor_hint():
		print("Banana encounter!")
		var error = player.add_to_inventory(item)
		if error == true:
			print("Tasty fruit salad")
			queue_free()
