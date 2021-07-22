tool
extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("item_rect_changed", self, "_rect_changed")

func _rect_changed():
	material.set_shader_param("pos", rect_position)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
