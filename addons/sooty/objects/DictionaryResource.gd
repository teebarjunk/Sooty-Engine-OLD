tool
extends Resource
class_name DictionaryResource

# Dictionary that can be saved as a resource.

static func save_collection(list) -> Dictionary:
	var out = {}
	for k in list:
		out[k] = list[k]._save()
	return out

static func load_collection(target, patch:Dictionary):
	for k in patch:
		if k in target:
			target[k]._load(patch[k])

signal modified(key, old, new)

var _script_property_names:Array

export var _modified:Array = []
export var _can_add_properties:bool = true # Allow adding keys?
export var _data:Dictionary

static func load_data(path:String):
	var dict_res
	var dict
	if path.ends_with(".json"):
		var f:File = File.new()
		if f.file_exists(path):
			f.open(path, File.READ)
			var text = f.get_as_text()
			f.close()
			
			dict = JSON.parse(text).result
		
		else:
			dict = {}
		
		dict_res = UtilGodot.create_class("DictionaryResource", dict)
	
	else:
		dict_res = load(path)
	
	return dict_res

func save_data(path:String):
	if path.ends_with(".json"):
		var f:File = File.new()
		f.open(path, File.WRITE)
		f.store_string(JSON.print(_data, "\t"))
		f.close()
	
	else:
		if OK == ResourceSaver.save(path, self, ResourceSaver.FLAG_COMPRESS):
			print("saved dict to %s. (%s keys)" % [path, len(_data)])
		else:
			print("failed saving dict to %s." % [path])


func _init(d=null):
	_script_property_names = UtilGodot.get_script_variable_names(self)
	if d:
		_merge(d)

func _save():
	var out = {}
	for k in _modified:
		out[k] = get(k)
	return out

func _load(d:Dictionary):
	_merge(d)

func _get(property):
	if property in _script_property_names:
		return self[property]
	
	elif property in _data:
		return _data[property]

func set(property, value):
	if property in _data:
		var old = _data[property]
		if value != old:
			_data[property] = value
			_on_modify(property, old, value)
	else:
		.set(property, value)

#	if property in _script_property_names:
#		var old = self[property]
#		if value != old:
#			.set(property, value)
#			_on_modify(property, old, value)
#
#	else:
#		.set(property, value)

#func _set(property, value):
#	if property in _script_property_names:
#		if self[property] != value:
#			var old = self[property]
#			self[property] = value
#			_on_modify(property, old, value)
#		return true
#
#	elif property in _data:
#		if _data[property] != value:
#			var old = _data[property]
#			_data[property] = value
#			_on_modify(property, old, value)
#		return true
#
#	# create the field
#	elif _can_add_properties:
#		_data[property] = value
#		_on_modify(property, null, value)
#		return true
#
#	return false

func _on_modify(property, old, new):
	if not property in _modified:
		_modified.append(property)
	emit_signal("modified", property, old, new)

func getor(key, default=null): return _data.get(key, default)
func keys() -> Array: return _data.keys()
func keys_modified() -> Array: return _modified
func values() -> Array: return _data.values()
func has(key) -> bool: return _data.has(key)
func has_all(keys:Array) -> bool: return _data.has_all(keys)
func clear():
	_data.clear()
	_modified.clear()
	
func erase(key) -> bool:
	_modified.erase(key)
	return _data.erase(key)

func erase_all(keys:Array):
	for key in keys:
		erase(key)

func _merge(d:Dictionary):
	for k in d:
		if k in _script_property_names:
			self[k] = d[k]
		else:
			_data[k] = d[k]
	return self

func _merge_unique(d:Dictionary):
	for k in d:
		if not k in _data:
			_data[k] = d[k]

func get_script_properties() -> Dictionary:
	var out = {}
	for k in _script_property_names:
		out[k] = self[k]
	return out

func _to_string():
	return "DictionaryResource(%s, %s)" % [_data, get_script_properties()]
