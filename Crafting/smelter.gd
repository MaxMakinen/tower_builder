extends CraftingNode

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var progress_timer: Timer = $ProgressTimer

const COPPER = preload("res://Item/Items/Copper.tres")
const COPPER_INGOT = preload("res://Item/Items/Copper_ingot.tres")


var progress: float = 0.0# : set = _set_progress



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if progress_bar.visible:
		progress_bar.value = progress - progress_timer.get_time_left()
		pass
	pass

# Called when player interacts with interaction area
func _on_interact():
	var ore = Global.player_inventory.in_inventory(COPPER)
	if ore:
		print("Can Smelt")
		ore.change_amount(-2)
		init_progress(3.0)
	else:
		print("Can't do Shit")

func init_progress(_work_time: float) -> void:
	progress_bar.max_value = _work_time
	progress = _work_time
	progress_bar.show()
	progress_timer.start(_work_time)


func _set_progress(new_progress) -> void:
	pass

func _on_progress_timer_timeout() -> void:
	var item_temp = Global.pickup.instantiate()
	item_temp.spawn_item(COPPER_INGOT, self.global_position)
	owner.add_child(item_temp)
	
	progress_bar.hide()
	progress = 0.0


