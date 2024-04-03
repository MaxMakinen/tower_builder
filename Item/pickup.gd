@tool
extends Area2D

class_name Pickup

@export var item: ItemResource
@onready var item_sprite: Sprite2D = %ItemSprite

@onready var player: PersistentState = get_tree().get_first_node_in_group("player")

var spawned: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not Engine.is_editor_hint():
		item_sprite.set_texture(item.texture)
	if spawned:
		await _spawn()
	_animate()

func spawn_item(new_item: ItemResource, new_position: Vector2) -> void:
	spawned = true
	position = new_position
	item = new_item


func _animate() -> void:
	var animation_tween = create_tween().set_loops()
	animation_tween.tween_property(self, "position", position + Vector2(0, -1), 0.5).set_ease(Tween.EASE_IN_OUT)
	animation_tween.tween_interval(0.1)
	animation_tween.tween_property(self, "position", position, 0.5).set_ease(Tween.EASE_IN_OUT)
	animation_tween.tween_interval(0.2)


func _spawn() -> void:
	var tween = create_tween()
	var rng = RandomNumberGenerator.new()
	var randX = rng.randf_range(-1, 1)
	var randY = rng.randf_range(0, 1)
	var direction = Vector2(randX, randY)
	var spawn_point = position + direction.normalized() * 20
	tween.tween_property(self, "position", spawn_point, 0.3).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	tween.kill()
	position = spawn_point

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		item_sprite.set_texture(item.texture)

# Attempt to insert item into inventory. If succesful, queue_free() this node
func _on_body_entered(body: Node2D) -> void:
	if body is PersistentState:
		var error = Global.player_inventory.insert(item)
		if error == true:
			var tween = create_tween()
			tween.tween_property(self, "position", position + Vector2(0, -5), 0.1).set_ease(tween.EASE_OUT)
			tween.tween_property(self, "position", position, 0.1).set_ease(tween.EASE_IN_OUT)
			await tween.finished
			queue_free()
