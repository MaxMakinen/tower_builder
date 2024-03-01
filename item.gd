extends CharacterBody2D


@onready var player = get_tree().get_first_node_in_group("player")
@onready var shadow = $Sprites/Shadow
@onready var item = $Sprites/Item
@onready var animation = $AnimationPlayer
var frame = 46
var type_list = {
	"Stone": 12,
	"Wood": 0,
	"Ore_copper": 35,
	"Metal_copper": 46,
	"Ingot_copper": 57,
	"Coal": 4
}

const MAX_SPEED := 50.0
const ACCELERATION := 0.5

var speed := 0.0
var is_being_picked_up := false

func _ready():
	item.set_frame(frame)
	shadow.set_frame(frame)


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
	frame = type_list[type]
