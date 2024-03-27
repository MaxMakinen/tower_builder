extends CharacterBody2D

class_name PersistentState

# Variables for movement
@export var speed = 100.0
@export var acceleration = 10.0
var direction
@onready var facing = Vector2(0, 1)

# Variables for state manager
var state
@onready var animation = get_node("AnimationPlayer")
var state_machine = StateMachine.new()

# Variables for inventory
@export var inventory: Inventory
@export var _inventory_size = 16

func _ready():
	if inventory == null:
		inventory = Inventory.new(_inventory_size)
	if inventory.get_inventory_size() != _inventory_size:
		inventory.set_inventory_size(_inventory_size)


func _physics_process(_delta):
	direction = Vector2(Input.get_vector("left", "right", "up", "down"))
	if direction.x == 0 && direction.y == 0:
		pass
	else:
		facing = direction
	velocity.x = move_toward(velocity.x, speed * direction.x, acceleration)
	velocity.y = move_toward(velocity.y, speed * direction.y, acceleration)
	move_and_slide()


func add_to_inventory(item: ItemResource) -> bool:
	return inventory.insert(item)

