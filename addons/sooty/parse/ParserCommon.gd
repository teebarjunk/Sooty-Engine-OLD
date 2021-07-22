tool
class_name ParserCommon

static func parse_yaml(s:String):
	var data = {}
	for line in s.split("\n"):
		if ":" in line:
			var p = line.split(":", true, 1)
			var k = p[0].strip_edges()
			var v = p[1].strip_edges()
			data[k] = str2var(v)
	return data

static func parse_json(s:String):
	return JSON.parse(s).result

static func str_to_func_list(s):
	var out = []
	
	if s is String:
		for item in s.split(";"):
			var pk = ParseKwargs.parse(item.strip_edges())
			out.append(pk)
	
	elif s is Array:
		for item in s:
			out.append_array(str_to_func_list(item))
	
	return out

static func append(targ, patch):
	if patch:
		if patch is Array:
			targ.append_array(patch)
		
		else:
			targ.append(patch)

static func merge(targ:Dictionary, k:String, patch:Dictionary):
	if not k in targ:
		targ[k] = {}
	
	for k2 in patch:
		targ[k][k2] = patch[k2]
