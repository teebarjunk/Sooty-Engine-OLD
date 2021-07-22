extends HBoxContainer

var button = Button.new()
var object:Object
var info
var pluginref

func _init(obj:Object, d, p):
	object = obj
	pluginref = p
	
	if d is String:
		info = {"call": d}
	else:
		info = d
	
	alignment = BoxContainer.ALIGN_CENTER
	size_flags_horizontal = SIZE_EXPAND_FILL
	
	add_child(button)
	button.size_flags_horizontal = SIZE_EXPAND_FILL
	button.text = get_label()
	button.modulate = info.get("tint", Color.white)
	button.disabled = info.get("disabled", false)
	button.connect("pressed", self, "_on_button_pressed")
	
	button.hint_tooltip = "%s(%s)" % [info.call, get_args_string()]
	
	if "hint" in info:
		button.hint_tooltip += "\n%s" % [info.hint]
	
	button.flat = info.get("flat", false)
	button.align  = info.get("align", Button.ALIGN_CENTER)
	
	if "icon" in info:
		button.expand_icon = false
		button.set_button_icon(load(info.icon))

func get_args_string():
	if not "args" in info:
		return ""
	var args = PoolStringArray()
	for a in info.args:
		if a is String:
			args.append('"%s"' % [a])
		else:
			args.append(str(a))
	return args.join(", ")
		
func get_label():
	if "text" in info:
		return info.text
	
	if "args" in info:
		return "%s (%s)" % [info.call.capitalize(), get_args_string()]
	
	return info.call.capitalize()

func _on_button_pressed():
	var returned
	
	if "args" in info:
		returned = object.callv(info.call, info.args)
	else:
		returned = object.call(info.call)
	
	if info.get("print", false):
		var a = get_args_string()
		if a:
			print(">> %s(%s): %s" % [info.call, a, returned])
		else:
			print(">> %s: %s" % [info.call, returned])
	
	if info.get("update_filesystem", false):
		pluginref.rescan_filesystem()
