tool
extends Node

static func is_wrapped(s:String, head:String, tail:String) -> bool:
	return s.begins_with(head) and s.ends_with(tail)

static func erase_between(s:String, head:String, tail:String) -> String:
	while true:
		var a = s.find(head)
		if a == -1: break
		var b = s.find(tail, a+len(head))
		if b == -1: break
		s = Util.part(s, 0, a) + Util.part(s, b+len(tail))
	return s

static func replace_between(s:String, head:String, tail:String, fr:FuncRef) -> String:
	var a = 0
	while true:
		a = s.find(head, a)
		if a == -1: break
		var b = s.find(tail, a+len(head))
		if b == -1: break
		var inner = Util.part(s, a+len(head), b)
		if head in inner:
			a += len(head)
			continue
		var got = fr.call_func(inner)
		s = Util.part(s, 0, a) + got + Util.part(s, b+len(tail))
		a += len(head)
	return s

# join
static func join(s, divider=", ") -> String:
	if s is PoolStringArray:
		return s.join(divider)
	elif s is Array:
		var p = PoolStringArray()
		for item in s:
			p.append(str(item))
		return p.join(divider)
	else:
		return str(s)

# string to variable string
static func to_var(s, constant:bool=false) -> String:
	s = join(s, " ")
	s = s.strip_edges().capitalize().to_lower()
	var out = ""
	var under = true
	for j in len(s):
		if s[j] in "0123456789abcdefghijklmnopqrstuvwxyz":
			out += s[j]
			under = true
		elif under:
			out += "_"
			under = false
	if constant:
		out = out.to_upper()
	return out

func format(s:String, obj:Object) -> String:
	while true:
		var a:int = s.find("{")
		if a == -1: break
		var b:int = s.find("}", a+1)
		if b == -1: break
		var inner:String = s.substr(a+1, b-a-1)
		
		if "|" in inner:
			# call formatting functions, like 'capitalize'
			var p = inner.split("|")
			inner = evaluate_string(p[0], obj)
			for i in range(1, len(p)):
				var p2 = Array(p[i].split(" "))
				var c = p2.pop_front()
				for j in len(p2):
					p2[j] = str2var(p2[j])
					if p2[j] is String and p2[j] in obj:
						p2[j] = obj[p2[j]]
				p2.push_front(inner)
				inner = callv(c, p2)
			inner = str(inner)
		
		else:
			inner = str(evaluate_string(inner, obj))
		
		s = s.substr(0, a) + inner + s.substr(b+1)
	return s

func split_and_strip(s:String, split_on:String) -> Array:
	var out = []
	for item in s.split(split_on):
		item = item.strip_edges()
		if item:
			out.append(item)
	return out

func split_and_vars(s:String, split_on:String) -> Array:
	var out = []
	for item in s.split(split_on):
		item = item.strip_edges()
		if item:
			out.append(str2var(item))
	return out

func evaluate(e, obj:Object):
	if e is String:
		return evaluate_string(e, obj)
	elif e is Array:
		for item in e:
			evaluate_string(item, obj)
	else:
		push_error("can't eval %s" % [e])

func evaluate_string(eval:String, obj:Object):
	for symbol in ["+=", "-=", "*=", "/=", "^=", "="]:
		if symbol in eval:
			var p = eval.split(symbol, true, 1)
			var key = p[0].strip_edges()
			if " " in key:
				break
			
			var val = _evaluate(p[1].strip_edges(), obj)
			if _expression.has_execute_failed():
				push_error("%s: %s(\"%s\")" % [_expression.get_error_text(), obj, eval])
				return
			
			if val == null:
				val = p[1]
			
			match symbol: # symbol
				"=":  obj.set(key, val)
				"+=": obj.set(key, obj[key] + val)
				"-=": obj.set(key, obj[key] - val)
				"*=": obj.set(key, obj[key] * val)
				"/=": obj.set(key, obj[key] / val)
				"^=": obj.set(key, not val)
			
			return obj.get(key)
	
	var result = _evaluate(eval, obj)
	if _expression.has_execute_failed():
		push_error("%s with %s.%s" % [_expression.get_error_text(), obj.get("name"), eval])
		return
	else:
#		print("\t>> EVAL %s: %s" % [eval, result])
		return result

var _expression:Expression = Expression.new()
func _evaluate(eval:String, o:Object):
	if _expression.parse(eval) == OK:
		var result = _expression.execute([], o, true)
		if not _expression.has_execute_failed():
			return result
	return null

func is_capitalized(s:String) -> bool: return s == s.to_upper()

# once upon a time -> Once Upon A Time
func capitalize(s) -> String: return str(s).capitalize()

# Mr Snow -> mr snow
func lower(s) -> String: return str(s).to_lower()

# Mr Snow -> MR SNOW
func upper(s) -> String: return str(s).to_upper()

# 1, 2, 3, 4 -> 1st, 2nd, 3rd, 4th
const _ORDINAL:Dictionary = {1: 'st', 2: 'nd', 3: 'rd'}
func ordinal(n) -> String:
	n = int(n)
	return str(n) + _ORDINAL.get(n if n % 100 < 20 else n % 10, "th")

# 12345678 -> 12,345,678
func commas(number):
	var string = str(number)
	var mod = len(string) % 3
	var out = ""
	for i in len(string):
		if i != 0 and i % 3 == mod:
			out += ","
		out += string[i]
	return out

# pluralize(apple, 1), pluralize(apple, 2) -> apple, apples
func pluralize(s, count, suffix="s") -> String:
	return str(s) + (suffix if count != 1 else "")

# pluralize(apple, 1), pluralize(apple, 2000) -> 1 apple, 2,000 apples
func x(s, count, suffix="s") -> String:
	return commas(count) + " " + pluralize(s, count, suffix)








#
