extends Node



func display_number(value: int, position: Vector2, _is_critical: bool = false):
	var number = Label.new()
	number.global_position = position
	number.text = str(value)
	number.z_index = 5
	number.label_settings = LabelSettings.new()
	
	var color = "#FFF"
	if _is_critical == true:
		color = "#B22"
	if value == 0:
		color = "#FFF8"

	#number.set_texture_filter(1)
	#number.scale = Vector2(0.2, 0.2) # Vector2
	
	number.label_settings.font = load("res://Assets/Fonts/Terminus.ttf")
	number.label_settings.font_color = color
	number.label_settings.set_font_size(12)
	
	number.label_settings.outline_color = "#000"
	number.label_settings.outline_size = 1
	
	call_deferred("add_child", number)
	
	await number.resized
	number.pivot_offset = Vector2(number.size / 2)
	
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	# Animate number going up
	tween.tween_property(
		number, "position:y", number.position.y - 24, 0.25
	).set_ease(Tween.EASE_OUT)
	# Animate number going down
	tween.tween_property(
		number, "position:y", number.position.y, 0.5
	).set_ease(Tween.EASE_IN).set_delay(0.25)
	tween.tween_property(
		number, "scale", Vector2.ZERO, 0.25
	).set_ease(Tween.EASE_IN).set_delay(0.5)
	
	await tween.finished
	number.queue_free()
