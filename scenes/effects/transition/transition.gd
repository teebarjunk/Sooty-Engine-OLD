tool
extends Node

signal complete

export(float, 0.0, 1.0) var _time:float = 0.0 setget time
export(float, 0.0, 1.0) var _time_fade:float = 0.1 setget time_fade
export(Texture) var _gradient:Texture setget gradient

onready var _tween:SavableTween = $tween
onready var _image = $image

var reverse:bool = false

func _ready():
	if Global._screenshot:
		var image_tex = ImageTexture.new()
		image_tex.create_from_image(Global._screenshot)
		$image.texture = image_tex
		yield(get_tree(), "idle_frame")
		_set_mat("reverse", reverse)
	fade()

func _args(_args, kwargs={}):
	reverse = kwargs.get("reverse", false)

func _pause_sooty() -> bool:
	return true

func fade(duration=2.0):
	time(0.0)
	$tween.interpolate(self, "_time", 0.0, 1.0, duration)
	$tween.start()
	yield($tween, "tween_all_completed")
	emit_signal("complete")
	queue_free()

func time(v):
	_time = v
	_set_mat("time", v)

func time_fade(v):
	_time_fade = v
	_set_mat("time_fade", v)

func gradient(v):
	_gradient = v
	_set_mat("gradient", v)

func _set_mat(property, value):
	if _image:
		_image.material.set_shader_param(property, value)
