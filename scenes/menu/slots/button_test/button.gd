extends Control

var hovered = false
var selected = false
var skew = Vector2(0, 0)
var zoom = 0.0

export var zoom_scale = 1.0
export(float, .125, .9) var smooth_speed:float = .5

func _ready():
	var mat = ShaderMaterial.new()
	mat.set_shader(load("res://scenes/menu/slots/button_test/button.shader"))
	set_material(mat)
	
	var _e
	_e = connect("mouse_entered", self, "_mouse_over", [true])
	_e = connect("mouse_exited", self, "_mouse_over", [false])

func _mouse_over(h):
	hovered = h

func _process(delta):
	var mp = get_global_mouse_position()
	var rect = get_global_rect()
	
	if hovered:
		skew = (Util.clamp01((mp - rect.position) / rect.size) - Vector2(.5, .5)) * .25
		zoom = 1.0 + 1.0 * zoom_scale
	
	elif selected:
		var t = OS.get_ticks_msec() * delta * .01
		skew = Vector2(sin(t), cos(t)) * .125
		zoom = 1.0 + 0.5 * zoom_scale
	
	else:
		skew = Vector2(0, 0)
		zoom = 1.0
	
	if material and material.shader:
		var s = material.get_shader_param("skew")
		if s != null:
			material.set_shader_param("skew", lerp(s, skew, smooth_speed))
		
		var z = material.get_shader_param("zoom")
		if z != null:
			material.set_shader_param("zoom", lerp(z, zoom, smooth_speed))





#
