tool
extends Node

export(Color) var _color:Color = Color.black setget color

export(float, 0.0, 3.0) var _size:float = 1.0 setget size
export(float, 0.0, 1.0) var _size_ratio:float = 0.0 setget size_ratio
export(float, -3.141, 3.141) var _rotation:float = 0.0 setget rotation

export(float, 0.0, 1.0) var _open:float = 0.5 setget open
export(float, 0.0, 1.0) var _open_smoothing:float = 0.5 setget open_smoothing

func _ready():
	_update_rect()
	var _e = $image.connect("item_rect_changed", self, "_update_rect")

func _update_rect():
	_set_mat("rect", $image.rect_size)

func color(v):
	_color = v
	$image.modulate = v

func size(v):
	_size = v
	_set_mat("size", v)

func size_ratio(v):
	_size_ratio = v
	_set_mat("size_ratio", v)

func rotation(v):
	_rotation = v
	_set_mat("rotation", v)

func open(v):
	_open = v
	_set_mat("open", v)

func open_smoothing(v):
	_open_smoothing = v
	_set_mat("open_smoothing", v)

func _set_mat(property, value):
	$image.material.set_shader_param(property, value)



#
