@tool
extends StaticBody2D

@onready var interaction_area: InteractionArea = $InteractionArea

@onready var glow: Sprite2D = %Glow
var animation_tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	interaction_area.player_entered.connect(_animate)
	interaction_area.player_exited.connect(_stop_animate)
	if Engine.is_editor_hint():
		_animate()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _animate() -> void:
	glow.show()
	animation_tween = create_tween().set_loops()
	animation_tween.tween_property(glow, "modulate", Color.TRANSPARENT, 1)#.set_ease(Tween.EASE_IN_OUT)
	animation_tween.tween_interval(0.1)
	animation_tween.tween_property(glow, "modulate", Color(1, 1, 1), 1).set_ease(Tween.EASE_IN_OUT)
	animation_tween.tween_interval(0.2)

func _stop_animate() -> void:
	glow.hide()
	animation_tween.kill()

# Called when player interacts with interaction area
func _on_interact():
	print("INTERACTION")
	print("Start Crafting")
	pass
