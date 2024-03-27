extends StaticBody2D

class_name WorldItemContainer


# EXPORT VARIABLES
@export var inventory: Inventory
@export var container_size: int = 1

# ONREADY VARIABLES
@onready var interaction_area: InteractionArea = $InteractionArea

# PRIVATE VARIABLES
var _interactable: bool = true
# SIGNALS
signal open_container(inventory)

# PRIVATE FUNCTIONS

# When constructing new container, adjust container size according to input or use default value of 1
func _init(size: int = container_size) -> void:
	container_size = size
	if inventory == null:
		inventory = Inventory.new(container_size)
	else:
		inventory.set_inventory_size(container_size)

# Called when the node enters the scene tree for the first time. connect to interaction area signal
func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
#	if inventory == null:
#		inventory = Inventory.new(container_size)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Called when player interacts with interaction area
func _on_interact():
	if _interactable:
		open_container.emit(inventory)
		_interactable = false


# PUBLIC FUNCTIONS

# Change flag to mark container as free to be interacted with again
func close_container() -> void:
	_interactable = true

# Change container inventory to new inventory and change container size to match
func set_inventory(new_inventory: Inventory) -> void:
	inventory = new_inventory
	container_size = inventory.get_inventory_size()

# Return container inventory object
func get_inventory() -> Inventory:
	return inventory

# Change container size and adjust inventory to match
func set_container_size(size: int) -> void:
	container_size = size
	inventory.set_inventory_size(container_size)

# Return size of container as int
func get_container_size() -> int:
	return container_size
