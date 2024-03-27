extends StaticBody2D

class_name WorldItemContainer


# EXPORT VARIABLES
@export var _inventory: Inventory
@export var _container_size: int = 1
@export var _container_name: String = "Unnamed"


# ONREADY VARIABLES
@onready var interaction_area: InteractionArea = $InteractionArea

# PRIVATE VARIABLES
var _interactable: bool = true

# SIGNALS
signal open_container(inventory)
signal close_container()

# PRIVATE FUNCTIONS

# Called when the node enters the scene tree for the first time. connect to interaction area signal
func _ready() -> void:
	if _inventory == null:
		_inventory = Inventory.new(_container_size)
	else:
		_inventory.set_inventory_size(_container_size)
	interaction_area.interact = Callable(self, "_on_interact")
	interaction_area.player_exited.connect(_close_container)

# Called when player interacts with interaction area
func _on_interact():
	if _interactable:
		_open_container()
#		open_container.emit(_inventory)
#		_interactable = false
	else:
		_close_container()
#		close_container.emit()
#		_interactable = true


func _open_container() -> void:
	open_container.emit(_inventory)
	_interactable = false


func _close_container() -> void:
	if _interactable == false:
		close_container.emit()
		_interactable = true


# PUBLIC FUNCTIONS

# Change container inventory to new inventory and change container size to match
func set_inventory(new_inventory: Inventory) -> void:
	_inventory = new_inventory
	_container_size = _inventory.get_inventory_size()

# Return container inventory object
func get_inventory() -> Inventory:
	return _inventory

# Change container size and adjust inventory to match
func set_container_size(size: int) -> void:
	_container_size = size
	_inventory.set_inventory_size(_container_size)

# Return size of container as int
func get_container_size() -> int:
	return _container_size

# Set container name
func set_container_name(new_name: String) -> void:
	_container_name = new_name

# Get container name
func get_container_name() -> String:
	return _container_name

