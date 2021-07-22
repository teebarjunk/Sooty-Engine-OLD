tool
extends Node
class_name ParseKwargs

const EVALS:Array = ["+=", "-=", "*=", "/=", ">=", "<=", "^=", "!=", "==", "=", ">", "<"]
# Works like pythons keyword args, kwargs.
# Converts strings like "my_func 10 power=20" to "my_func(10, {"power": 20})"

static func _number(s) -> bool:
	return s is float or s is int

static func _all_number(a:Array):
	for item in a:
		if not _number(item):
			return false
	return true

static func eval_to_tupleize(e) -> Dictionary:
	if e is Array:
		var out = {}
		for a in e:
			UtilDict.merge(out, tupleize(a))
		return out
	
	else:
		return tupleize(e)

static func tupleize(s:String) -> Dictionary:
	var out = {}
	if " = " in s:
		var p = s.split(" = ", true, 1)
		var l = UtilStr.split_and_strip(p[0], ",")
		var r = UtilStr.split_and_vars(p[1], ",")
		
		if len(l) == len(r):
			for i in len(l):
				out[l[i].strip_edges()] = r[i]
		
		elif len(l) == 1:
			var k = l[0]
			if _all_number(r):
				match len(r):
					2: out[k] = Vector2(r[0], r[1])
					3: out[k] = Vector3(r[0], r[1], r[2])
					_: out[k] = r
			else:
				out[k] = r
	
	return out

static func is_eval(s:String) -> bool:
	if " " in s:
		var p = s.split(" ")
		if len(p) == 3:
			if p[1].strip_edges() in EVALS:
				return true
	return false

static func parse_list(l:Array) -> Array:
	for i in len(l):
		l[i] = parse(l[i])
	return l

static func parse(s, extra_args:Array=[]):
	if s is Array:
		return parse_list(s)
	
	for e in EVALS:
		if e in s:
			var p = s.split(e, true, 1)
			if not " " in p[0].strip_edges():
				return s
	
	var args = split_args(s)
	if args.kwargs:
		args.args.append(args.kwargs)
	args = args.args
#	prints("   ", s, args)
	var call = args.pop_front()
	
	if extra_args:
		args.append_array(extra_args)
	
	for i in len(args):
		args[i] = var2str(args[i]).replace("\n", " ")
	
	return "%s(%s)" % [call, PoolStringArray(args).join(", ")]

const _v:Dictionary = {
	grabbed=""
}

static func _grab_unquoted_string(s, i):
	while i < len(s) and s[i] != " ":
		_v.grabbed += s[i]
		i += 1
	i += 1
	return i

static func _grab_string(s, i):
	i += 1
	while i < len(s) and s[i] != '"':
		_v.grabbed += s[i]
		i += 1
	i += 1
	_v.grabbed = '"%s"' % [_v.grabbed]
	return i

static func _grab_list(s, i):
	i += 1
	while i < len(s) and s[i] != ']':
		_v.grabbed += s[i]
		i += 1
	i += 1
	
	var args = []
	var kwargs = {}
	for v in _v.grabbed.split(","):
		v = v.strip_edges()
		if "=" in v:
			var p2 = v.split("=", true, 1)
			kwargs[p2[0].strip_edges()] = str2var(p2[1].strip_edges())
		else:
			args.append(var2str(str2var(v)))
	
	if kwargs:
		args.append(var2str(kwargs))
	
	_v.grabbed = "[%s]" % [PoolStringArray(args).join(", ")]# _v.grabbed]
	return i

static func _grab_dict(s, i):
	i += 1
	while i < len(s) and s[i] != '}':
		_v.grabbed += s[i]
		i += 1
	i += 1
	_v.grabbed = "{%s}" % [_v.grabbed]
	return i

static func _str_to_var(s:String):
	# .8 -> 0.8
	var v
	if s.begins_with(".") and s.split(".", true, 1)[1].is_valid_integer():
		v = str2var("0" + s)
	else:
		if s.is_valid_integer(): v = int(s)
		elif s.is_valid_float(): v = float(s)
		elif s.to_lower() in ["true", "false", "null"]: v = str2var(s)
		elif s.begins_with('"') and s.ends_with('"'): v = str2var(s)
		else: v = s
	return v
#	prints("\t\t\t", s, "->", v)

static func split_args(s:String) -> Dictionary:
	var parts = []
	s = s.replace("=", " = ")
	var i = 0
	var safety = 100
	while i < len(s):
		safety -= 1
		if safety < 0:
			print("SFETY")
			break
		
		_v.grabbed = ""
		match s[i]:
			'"': i = _grab_string(s, i)
			'[': i = _grab_list(s, i)
			'{': i = _grab_dict(s, i)
			_:   i = _grab_unquoted_string(s, i)
		
		if _v.grabbed.strip_edges():
			parts.append(_v.grabbed)
	
	var args = []
	var kwargs = {}
	i = 0
	while i < len(parts):
		if i < len(parts)-1 and parts[i+1] == "=":
			var key = parts[i]
			var val = _str_to_var(parts[i+2])
			kwargs[key] = val
			i += 3
		else:
			args.append(_str_to_var(parts[i]))
			i += 1
	
#	prints("\t\t", args, kwargs)
	return {args=args, kwargs=kwargs}

