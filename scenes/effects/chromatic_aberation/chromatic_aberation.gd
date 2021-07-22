tool
extends Node

const _SHADER_PATH:String = "res://shaders/chromatic_aberation.shader"

export(float, -0.1, 0.1) var scale:float = 0.05 setget set_scale
export(float, 0.5, 4.0) var power:float = 2.0 setget set_power

func set_scale(s):
	scale = s
	_set_shader("scale", s)

func set_power(s):
	power = s
	_set_shader("power", s)

func _set_shader(property, value):
	_get_material().set_shader_param(property, value)

func _get_material() -> ShaderMaterial:
	if not $image.material:
		var mat = ShaderMaterial.new()
		mat.shader = load(_SHADER_PATH)
		$image.set_material(mat)
		return mat
	return $image.material as ShaderMaterial
