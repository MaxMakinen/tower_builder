extends StaticBody2D


@onready var interaction_area: InteractionArea = $InteractionArea
@onready var harvest_timer = $HarvestTimer
@onready var effect_animation = $Effects
@onready var numbers_origin = $NumbersOrigin
@export var type: String = "Stone"
@export var yields: int = 5
var interactable: bool = true
var harvest_time: float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_area.interact = Callable(self, "_on_interact")


func _on_interact():
	effect_animation.show()
	effect_animation.play("PlayerMined")
	interactable = false
	harvest_timer.start(harvest_time)
	print("Interaction success")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_harvest_timer_timeout():
	interactable = true
	if type not in Game.inventory:
		Game.inventory[type] = 0
	Game.inventory[type] += yields
	DamageNumbers.display_number(yields, numbers_origin.global_position)
	effect_animation.stop()
	effect_animation.hide()
