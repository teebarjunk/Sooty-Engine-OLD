tool
class_name UtilGodot

static func is_html() -> bool:
	return OS.get_name() == "HTML5"

static func is_good(node:Node) -> bool:
	return node and is_instance_valid(node) and not node.is_queued_for_deletion()

static func get_script_properties(node:Node) -> PoolStringArray:
	var default_properties = []
	for prop in ClassDB.class_get_property_list(node.get_class()):
		default_properties.append(prop.name)
	
	var methods = PoolStringArray()
	for prop in node.get_property_list():
		if not prop.name in default_properties:
			methods.append(prop.name)
	return methods

static func call_group(group:String, call:String, args:Array):
	var t:SceneTree = Global.get_tree()
	match len(args):
		0: return t.call_group(group, call)
		1: return t.call_group(group, call, args[0])
		2: return t.call_group(group, call, args[0], args[1])
		3: return t.call_group(group, call, args[0], args[1], args[2])
		4: return t.call_group(group, call, args[0], args[1], args[2], args[3])
		5: return t.call_group(group, call, args[0], args[1], args[2], args[3], args[4])

static func create_class(name:String, args=null):
	for item in ProjectSettings.get_setting("_global_script_classes"):
		if item.class == name:
			if args:
				return load(item.path).new(args)
			else:
				return load(item.path).new()
	return null

const TWEENS = ["linear", "sine", "quint", "quart", "quad", "expo", "elastic", "cubic", "circ", "bounce", "back"]
static func tween(name:String):
	for i in len(TWEENS):
		if TWEENS[i].begins_with(name):
			return i
	return 0

static func get_script_variable_names(o:Object, get_underscored:bool=false) -> Array:
	var out = []
	var save = false
	for f in o.get_property_list():
		if save:
			# ignore any starting with an underscore
			if get_underscored or f.name[0] != "_":
				out.append(f.name)
		elif f.name == "Script Variables":
			save = true
	return out

static func get_script_variable_state(o:Object, get_underscored:bool=false) -> Dictionary:
	var out = {}
	for k in get_script_variable_names(o, get_underscored):
		out[k] = o.get(k)
	return out

static func type_default(v):
	match typeof(v):
		TYPE_NIL: return null
		TYPE_BOOL: return false
		TYPE_INT: return 0
		TYPE_REAL: return 0.0
		TYPE_STRING: return ""
		
		TYPE_VECTOR2: return Vector2()
		TYPE_RECT2: return Rect2()
		TYPE_VECTOR3: return Vector3()
		TYPE_TRANSFORM2D: return Transform2D()
		TYPE_PLANE: return Plane()
		TYPE_QUAT: return Quat()
		TYPE_AABB: return AABB()
		TYPE_BASIS: return Basis()
		TYPE_TRANSFORM: return Transform()
		TYPE_COLOR: return Color()
#		TYPE_NODE_PATH: return NodePath
#		TYPE_RID: return "RID"
#		TYPE_OBJECT: return "Object"
		
		TYPE_DICTIONARY: return {}
		TYPE_ARRAY: return []
	return v

static func type_name(v) -> String:
	return _type_name(typeof(v))

static func _type_name(v:int) -> String:
	match v:
		-1: return "ANY"
		TYPE_NIL: return "null"
		TYPE_BOOL: return "bool"
		TYPE_INT: return "int"
		TYPE_REAL: return "float"
		TYPE_STRING: return "String"
		TYPE_VECTOR2: return "Vector2"
		TYPE_RECT2: return "Rect2"
		TYPE_VECTOR3: return "Vector3"
		TYPE_TRANSFORM2D: return "Transform2D"
		TYPE_PLANE: return "Plane"
		TYPE_QUAT: return "Quat"
		TYPE_AABB: return "AABB"
		TYPE_BASIS: return "Basis"
		TYPE_TRANSFORM: return "Transform"
		TYPE_COLOR: return "Color"
		TYPE_NODE_PATH: return "NodePath"
		TYPE_RID: return "RID"
		TYPE_OBJECT: return "Object"
		TYPE_DICTIONARY: return "Dictionary"
		TYPE_ARRAY: return "Array"
		TYPE_RAW_ARRAY: return "PoolByteArray"
		TYPE_INT_ARRAY: return "PoolIntArray"
		TYPE_REAL_ARRAY: return "PoolRealArray"
		TYPE_STRING_ARRAY: return "PoolStringArray"
		TYPE_VECTOR2_ARRAY: return "PoolVector2Array"
		TYPE_VECTOR3_ARRAY: return "PoolVector3Array"
		TYPE_COLOR_ARRAY: return "PoolColorArray"
		_: return "???"

