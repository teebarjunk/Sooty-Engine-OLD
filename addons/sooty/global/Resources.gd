tool
extends Node

const DIRS:Dictionary = {
	"fonts": "res://fonts",
	"audio": "res://audio",
	"images": "res://images",
	"scenes": "res://scenes",
	"shaders": "res://shaders",
	"materials": "res://shaders"
}

const EXTS:Dictionary = {
	"fonts": ["tres"],
	"audio": ["mp3", "wav", "ogg"],
	"images": ["png", "jpg", "webp"],
	"scenes": ["scn", "tscn"],
	"shaders": ["shader"],
	"materials": ["tres"]
}

export var _resources:Dictionary = {}
export var _cache:Dictionary = {}
export var _counts:Dictionary = {}

func _init():
	for type in DIRS:
		_resources[type] = {}
		_cache[type] = {}
		_counts[type] = {}

func font_path(id:String) -> String: return _find("fonts", id)
func audio_path(id:String) -> String: return _find("audio", id)
func image_path(id:String) -> String: return _find("images", id)
func scene_path(id:String) -> String: return _find("scenes", id)
func shader_path(id:String) -> String: return _find("shaders", id)
func material_path(id:String) -> String: return _find("materials", id)

func load_font(id:String) -> Font:
	var path = font_path(id)
	if file_exists(path):
		return load(path) as Font
	return null

func load_material(id:String) -> Material:
	var path = material_path(id)
	if file_exists(path):
		return load(path) as Material
	return null

func load_texture(id:String) -> Texture:
	return load(image_path(id)) as Texture

func file_exists(path:String) -> bool:
	return File.new().file_exists(path)

func set_texture(node:Node, id:String):
	var path = image_path(id)
	if path:
		var img = load(path)
		if img:
			node.set_texture(img)

func create_scene(id:String, parent:Node=null, params=null) -> Node:
	var path = scene_path(id)
	if path:
		var node = load(path).instance()
		
		# set vars
		if params:
			for k in params:
				if not node.has_method(k):
					node.set(k, params[k])
		
		# add to parent
		if parent:
			parent.add_child(node)
			node.set_owner(parent)
		
		# call functions
		if params:
			for k in params:
				if node.has_method(k):
					node.callv(k, params[k])
		
		return node
	
	else:
		prints("can't find scene", id, path)
	
	return null

func create_shader_material(id:String, params:Dictionary={}) -> ShaderMaterial:
	var path = shader_path(id)
	if path:
		var sm = ShaderMaterial.new()
		sm.shader = load(path)
		for k in params:
			sm.set_shader_param(k, params[k])
		return sm
	return null

func get_font_set(head:String) -> Dictionary:
	return {
		regular=load_font(head + " regular"),
		bold=load_font(head + " bold"),
		italic=load_font(head + " italic"),
		bold_italic=load_font(head + " bold italic")
	}

func set_fonts(node, font_name:String):
	if node is RichTextLabel:
		var fonts = get_font_set(font_name)
		node.add_font_override("normal_font", fonts.regular)
		node.add_font_override("bold_font", fonts.bold)
		node.add_font_override("italics_font", fonts.italic)
		node.add_font_override("bold_italics_font", fonts.bold_italic)
	
#	elif node is Label:
	else:
		node.add_font_override("font", load_font("%s regular" % [font_name]))
	
#	elif node is LineEdit:
#		node.add_font_override("font", load_font("%s regular" % [font_name]))

func _load_collection(data):
#	var data = DictionaryResource.load_data("res://ResourceDatabase.tres")._data
	for type in data:
		data[type] = UtilDict.flip_keys_and_values(data[type])
	_resources = data

func _save_collection():
	var save = {}
	for rtype in _resources:
		save[rtype] = UtilDict.flip_keys_and_values(_resources[rtype])
