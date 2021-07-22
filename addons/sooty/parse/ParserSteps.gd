tool
class_name ParserSteps

const K_TYPE:String = "T"
const K_SECTION:String = "§"
const K_NODE:String = "@"

static func _str_to_step(line:String, then:Array):
	if len(line) > 2 and line[0] in "-*+" and line[1] == " ":
		return LIST_ITEM(line, then)
	
	elif line.begins_with("`") and line.strip_edges().ends_with("`"):
		return EVAL(line, then)
	
	elif line[0] in "$@." or ParseKwargs.is_eval(line):
		return EVAL(line, then)
	
	elif line.begins_with("if ") and line.strip_edges().ends_with(":"):
		return IF(line, then)
	
	elif line.begins_with("elif ") and line.strip_edges().ends_with(":"):
		return ELIF(line, then)
	
	elif line.begins_with("else:"):
		return ELSE(line, then)
	
	elif line.begins_with("match ") and line.strip_edges().ends_with(":"):
		return MATCH(line, then)
	
	elif line.begins_with("::"):
		var call = line.substr(2).strip_edges()
		return CALL(line)
		
	elif line.begins_with("->"):
		var goto = line.substr(2).strip_edges()
		return GOTO(goto)
	
	else:
		return TEXT(line, then)

static func CHAPTER(name:String) -> Dictionary:
	return { "T": "chapter", "id": UtilStr.to_var(name), "name": name, "then": [], "chapters": [] }

static func DATA(data:Dictionary) -> Dictionary:
	return { "T": "data", "data": data }

static func CODE(lang:String, code:String) -> Dictionary:
	return { "T": "code", "code": code }

static func QUOTE(line:String) -> Dictionary:
	return { "T": "quote", "quote": line }

static func IF(line:String, then:Array) -> Dictionary:
	var test = line.substr(3, len(line)-4)
	return { "T": "if", "test": test, "then": then, "else": [] }

static func ELIF(line:String, then:Array) -> Dictionary:
	var test = line.substr(5, len(line)-6)
	return { "T": "elif", "test": test, "then": then }

static func ELSE(line:String, then:Array) -> Dictionary:
	return { "T": "else", "then": then }

static func EVAL(line:String, then:Array) -> Dictionary:
	line = line.replace("`", "")#.substr(1, len(line)-2).strip_edges()
	
	if line.begins_with("@"):
		return NODE(line, then)
	
	elif line.begins_with("."):
		line = line.substr(1)
		return { "T": "eval", "eval": ParserCommon.str_to_func_list(line) }
		
	elif ":" in line:
		return str_to_DATA(line)
	
	elif line.begins_with(">>") or line.begins_with("->"):
		var goto = line.substr(2).strip_edges()
		return GOTO(goto)
	
	elif line.begins_with("(") and line.ends_with(")"):
		var call = line.substr(1, len(line)-2).strip_edges()
		return CALL(call)
	
	else:
		return { "T": "eval", "eval": ParserCommon.str_to_func_list(line) }

static func GOTO(goto:String) -> Dictionary:
	return { "T": "goto", "goto": goto }

static func CALL(call:String) -> Dictionary:
	return { "T": "call", "call": call }

static func CLEAR() -> Dictionary:
	return { "T": "clear" }

static func str_to_NODE(s:String) -> Dictionary:
	if s.begins_with("INT.") or s.begins_with("EXT."):
		var scene = Array(s.substr(4).strip_edges().to_lower().split(" - "))
		return {
			"T": "@",
			"@": "bg",
			"A": scene,
			"K": null,
			"eval": null,
			"then": null
		}
	
	return NODE("???", [])
	
static func NODE(line:String, then:Array) -> Dictionary:
	var eval = UtilStr.split_and_strip(line, ";")
	var ids = []
	var args = eval.pop_front()
	
	while args.begins_with("@"):
		var p = args.split(" ", true, 1)
		ids.append(p[0].substr(1).strip_edges())
		if len(p) > 1:
			args = p[1].strip_edges()
		else:
			args = ""
	
	var a = ParseKwargs.split_args(args)
	return {
		"T": "@",
		"@": ids[0] if len(ids) == 1 else ids,
		"A": a.args,
		"K": a.kwargs,
		"eval": ParserCommon.str_to_func_list(eval),
		"then": then
	}

static func MATCH(line:String, then:Array) -> Dictionary:
	var test = line.substr(6, len(line)-7)
	return { "T": "match", "test": test, "list": [], "then": then }

static func TEXT(line:String, then:Array) -> Dictionary:
	
	if line == "?":
		return { "T": "rand", "rand": [] }
	
	elif then:
		return { "T": "text", "text": line, "list": then, "then": [] }
	
	else:
		return { "T": "text", "text": line, "then": then }

static func LIST() -> Dictionary:
	return { "T": "list", "-": "", "list": [] }

static func LIST_ITEM(line:String, then:Array) -> Dictionary:
	var p = line.split(" ", true, 1)
	var type = p[0]
	var text = p[1].strip_edges()
	return { "T": "-", "-": type, "text": text, "then": then }

static func TABLE(a:Array) -> Dictionary:
	var keys = a.pop_front().split("|")
	var rows = []
	for i in range(1, len(a)):
		var r_keys = a[i].split("|")
		var r_data = {}
		for j in len(r_keys):
			r_data[keys[j]] = str2var(r_keys[j])
		rows.append(r_data)
	return { "T": "table", "table": rows }

static func str_to_CODE(s:String) -> Dictionary:
	var p = s.split("\n", true, 1)
	var lang = p[0].substr(3).strip_edges()
	var code = p[1]
	
	match lang:
		"json": return DATA(ParserCommon.parse_json(code))
		"yaml": return DATA(ParserCommon.parse_yaml(code))
		_: return CODE(lang, code)

static func str_to_DATA(s:String) -> Dictionary:
	var p = s.split(":", true, 1)
	var k = p[0].strip_edges()
	var v = str2var(p[1].strip_edges())
	return DATA({ k: v })

