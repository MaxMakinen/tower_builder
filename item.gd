extends CharacterBody2D


@onready var player = get_tree().get_first_node_in_group("player")
@onready var shadow = $Sprites/Shadow
@onready var item = $Sprites/Item
@onready var animation = $AnimationPlayer

const MAX_SPEED := 50.0
const ACCELERATION := 0.5
var speed := 0.0
var is_being_picked_up := false
var is_being_spawned := false


var frame := 0
var type_list := {
	"Stone": 12,
	"Wood": 0,
	"Ore_copper": 35,
	"Metal_copper": 46,
	"Ingot_copper": 57,
	"Coal": 4
}


func _ready():
	item.set_frame(frame)
	shadow.set_frame(frame)
	if is_being_spawned == true:
		var spawn_direction = _randomize_spawn_direction()
		var spawn_point = spawn_direction * 20
		var tween = get_tree().create_tween()
		tween.tween_property(
			self, "position", position + spawn_point, 0.25
		).set_ease(Tween.EASE_IN_OUT)
		is_being_spawned = false
		await tween.finished



func _physics_process(delta):
	if is_being_picked_up == true:
		shadow.hide()
		animation.stop()
		speed = lerp(speed, MAX_SPEED, ACCELERATION * delta)
		velocity = global_position.direction_to(player.global_position) * speed
		
	var collision = move_and_collide(velocity)
	
	if collision:
		_handle_picked_up()


func _handle_picked_up():
	queue_free()


func _on_mouse_entered():
	is_being_picked_up = true


func set_type(type: String):
	if type in type_list:
		frame = type_list[type]
	else:
		print("Item " + type + " not in type_list")


func spawn_in():
	is_being_spawned = true


func _randomize_spawn_direction() -> Vector2:
	var rng = RandomNumberGenerator.new()
	var randX = rng.randf_range(-1, 1)
	var randY = rng.randf_range(-1, 1)
	var direction = Vector2(randX, randY)
	return direction.normalized()

