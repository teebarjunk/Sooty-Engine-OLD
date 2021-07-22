tool
extends Node

export(float, 0.0, 4.0) var _gamma:float = 1.0 setget gamma
export(float, 0.0, 10.0) var _contrast:float = 1.0 setget contrast
export(float, 0.0, 10.0) var _saturation:float = 1.0 setget saturation
export(float, 0.0, 10.0) var _brightness:float = 1.0 setget brightness
export(float, -10.0, 10.0) var _red:float = 1.0 setget red
export(float, -10.0, 10.0) var _green:float = 1.0 setget green
export(float, -10.0, 10.0) var _blue:float = 1.0 setget blue

func gamma(s):
	_gamma = s
	_set_shader("gamma", s)

func contrast(s):
	_contrast = s
	_set_shader("contrast", s)

func saturation(s):
	_saturation = s
	_set_shader("saturation", s)

func brightness(s):
	_brightness = s
	_set_shader("brightness", s)

func red(s):
	_red = s
	_set_shader("red", s)

func blue(s):
	_blue = s
	_set_shader("blue", s)

func green(s):
	_green = s
	_set_shader("green", s)

func _set_shader(property, value):
	_get_material().set_shader_param(property, value)

func _get_material() -> ShaderMaterial:
	if not $image.material:
		var mat = Resources.create_shader_material("screen")
		$image.set_material(mat)
		return mat
	return $image.material as ShaderMaterial
