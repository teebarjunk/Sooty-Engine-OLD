tool
extends Node

func nor(a, b):
	return a if a else b

func one_over(a):
	if a is Vector2:
		return Vector2(1.0 / a.x, 1.0 / a.y)

func div(x, y) -> float:
	if (x is int or x is float) and x != 0 and (y is int or y is float) and y != 0:
		return float(x) / float(y)
	return 0.0

var _call_returned = null
func call_method(o:Object, method:String, args=null):
	if try_call(o, method, args):
		return _call_returned
	return null

func try_call(o:Object, method:String, args=null) -> bool:
	if o.has_method(method):
		if args:
			_call_returned = o.callv(method, args)
		else:
			_call_returned = o.call(method)
		return true
	return false

func array(thing):
	return thing if thing is Array else [thing]

func clamp01(thing):
	if thing is float or thing is int:
		return clamp(thing, 0.0, 1.0)
	
	elif thing is Vector2:
		return Vector2(clamp(thing.x, 0.0, 1.0), clamp(thing.y, 0.0, 1.0))
	
	elif thing is Vector3:
		return Vector3(clamp(thing.x, 0.0, 1.0), clamp(thing.y, 0.0, 1.0), clamp(thing.z, 0.0, 1.0))
	
	return thing

# works like python list[begin:end]
static func part(a, begin:int=0, end=null):
	if end == null:
		end = len(a)
	elif end < 0:
		end = len(a) - end
	if a is Array:
		return (a as Array).slice(begin, end)
	else:
		return (a as String).substr(begin, end-begin)

static func get_color(color) -> Color:
	if color is Color:
		return color
	match color:
		"clear": return Color.transparent
	return ColorN(color)

static func remap(t, in_min, in_max, out_min, out_max):
	return (t - in_min) / (in_max - in_min) * (out_max - out_min) + out_min

static func get_keys(o:Object, keys:Array) -> Dictionary:
	var d = {}
	for key in keys:
		d[key] = o.get(key)
	return d

static func set_keys(o:Object, d:Dictionary):
	for k in d:
		o.set(k, d[k])

static func set_keys2(o:Object, d:Dictionary):
	for k in d:
		var f = "set_" + k
		if o.has_method(f):
			var _e = o.call(f, d[k])
		else:
			o.set(k, d[k])





