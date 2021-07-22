tool
extends Tween
class_name SavableTween

var _tweens = [] # all the properties being modified
var _parent:Node

func set_parent(p:Node, data=null):
	_parent = p
	if data:
		_load(data)

func _ready():
	if not _parent:
		_parent = get_parent()

func _save():
	return { time=tell(), active=is_active(), tweens=_tweens }

func _load(d:Dictionary):
	var _e
	for item in _tweens:
		var object = _parent.get_node_or_null(item.name)
		match item.type:
			"prop": _e = .interpolate_property(object, item.prop, item.from, item.to, item.time, item.t, item.e, item.wait)
			"func": _e = .interpolate_method(object, item.func, item.from, item.to, item.time, item.t, item.e, item.wait)
	_tweens = d.tweens
	_e = start()
	_e = seek(d.time)

func not_finished() -> bool:
	return get_runtime() > tell()

func has_tweens():
	return len(_tweens) > 0

func interpolate(object:Object, property:String, from, to, time:float, trans_type = 0, ease_type = 2, wait:float = 0):
	_tweens.append({type="prop", name=object.name, prop=property, from=from, to=to, time=time, t=trans_type, e=ease_type, wait=wait})
	var _e = .interpolate_property(object, property, from, to, time, trans_type, ease_type, wait)

func interpolate_func(object:Object, method:String, from, to, time:float, trans_type = 0, ease_type = 2, wait:float = 0):
	_tweens.append({type="func", name=object.name, func=method, from=from, to=to, time=time, t=trans_type, e=ease_type, wait=wait})
	var _e = .interpolate_method(object, method, from, to, time, trans_type, ease_type, wait)

func stop_all():
	_tweens.clear()
	var _e = .stop_all()
