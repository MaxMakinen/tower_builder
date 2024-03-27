extends StaticBody2D

class_name WorldItemContainer


# EXPORT VARIABLES
@export var _inventory: Inventory
@export var _container_size: int = 1
@export var _container_name: String

# ONREADY VARIABLES
@onready var interaction_area: InteractionArea = $InteractionArea
@onready var container_ui: PanelContainer = $Container_UI

# PRIVATE VARIABLES
var _interactable: bool = true

# SIGNALS
signal open_container(inventory)

# PRIVATE FUNCTIONS

# When constructing new container, adjust container size according to input or use default value of 1
func _init(size: int = _container_size, name: String = "Unnamed container") -> void:
	_container_size = size
	_container_name = name
	if _inventory == null:
		_inventory = Inventory.new(_container_size)
	else:
		_inventory.set_inventory_size(_container_size)

# Called when the node enters the scene tree for the first time. connect to interaction area signal
func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	container_ui.set_inventory(_inventory)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Called when player interacts with interaction area
func _on_interact():
	print("Interacting with chest")
	if _interactable:
		open_container.emit(_inventory)
		_interactable = false


# PUBLIC FUNCTIONS

# Change flag to mark container as free to be interacted with again
func close_container() -> void:
	_interactable = true

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
func set_container_name(name: String) -> void:
	_container_name = name

# Get container name
func get_container_name() -> String:
	return _container_name

