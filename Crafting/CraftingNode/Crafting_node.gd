extends StaticBody2D

class_name CraftingNode

@onready var hit_box: Area2D = $HitBox

@onready var glow: Sprite2D = %Glow
var animation_tween: Tween
var cooldown_tween: Tween


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	glow.hide()
	hit_box.targeted.connect(_animate)
	hit_box.attempt_interaction.connect(_on_interact)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# If targeted is true then start animation tween. Otherwise kill tween and hide glow sprite
func _animate(targeted: bool) -> void:
	if targeted == true:
		# If the cooldown_tween is in use, kill it and start animation with current values
		if cooldown_tween:
			cooldown_tween.kill()
		# If the cooldown_tween was not in use, ensure animation starts from full transparency
		else:
			glow.modulate = Color.TRANSPARENT
		glow.show()
		animation_tween = create_tween().set_loops()
		animation_tween.tween_property(glow, "modulate:a", 1, 1)#.set_ease(Tween.EASE_IN_OUT)
		animation_tween.tween_interval(0.1)
		animation_tween.tween_property(glow, "modulate:a", 0, 1)#.set_ease(Tween.EASE_IN_OUT)
		animation_tween.tween_interval(0.2)
	else:
		if animation_tween:
			animation_tween.kill()
		cooldown_tween = create_tween()
		cooldown_tween.tween_property(glow, "modulate:a", 0, 0.3)
		cooldown_tween.tween_callback(glow.hide)


# Called when player interacts with interaction area
func _on_interact():
	print("INTERACTION")
	print("Start Crafting")
	pass