#	var rd = load("res://addons/sooty/objects/ResourceDatabase.gd").new(save)
#	rd.save_data("res://ResourceDatabase.tres")
	return save

func _update():
	_resources.clear()
	_cache.clear()
	_counts.clear()
	
	var t_start = OS.get_system_time_msecs()
	
	for type in DIRS:
		_resources[type] = {}
		_cache[type] = {}
		_counts[type] = {}
		
		if type in ["materials", "fonts"]:
			continue
			
		for path in UtilFile.get_files(DIRS[type], EXTS[type]):
			_resources[type][_path(DIRS[type], path)] = path
	
	for path in UtilFile.get_files(DIRS["materials"], EXTS["materials"]):
		var file = load(path)
		if file is Material:
			_resources["materials"][_path(DIRS["materials"], path)] = path
	
	for path in UtilFile.get_files(DIRS["fonts"], EXTS["fonts"]):
		var file = load(path)
		if file is Font:
			_resources["fonts"][_path(DIRS["fonts"], path)] = path
	
#	print(JSON.print(_resource, "\t\t"))
	var t_end = OS.get_system_time_msecs()
	var counts = PoolStringArray()
	for type in DIRS:
		counts.append("%s %s" % [len(_resources[type]), type])
	print("found %s in %s msec." % [counts.join(", "), t_end - t_start])

func _path(dir:String, s:String) -> Array:
	var out = []
	for part in s.substr(len(dir)).rsplit(".", true, 1)[0].split("/"):
		var next = _standardize(part)
		# don't add duplicates, since it's common to name an asset after it's folder
		if len(out) == 0 or out[-1] != next:
			out.append(next)
	var f_name = out.pop_back()
	var f_path = PoolStringArray(out).join(" ")
	return [f_path, f_name]

func _standardize(s:String) -> String:
	var next = ""
	s = s.capitalize().to_lower()
	for i in len(s):
		var c = s[i]
		if c in "abcdefghijklmnopqrstuvwxyz0123456789":
			# ignore leading 0's.
			if c.is_valid_integer() and next and not next[-1].is_valid_integer():
				if c != "0":
					next += c
			
			else:
				next += c
		
		elif next and next[-1] != " " and i < len(s)-1:
			next += " "
		
	return next

func _ends_with(a:Array, b:Array):
	var la = len(a)
	var lb = len(b)
	if la < lb:
		return false
	for i in lb-1:
#		prints("EW", a, b)
		if a[la-lb+i] != b[i]:
			return false
	return a[-1].begins_with(b[-1])

func _find(type:String, id:String) -> String:
	if not id:
		return ""
	
	var path = ""
	
	if not id in _cache[type]:
		path = _deep_find(type, id)
		if path:
			_cache[type][id] = path
	
	if id in _cache[type]:
		path = _cache[type][id]
		
		# count uses
		if not path in _counts[type]:
			_counts[type][path] = 1
		else:
			_counts[type][path] += 1
	
	return path

func _deep_find(type:String, id:String) -> String:
	var list:Dictionary = _resources[type]
#	print("FIND ", name, list.keys())
	id = _standardize(id)
	
	var path = [id]
	if path in list:
		return list[path]
	
	for item in list:
#		prints("  ", item[-1], name, item[-1] == name)
		if item[-1] == id:
			return list[item]
	
	# keep breaking the word off to treat as a folder.
	for i in range(0, id.count(" ")):
		var iddd = Array(id.rsplit(" ", true, i))
		var head = iddd.pop_front()
		var tail = PoolStringArray(iddd).join(" ")
		var key = [head, tail]
		for item in list:
			if item[0].ends_with(head) and item[1].begins_with(tail):
				return list[item]
	
	# find a resource that's name starts with this one.
	for p in list:
		if p[-1].begins_with(id):
			return list[p]
	
	for p in list:
		if id in p[-1]:
			return list[p]
	
#	push_error("Can't find resource: %s" % [name])
	return ""
