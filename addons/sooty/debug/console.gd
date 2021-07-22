extends Node

onready var back:= $container
onready var input:LineEdit = $container/items/input
onready var output:RichTextLabel = $container/items/output

var _last:String = ""

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	input.focus_mode = Control.FOCUS_ALL
	var _e
	_e = input.connect("text_entered", self, "_submit")
	_e = input.connect("text_changed", self, "_changed")
	_e = output.connect("meta_clicked", self, "_meta")
	
	back.visible = false
	
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	Resources.set_fonts(input, "unifont 16")
	Resources.set_fonts(output, "unifont 16")
	
	if Sooty.has_chapters():
		var chapters = Sooty._data.CHAPTERS.keys()
		chapters.invert()
		for k in chapters:
			_add("[url=_stack_goto(\"%s\")][color=#%s]%s[/color][/url]" % [k, Color.yellowgreen.to_html(), k])

func _meta(m):
	print(m)
	_toggle()
	UtilStr.evaluate(m, Sooty)
	Sooty.push_progress()

func _submit(t):
	_add(input.text)
	input.text = ""

func _changed(t):
	if t and t[input.caret_position-1] in "`~":
		input.delete_char_at_cursor()
		_toggle()

func _add(s):
	output.bbcode_text = s + "\n" + output.bbcode_text

func _toggle():
	if back.visible:
		back.visible = false
		get_tree().paused = false
	
	else:
		back.visible = true
		input.grab_focus()
		get_tree().paused = true

func _unhandled_key_input(e):
	if e.pressed and e.scancode in [KEY_ASCIITILDE, KEY_QUOTELEFT, KEY_F3]:
		_toggle()
		get_tree().set_input_as_handled()
