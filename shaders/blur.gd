tool
extends Node

const _SHADER_PATH:String = "res://shaders/blur_screen_gauss.shader"

export(float, 1.0, 32.0) var spread:float = 16.0 setget set_spread
export(float, 1.0, 32.0) var spreadx:float = 16.0 setget set_spreadx
export(float, 1.0, 32.0) var spready:float = 16.0 setget set_spready

onready var tween:Tween = $tween
onready var image:ColorRect = $layer

func set_spread(s):
	spread = s
	self.spreadx = s
	self.spready = s

func set_spreadx(s):
	spreadx = s
	_get_material().set_shader_param("spreadx", s)
	
func set_spready(s):
	spready = s
	_get_material().set_shader_param("spready", s)

func _get_material() -> ShaderMaterial:
	if not image.material:
		var mat = ShaderMaterial.new()
		mat.shader = load(_SHADER_PATH)
		image.set_material(mat)
		return mat
	return image.material as ShaderMaterial
