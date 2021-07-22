extends CanvasLayer

const EN_UPPERCASE:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
const EN_LOWERCASE:String = "abcdefghijklmnopqrstuvwxyz"
const EN_SPACE:String = " "
const EN_NUMBERS:String = "0123456789"

var _old_value
var _new_value
var _key:String

var can_cancel:bool = true
var allow_lowercase:bool = true
var allow_uppercase:bool = true
var allow_space:bool = true
var allow_numbers:bool = false
var capitalize:bool = true
var disallow:Array = []
var limit:Array = [-1, -1]

onready var input:LineEdit = $backing/elements/input/input
onready var label:RichTextLabel = $backing/elements/label
onready var error:RichTextLabel = $backing/elements/error
onready var accept:Button = $backing/elements/input/accept
onready var cancel:Button = $backing/cancel

func _ready():
	var _e
	_e = input.connect("text_changed", self, "_text_changed")
	_e = cancel.connect("pressed", self, "_pressed", ["cancel"])
	_e = accept.connect("pressed", self, "_pressed", ["accept"])
	
	_e = Sooty.connect("hide_ui", self, "_sooty_hide_ui")
	
	$backing.material = Resources.create_shader_material("blur_screen_lod", {blur=4})
	Resources.set_fonts(label, Config.alert_name_font)
	Resources.set_fonts(input, Config.alert_name_font)
	
func _sooty_hide_ui(h):
	$backing.visible = not h

func _main(args=null, kwargs=null):
	_key = args[0]
	_old_value = Sooty._eval(_key)
	_new_value = _old_value
	
	input.placeholder_text = _key.split(".").join(" ").capitalize()
	
	var clr = Color.gray.to_html()
	label.bbcode_text = "[center]%s [color=#%s](current: %s)[/color]" % [Sooty.format(args[1]), clr, _old_value]
	
	input.text = str(_old_value)
	input.caret_position = len(str(_old_value))
	input.grab_focus()
	
	if kwargs:
		for item in [self, input]:
			for k in kwargs:
				item.set(k, kwargs[k])
	
	if not can_cancel:
		cancel.hide()

func _pause_sooty():
	return true

func _text_changed(new_text:String):
	# check for allowed characters
	var t:String = ""
	for c in new_text:
		if not allow_lowercase and c in EN_LOWERCASE: continue
		if not allow_uppercase and c in EN_UPPERCASE: continue
		if not allow_numbers and c in EN_NUMBERS: continue
		if not allow_space and c in EN_SPACE: continue
		t += c
	
	# check if ignored words
	error.visible = false
	error.bbcode_text = ""
	accept.disabled = false
	for word in disallow:
		if word in t.to_lower():
			accept.disabled = true
			if error.bbcode_text == "":
				error.bbcode_text = "[center][color=red]Can't use \"%s" % [word.capitalize()]
			else:
				error.bbcode_text += "\" or \"%s" % [word.capitalize()]
			error.visible = true
	error.bbcode_text += ".\""
	
	if limit[0] != -1 and len(t) < limit[0]:
		accept.disabled = true
	
	if limit[1] != -1 and len(t) > limit[1]:
		accept.disabled = true
	
	_new_value = t
	input.text = t
	input.caret_position = len(t)

func _finalize():
	var out = ""
	if capitalize:
		var was_space = true
		for c in _new_value:
			if was_space and not c in EN_SPACE:
				out += c.to_upper()
			else:
				out += c.to_lower()
			was_space = c in EN_SPACE
	else:
		out = _new_value
	return out.strip_edges()

func _pressed(btn):
	match btn:
		"cancel":
			queue_free()
		
		"accept":
			var val = _finalize()
			if "." in _key:
				var p = _key.split(".", true, 1)
				var obj = Sooty._data[p[0]]
				obj.set(p[1], val)
			else:
				Sooty._eval("%s = %s" % [_key, val])
			queue_free()
