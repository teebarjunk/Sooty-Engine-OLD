tool
extends TextureRect

#export var texture:Texture
export var corner:Texture

export var wide:float = 64
export var high:float = 32
export var size:float = 8

func _ready():
	connect("item_rect_changed", self, "_rect_changed")

func _rect_changed():
	material.set_shader_param("scale", Vector2(rect_size.x / 64.0, rect_size.y / 64.0))

#
#func _draw():
#	var mid = Vector2(wide, high) * -.5 - Vector2(size *.5, 0)
#
#	for i in 4:
#		draw_set_transform(Vector2(0, 0), PI * (i * .5), Vector2(1, 1))
#		draw_texture_rect(texture, Rect2(mid + Vector2(0, size*.5), Vector2(size, wide-size)), false)
#		draw_texture_rect(corner, Rect2(mid + Vector2(wide, -size*.5), Vector2(size, size)), false)
#
