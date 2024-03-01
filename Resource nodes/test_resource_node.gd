extends StaticBody2D


@onready var interaction_area: InteractionArea = $InteractionArea
@onready var harvest_timer = $HarvestTimer
@onready var effect_animation = $Effects
@onready var numbers_origin = $NumbersOrigin
@export var type: String = "Stone"
@export var yields: int = 5

var interactable: bool = true
var harvest_time: float = 0.5
var item = preload("res://item.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_area.interact = Callable(self, "_on_interact")


func _on_interact():
	effect_animation.show()
	effect_animation.play("PlayerMined")
	interactable = false
	harvest_timer.start(harvest_time)
	print("Interaction success")


func _on_harvest_timer_timeout():
	interactable = true
	effect_animation.stop()
	effect_animation.hide()
#	if type not in Game.inventory:
#		Game.inventory[type] = 0
#	Game.inventory[type] += yields
#	DamageNumbers.display_number(yields, numbers_origin.global_position)
	var item_temp = item.instantiate()
	item_temp.set_type(type)
	item_temp.global_position = self.global_position
	item_temp.spawn_in()
	#item_temp.global_position = Vector2(self.global_position.x, self.global_position.y + 35)
	owner.add_child(item_temp)



