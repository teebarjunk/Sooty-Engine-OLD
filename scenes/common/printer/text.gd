extends Node

var PER_CHAR_SPEED:float = .02

var _waiting:bool = true
var _pause:bool = true
var _caption:String
var _name:String

onready var l_caption := $control/items/caption
onready var l_name := $control/items/name
export var fonts = []

func _ready():
	var _e
	_e = l_caption.connect("meta_clicked", self, "_meta", ["clicked"])
	_e = l_caption.connect("meta_hover_started", self, "_meta", ["entered"])
	_e = l_caption.connect("meta_hover_ended", self, "_meta", ["exited"])
	
	_e = l_name.connect("item_rect_changed", self, "_rect_changed")
	_e = l_caption.connect("item_rect_changed", self, "_rect_changed")
	_rect_changed()
	
	if Engine.editor_hint:
		set_process(false)
	
	Resources.set_fonts(l_name, Config.name_font)
	Resources.set_fonts(l_caption, Config.caption_font)
	
	var mat = Resources.create_shader_material("blur_screen_lod", {blur=4.0})
	$control/caption_backing.material = mat#Resources.load_material("blur screen lod")
	$control/name_backing.material = mat#Resources.load_material("blur screen lod")
	
	_e = Sooty.connect("hide_ui", self, "_hide_ui")

func _hide_ui(h):
	$control.visible = not h

func _save():
	return {
		_waiting=_waiting,
		_name=_name,
		_caption=_caption,
		_pause=_pause
	}

func _load(data:Dictionary):
	for k in data:
		set(k, data[k])
	_update_text()

func _rect_changed():
	$control/caption_backing.rect_position = l_caption.rect_global_position
	$control/caption_backing.rect_size = l_caption.rect_size
	
	$control/name_backing.visible = _name != ""
	$control/name_backing.rect_position = l_name.rect_global_position
	$control/name_backing.rect_size = l_name.rect_size

func _main(args, kwargs):
	_name = args[0]
	_caption = Sooty.format(args[1])
	_update_text()
	
	l_caption.percent_visible = 0.0
	
	var anim_time = len(l_caption.text) * PER_CHAR_SPEED
	$tween.interpolate_property(l_caption, "percent_visible", 0.0, 1.0, anim_time, Tween.TRANS_LINEAR)
	$tween.start()
	
	Sooty.emit_signal("text_started", _name, _caption, kwargs)
	yield($tween, "tween_all_completed")
	Sooty.emit_signal("text_finished", _name)

func _meta(url, state):
	print("META %s: %s" % [state, url])

func _update_text():
	if _name:
		var n = Util.nor(Sooty.get_character(_name), _name)
		l_name.set_bbcode("[center]%s[/center]" % [n])
		l_name.visible = true
	
	else:
		l_name.visible = false
	
	if _caption:
		l_caption.set_bbcode("[center]%s[/center]" % [_caption])

func _auto_complete():
	_end()

func _pause_sooty():
	return _pause

func _sooty_progress():
	if _waiting:
		if $tween.is_active():
			$tween.seek($tween.get_runtime())
		
		else:
			_end()

func _end():
	_waiting = false
	_pause = false
	yield(get_tree(), "idle_frame")
	queue_free()

