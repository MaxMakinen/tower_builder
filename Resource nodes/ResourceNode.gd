extends StaticBody2D

class_name ResourceNode

var 		being_mined := false
@onready	var effect = get_node("Effects")
@export		var type: String = "Ore"
@export		var amount: int = 10
@export		var harvest_time: float = 1.0
@onready var harvest_timer = $HarvestTimer
@onready var damage_numbers_origin = $DamageNumbersOrigin

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	harvest_timer.set_wait_time(harvest_time)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	if being_mined == true:
		effect.show()
		if harvest_timer.is_stopped():
			print("Node Being Mined")
			effect.play("PlayerMined")
			harvest_timer.start()
	being_mined = false
	if effect.is_playing() == false:
		effect.hide()


func mining() -> void:
	being_mined = true


func finished_mining() -> void:
	being_mined = false


func _on_effects_animation_finished() -> void:
	if being_mined == true:
		effect.play("PlayerMined")
	else:
		effect.hide()
		effect.stop()


func _on_harvest_timer_timeout() -> void:
	if type not in Game.inventory:
		Game.inventory[type] = 0
	Game.inventory[type] += amount
	DamageNumbers.display_number(amount, damage_numbers_origin.global_position)
	being_mined = false