static func print_if_error(error, msg:String="ERROR: %s"):
	if error != OK:
		print(msg % [error_name(error)])

static func error_name(error) -> String:
	match error:
		OK: return "Okay"
		FAILED: return "Generic"
		ERR_UNAVAILABLE: return "Unavailable"
		ERR_UNCONFIGURED: return "Unconfigured"
		ERR_UNAUTHORIZED: return "Unauthorized"
		ERR_PARAMETER_RANGE_ERROR: return "Parameter range"
		ERR_OUT_OF_MEMORY: return "Out of memory (OOM)"
		ERR_FILE_NOT_FOUND: return "File: Not found"
		ERR_FILE_BAD_DRIVE: return "File: Bad drive"
		ERR_FILE_BAD_PATH: return "File: Bad path"
		ERR_FILE_NO_PERMISSION: return "File: No permission"
		ERR_FILE_ALREADY_IN_USE: return "File: Already in use"
		ERR_FILE_CANT_OPEN: return "File: Can't open"
		ERR_FILE_CANT_WRITE: return "File: Can't write"
		ERR_FILE_CANT_READ: return "File: Can't read"
		ERR_FILE_UNRECOGNIZED: return "File: Unrecognized"
		ERR_FILE_CORRUPT: return "File: Corrupt"
		ERR_FILE_MISSING_DEPENDENCIES: return "File: Missing dependencies"
		ERR_FILE_EOF: return "File: End of file (EOF)"
		ERR_CANT_OPEN: return "Can't open"
		ERR_CANT_CREATE: return "Can't create"
		ERR_QUERY_FAILED: return "Query failed"
		ERR_ALREADY_IN_USE: return "Already in use"
		ERR_LOCKED: return "Locked"
		ERR_TIMEOUT: return "Timeout"
		ERR_CANT_CONNECT: return "Can't connect"
		ERR_CANT_RESOLVE: return "Can't resolve"
		ERR_CONNECTION_ERROR: return "Connection"
		ERR_CANT_ACQUIRE_RESOURCE: return "Can't acquire resource"
		ERR_CANT_FORK: return "Can't fork process"
		ERR_INVALID_DATA: return "Invalid data"
		ERR_INVALID_PARAMETER: return "Invalid parameter"
		ERR_ALREADY_EXISTS: return "Already exists"
		ERR_DOES_NOT_EXIST: return "Does not exist"
		ERR_DATABASE_CANT_READ: return "Database: Read"
		ERR_DATABASE_CANT_WRITE: return "Database: Write"
		ERR_COMPILATION_FAILED: return "Compilation failed"
		ERR_METHOD_NOT_FOUND: return "Method not found"
		ERR_LINK_FAILED: return "Linking failed"
		ERR_SCRIPT_FAILED: return "Script failed"
		ERR_CYCLIC_LINK: return "Cycling link (import cycle)"
		ERR_INVALID_DECLARATION: return "Invalid declaration"
		ERR_DUPLICATE_SYMBOL: return "Duplicate symbol"
		ERR_PARSE_ERROR: return "Parse"
		ERR_BUSY: return "Busy"
		ERR_SKIP: return "Skip"
		ERR_HELP: return "Help"
		ERR_BUG: return "Bug"
		ERR_PRINTER_ON_FIRE: return "Printer on fire. (This is an easter egg, no engine methods return this error code.)"
		_: return "ERROR???"
