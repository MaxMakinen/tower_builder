extends CharacterBody2D

class_name PersistentState

# Variables for movement
@export var speed = 100.0
@export var acceleration = 10.0
var direction
@onready var facing = Vector2(0, 1)

# Variables for state manager
var state
#var state_machine = preload("res://State_machine/StateMachine.tscn")
@onready var animation = get_node("AnimationPlayer")
#@onready var action_animation = get_node("MagicAction/MagicEffect")
#@onready var magic_action = get_node("MagicAction")
var state_machine = StateMachine.new()

# Variables for inventory
@export var inventory: Inventory

func _ready():
	#animation = get_node("AnimatedSprite2D")
#	state_machine = state_machine_scn.new()
#	change_state("Idle")
	pass

func _physics_process(_delta):
	direction = Vector2(Input.get_vector("left", "right", "up", "down"))
	if direction.x == 0 && direction.y == 0:
		pass
	else:
		facing = direction
	velocity.x = move_toward(velocity.x, speed * direction.x, acceleration)
	velocity.y = move_toward(velocity.y, speed * direction.y, acceleration)
	move_and_slide()


func add_to_inventory(item: ItemResource):
	inventory.insert(item)

