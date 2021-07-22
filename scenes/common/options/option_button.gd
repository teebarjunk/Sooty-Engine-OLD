extends Button

export var color_default:Color = Color(0.8, 0.8, 0.8, 1.0)
export var color_highlight:Color = Color(0.0, 0.5, 0.75, 1.0)

onready var tween:= $tween
onready var l_text:= $text

var pos:Vector2

func _ready():
	Resources.set_fonts(l_text, Config.options_font)
	l_text.modulate = Color(1, 1, 1, .5)
	self_modulate = color_default
	var _e
	_e = connect("mouse_entered", self, "_mouse_over", [true])
	_e = connect("mouse_exited", self, "_mouse_over", [false])

func set_text(t):
	$text.bbcode_text = "[center]%s[/center]" % [t]

func _mouse_over(h):
#	._mouse_over(h)
	tween.stop_all()
	if h:
		tween.interpolate_property(l_text, "modulate", l_text.modulate, Color.white, 0.125)
		tween.interpolate_property(self, "self_modulate", self_modulate, color_highlight, 0.125)
	else:
		tween.interpolate_property(l_text, "modulate", l_text.modulate, Color(1, 1, 1, .5), 0.125)
		tween.interpolate_property(self, "self_modulate", self_modulate, color_default, 0.125)
	tween.start()







#
