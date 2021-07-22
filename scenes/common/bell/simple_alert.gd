extends Node

onready var tween:Tween = $tween
onready var text:= $control/backing/center/text
onready var back := $control

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS

func _show_message(info):
	
	text.bbcode_text = "[center]" + info.text
	
	back.modulate = Color.transparent
	var _e
	_e = tween.interpolate_property(back, "modulate", Color.transparent, Color.white, 0.5)
	_e = tween.interpolate_property(back, "modulate", Color.white, Color.transparent, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 1.0)
	_e = tween.start()
	
	yield(tween, "tween_all_completed")
	queue_free()
