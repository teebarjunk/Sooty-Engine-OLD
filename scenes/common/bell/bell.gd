extends Node

onready var _tween:Tween = $tween
onready var _backing:Control = $control/backing
onready var _progress_bar:ProgressBar = $control/backing/progress
onready var _icon = $control/backing/icon
onready var l_type = $control/backing/type
onready var l_name = $control/backing/name
onready var l_desc = $control/backing/desc
onready var p_prog = $control/backing/progress

var _pos1:Vector2
var _pos2:Vector2
var _icon_scale:Vector2

func _ready():
	_pos1 = _backing.rect_position
	_pos2 = _backing.rect_position + Vector2(_backing.rect_size.x - 32, 0)
	_icon_scale = _icon.rect_scale
	
	_backing.material = Resources.create_shader_material("blur_screen_lod", {blur=3.0})
	
	l_type.self_modulate = Color.yellowgreen
	l_desc.self_modulate = Color.darkgray
	
	Sooty.connect("hide_ui", self, "_hide_ui")

func _hide_ui(h):
	$control.visible = not h

func _show_message(info):
	_backing.modulate = Color.transparent
	
	Resources.set_fonts(l_type, Config.alert_title_font)
	Resources.set_fonts(l_name, Config.alert_name_font)
	Resources.set_fonts(l_desc, Config.alert_desc_font)
	
	# progress bar
#	var pb:ProgressBar = $backing/progress
	if "progress" in info:
		l_desc.visible = false
		p_prog.visible = true
		p_prog.value = info.progress * p_prog.max_value
		Audio.sound(info.get("sound", "bell"), { pitch=lerp(0.5, 1.5, info.progress) })
	
	else:
		l_desc.visible = true
		p_prog.visible = false
		Audio.sound(info.get("sound", "bell"), { pitch=1.0 })
	
	# set icon
	_icon.rect_scale = Vector2.ZERO
	Resources.set_texture(_icon, info.get("icon", "icon"))
	
	var trans_time = 0.5
	
	l_type.bbcode_text = "[center]" + Sooty.format(info.get("type", "NO_TYPE"))
	l_name.bbcode_text = "[center]" + Sooty.format(info.get("name", "NO_NAME"))
	l_desc.bbcode_text = "[center]" + Sooty.format(info.get("desc", "NO_DESC"))
	
	l_name.modulate = Color.transparent
	l_desc.modulate = Color.transparent
	p_prog.modulate = Color.transparent
	
	var l_type_goal = l_type.rect_position
	var l_name_goal = l_name.rect_position
	var l_desc_goal = l_desc.rect_position
	l_type.rect_position.y = _backing.rect_size.y * .5 - l_type.rect_size.y * .5
	l_name.rect_position -= Vector2(24.0, 0.0)
	l_desc.rect_position += Vector2(24.0, 0.0)
	
	# move in
	var _e
	_e = _tween.interpolate_property(_backing, "modulate", Color.transparent, Color.white, trans_time)
	_e = _tween.interpolate_property(_backing, "rect_position", _pos2, _pos1, trans_time, Tween.TRANS_BACK)
	var wait = trans_time
	
	# move type name up
	_e = _tween.interpolate_property(l_type, "rect_position", l_type.rect_position, l_type_goal, .25, Tween.TRANS_BACK, Tween.EASE_IN_OUT, wait)
	# scale icon in
	_e = _tween.interpolate_property(_icon, "rect_scale", Vector2.ZERO, _icon_scale, .5, Tween.TRANS_BACK, Tween.EASE_OUT, wait)
	wait += .25
	
	# fade in name and desc
	_e = _tween.interpolate_property(l_name, "modulate", Color.transparent, Color.white, .25, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, wait)
	_e = _tween.interpolate_property(l_name, "rect_position", l_name.rect_position, l_name_goal, .25, Tween.TRANS_BACK, Tween.EASE_OUT, wait)
	_e = _tween.interpolate_property(l_desc, "modulate", Color.transparent, Color.white, .25, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, wait)
	_e = _tween.interpolate_property(l_desc, "rect_position", l_desc.rect_position, l_desc_goal, .25, Tween.TRANS_BACK, Tween.EASE_OUT, wait)
	
	_e = _tween.interpolate_property(p_prog, "modulate", Color.transparent, Color.white, .25, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, wait)
	_e = _tween.interpolate_property(p_prog, "value", 0, p_prog.value, 1.0, Tween.TRANS_BACK, Tween.EASE_IN_OUT, wait)
	
	wait += .25
	wait += 2.0
	
	# fade icon out a tiny bit before
	_e = _tween.interpolate_property(_icon, "rect_scale", _icon_scale, Vector2.ZERO, .5, Tween.TRANS_BACK, Tween.EASE_IN, wait)
	wait += .5
	
	# out
	_e = _tween.interpolate_property(_backing, "modulate", Color.white, Color.transparent, trans_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, wait)
	_e = _tween.interpolate_property(_backing, "rect_position", _pos1, _pos2, trans_time, Tween.TRANS_BACK, Tween.EASE_IN_OUT, wait)
	_e = _tween.start()
	
	yield(_tween, "tween_all_completed")
	queue_free()

func _process(_delta):
#	$backing.rect_rotation = cos(OS.get_ticks_msec() * .0025) * 1.0
	_icon.rect_rotation = sin(OS.get_ticks_msec() * .005) * 5.0


