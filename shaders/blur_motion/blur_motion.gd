tool
extends Control

export var velocity:Vector2 = Vector2.ZERO setget set_velocity, get_velocity
export(float, 0.0, 32.0) var power:float = 0.0 setget set_power, get_power
export(float, -3.141, 3.141) var angle:float = 0.0 setget set_angle, get_angle

func get_velocity(): return velocity
func set_velocity(v):
	velocity = v
	power = velocity.length()
	angle = velocity.angle()
	material.set_shader_param("velocity", velocity)

func get_power(): return power
func set_power(v):
	power = v
	velocity = Vector2(cos(angle), sin(angle)) * power
	material.set_shader_param("velocity", velocity)

func get_angle(): return angle
func set_angle(v):
	angle = v
	velocity = Vector2(cos(angle), sin(angle)) * power
	material.set_shader_param("velocity", velocity)
