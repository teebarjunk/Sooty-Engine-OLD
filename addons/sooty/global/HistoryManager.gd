extends Resource
class_name History

var _sooty:Sooty
var _events:Array = []

func _init(s):
	_sooty = s

func add(event):
	_events.append({
		check=_sooty._checkpoints[-1],
		from=event.from,
		text=event.text,
	})
