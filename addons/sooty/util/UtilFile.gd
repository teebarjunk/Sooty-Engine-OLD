extends Node
class_name UtilFile

static func exists(path:String) -> bool:
	return File.new().file_exists(path)

static func mtime(path:String) -> String:
	return str(File.new().get_modified_time(path))

static func get_directory(path:String) -> String:
	var parts = path.rsplit("/", true, 1)
	return parts[0]

static func get_extension(path:String) -> String:
	var parts = path.rsplit("/", true, 1)
	return parts[1].split(".", true, 1)[1]
	
static func replace_extension(path:String, ext:String) -> String:
	var parts = path.rsplit("/", true, 1)
	var fpath = parts[0]
	var fname = parts[1].split(".", true, 1)[0]
	return "%s/%s.%s" % [fpath, fname, ext]

static func create_directory(path:String):
	if path.begins_with("user://"):
		var d:Directory = Directory.new()
		var dir = get_directory(path)
		if not d.dir_exists(dir):
			UtilGodot.print_if_error(d.make_dir(dir), "error creating directory " + dir + ": %s")

static func save_node(path:String, node:Node):
	var packed = PackedScene.new()
	packed.pack(node)
	
	create_directory(path)
	
	UtilGodot.print_if_error(
		ResourceSaver.save(path, packed, ResourceSaver.FLAG_COMPRESS),
		"error saving node " + str(node) + ": %s")

static func save_image(path:String, image:Image):
	var f:File = File.new()
	var _e = f.open(path, File.WRITE)
	if _e == OK:
		f.store_buffer(image.save_png_to_buffer())
		f.close()
	else:
		push_error("can't save %s: %s" % [path, UtilGodot.error_name(_e)])

static func load_image(path:String) -> ImageTexture:
	if File.new().file_exists(path):
		var image = Image.new()
		image.load(path)
		var texture = ImageTexture.new()
		texture.create_from_image(image)
		return texture
	return null

static func load_dict(path:String) -> Dictionary:
	var f:File = File.new()
	if f.file_exists(path):
		var _e = f.open(path, File.READ)
		var data = JSON.parse(f.get_as_text()).result
		f.close()
		return data
	return {}

static func save_dict(path:String, dict:Dictionary) -> bool:
	if not path.begins_with("res://") and not path.begins_with("user://"):
		return false
	
	create_directory(path)
	
	var f:File = File.new()
	var _e = f.open(path, File.WRITE)
	if _e == OK:
		f.store_string(JSON.print(dict))
		f.close()
		return true
	
	else:
		push_error("can't open %s: %s" % [path, UtilGodot.error_name(_e)])
		return false

static func load_text(path:String) -> String:
	var f:File = File.new()
	if f.file_exists(path):
		var _e = f.open(path, File.READ)
		if _e != OK:
			print("failed opening %s: %s." % [path, UtilGodot.error_name(_e)])
		var text = f.get_as_text()
		f.close()
		return text
	else:
		return ""

static func save_text(path:String, text:String, extension=null):
	if extension != null:
		path = replace_extension(path, extension)
	
	var f:File = File.new()
	f.open(path, File.WRITE)
	f.store_string(text)
	f.close()
	print("saved to %s." % [path])

# Files

static func get_files_beginning_with(path:String, head:String, extensions:Array) -> Array:
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if not file:
			break
		elif file.begins_with(head) and _ends_with(file, extensions):
			files.append(file)
	dir.list_dir_end()
	return files

static func get_files(path:String, extensions:Array, nested:bool=true) -> Array:
	var files = []
	var dir = Directory.new()
	if dir.dir_exists(path) and dir.open(path) == OK:
		_get_files(dir, files, extensions, nested)
	else:
		push_error("no directory: %s" % [path])
	return files

static func _get_files(dir:Directory, files:Array, extensions:Array, nested:bool):
	if dir.file_exists("ignore.tres"):
		return
	
	dir.list_dir_begin(true, true)
	var file_name = dir.get_next()
	while file_name != "":
		var path = dir.get_current_dir()
		if not path.ends_with("/"):
			path += "/" + file_name
		else:
			path += file_name
		
		if dir.current_is_dir():
			if nested:
				var subDir = Directory.new()
				subDir.open(path)
				_get_files(subDir, files, extensions, true)
		
		elif _ends_with(file_name, extensions):
			files.append(path)
		
		file_name = dir.get_next()
	dir.list_dir_end()

static func _ends_with(s:String, endings:Array):
	for ending in endings:
		if s.ends_with(ending):
			return true
	return false

#static func is_json_serializable(val) -> bool:
#	match typeof(val):
#		TYPE_BOOL, TYPE_INT, TYPE_REAL, TYPE_STRING, TYPE_STRING_ARRAY, TYPE_INT_ARRAY, TYPE_REAL_ARRAY:
#			return true
#
#		TYPE_ARRAY:
#			for item in val:
#				if not is_json_serializable(item):
#					return false
#			return true
#
#		TYPE_DICTIONARY:
#			for k in val:
#				if not k is String or not is_json_serializable(val[k]):
#					return false
#			return true
#
#		_:
#			return false
