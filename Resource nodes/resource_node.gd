extends StaticBody2D

class_name ResourceNode

@onready var harvest_timer = $HarvestTimer
@onready var effect_animation = $Effects
@onready var numbers_origin = $NumbersOrigin
@export var resource: ItemResource
@onready var hit_box: Area2D = $HitBox

var interactable: bool = true
var harvest_time: float = 0.5


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hit_box.attempt_harvest.connect(_on_interact)
	hit_box.targeted.connect(highlight)

# 
func _on_interact() -> void:
	if interactable == true:
		effect_animation.show()
		effect_animation.play("PlayerMined")
		interactable = false
		harvest_timer.start(harvest_time)


func _on_harvest_timer_timeout() -> void:
	interactable = true
	effect_animation.stop()
	effect_animation.hide()

	var item_temp = Global.pickup.instantiate()
	item_temp.spawn_item(resource, self.global_position)
	#item_temp.initialize(resource, self.global_position)
	#item_temp.spawn_in()

	owner.add_child(item_temp)

# Highlights node when hitbox reports that it's under player StrikeBox
func highlight(state: bool) -> void:
	if state == true:
		modulate = Color(1.1, 1.1, 1.1)
	else:
		modulate = Color(1, 1, 1)
