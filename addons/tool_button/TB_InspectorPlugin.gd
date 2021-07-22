extends EditorInspectorPlugin

var InspectorToolButton = preload("res://addons/tool_button/TB_Button.gd")
var pluginref

var cache_methods = {}
var cache_selected = {}

func _init(p):
	pluginref = p
	
func can_handle(object):
#	if not object in cache_methods:
	cache_methods[object] = _collect_methods(object)
	return cache_methods[object] or object.has_method("_get_tool_buttons")

func parse_category(object, category):
	match category:
		# automatic buttons
		"Node", "Resource":
			if cache_methods[object]:
				for method in cache_methods[object]:
					add_custom_control(InspectorToolButton.new(object, {
						tint=Color.greenyellow,
						call=method,
						print=true,
						update_filesystem=true
					}, pluginref))

func parse_begin(object):
	# explicitly selected buttons
	if object.has_method("_get_tool_buttons"):
		var methods
		if object is Resource:
			methods = object.get_script()._get_tool_buttons()
		else:
			methods = object._get_tool_buttons()
		
		if methods:
			for method in methods:
				add_custom_control(InspectorToolButton.new(object, method, pluginref))

func _collect_methods(object:Object):
	var script = object.get_script()
	if not script or not script.is_tool():
		return []
	
	var default_methods = []
	
	# ignore methods of parent
	if object is Resource:
		for m in ClassDB.class_get_method_list(object.get_script().get_class()):
			default_methods.append(m.name)
	else:
		for m in ClassDB.class_get_method_list(object.get_class()):
			default_methods.append(m.name)
	
	var methods = []
	for item in object.get_method_list():
		if not item.name in default_methods:
			# has all default arguments
			if not item.name.begins_with("_"):# len(item.args) == len(item.default_args):
				methods.append(item.name)
	
	return methods
