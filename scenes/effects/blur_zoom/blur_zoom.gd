tool
extends Node

export var center:Vector2 = Vector2(.5, .5) setget set_center
export(float, -1.0, 1.0) var power:float = 0.5 setget set_power

func set_center(v):
	center = v
	if $ColorRect:
		($ColorRect.material as ShaderMaterial).set_shader_param("center", center)
	
func set_power(v):
	power = v
	if $ColorRect:
		($ColorRect.material as ShaderMaterial).set_shader_param("power", power)

#func _process(delta):
#	var p = get_viewport().get_mouse_position() / get_viewport().size
#	print(p)
#	set_center(p)
#
#	set_power(sin(OS.get_system_time_msecs()*.001) * .25)
