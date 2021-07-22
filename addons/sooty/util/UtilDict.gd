class_name UtilDict

# godot preserves dict order, so this can work
static func dict_to_args(d:Dictionary, ignore=[]):
	var out = []
	for k in d:
		if not k in ignore:
			out.append(d[k])
	return out

static func printd(d:Dictionary):
	var e = PoolStringArray()
	for k in d:
		e.append("%s: %s" % [k, d[k]])
	print("{ %s }" % [e.join(", ")])

static func merge(target:Dictionary, patch:Dictionary):
	for k in patch:
		target[k] = patch[k]

static func flip_keys_and_values(d:Dictionary) -> Dictionary:
	var out = {}
	for k in d:
		out[d[k]] = k
	return out

func sort(d:Dictionary, reversed:bool=false) -> Dictionary:
	var a = []
	for k in d:
		a.append([len(k) if k is String else k, k, d[k]])
	
	if reversed:
		a.sort_custom(self, "_sort_dict_reversed")
	else:
		a.sort_custom(self, "_sort_dict")
	
	d.clear()
	for item in a:
		d[item[1]] = item[2]
	
	return d

func _sort_dict(a, b): return a[0] < b[0]
func _sort_dict_reversed(a, b): return a[0] > b[0]


# calls a function on every dict
static func dig(d, fr:FuncRef, reverse:bool=false):
	if d is Dictionary:
		if reverse:
			fr.call_func(d)
		
		for k in d:
			dig(d[k], fr)
		
		if not reverse:
			fr.call_func(d)
	
	elif d is Array:
		for i in d:
			dig(i, fr)

static func dig_replace(d, fr:FuncRef):
	if d is Dictionary:
		for k in d:
			dig_replace(d[k], fr)
		return fr.call_func(d)
	
	elif d is Array:
		for i in len(d):
			var r = dig_replace(d[i], fr)
			if r:
				d[i] = r
