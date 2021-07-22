extends Control

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	get_tree().paused = true
	
#	var backing = $control/backing
	$bg.material = Resources.create_shader_material("blur_screen_lod", {blur=4.0})
	
	var prefab = $items/backing/scroll/items/achievement
	var parent = $items/backing/scroll/items
	parent.remove_child(prefab)
	
	var _e
	_e = $items/clear.connect("pressed", AchievementManager, "clear_states")
	
	# total progress on all achievements.
	var t = AchievementManager.calculate_totals()
	$items/total_progress/label.text = "%s out of %s" % [t.completed, t.total]
	$items/total_progress/progress/bar.value = int(100 * t.progress)
	
	Resources.set_fonts($items/total_progress/label, Config.alert_name_font)
	Resources.set_fonts($items/total_progress/label, Config.alert_name_font)
	
	for id in AchievementManager.achievements:
		var item = prefab.duplicate()
		parent.add_child(item)
		item.set_name(id)
		item.setup(AchievementManager.achievements[id])
	
	yield(get_tree(), "idle_frame")
	hide()
	show()
	
func _exit_tree():
	get_tree().paused = false

func _unhandled_key_input(e):
	if e.pressed:
		match e.scancode:
			KEY_ESCAPE:
				queue_free()
