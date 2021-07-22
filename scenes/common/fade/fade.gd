extends Node

func _ready():
	$tween.set_parent(self)
	var _e = $tween.connect("tween_all_completed", self, "queue_free", [], CONNECT_ONESHOT)

func _save():
	return { tween=$tween._save() }

func _load(d:Dictionary):
	$tween.set_parent(self, d.tween)

func message(step:Dictionary):
	var time = step.get("duration", 2.0)
	$tween.interpolate($rect, "modulate", Color.black, Color.transparent, time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$tween.start()
