extends Node

signal finished()

var time:float = 1.0
var reverse = false

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	get_tree().paused = true
	
	if reverse:
		$rect.modulate = Color.black
		$tween.interpolate_property($rect, "modulate", Color.black, Color.transparent, time)
	
	else:
		$rect.modulate = Color.transparent
		$tween.interpolate_property($rect, "modulate", Color.transparent, Color.black, time)
	$tween.start()
	
	yield($tween, "tween_all_completed")
	get_tree().paused = false
	queue_free()
	emit_signal("finished")
