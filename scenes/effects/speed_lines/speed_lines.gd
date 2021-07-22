extends Node

func _ready():
	set_viewxy()

func set_viewxy(x=0.5, y=0.5):
	$particles.position = get_viewport().size * Vector2(x, y)

func remove():
#	$particles.emitting = false
	queue_free()
