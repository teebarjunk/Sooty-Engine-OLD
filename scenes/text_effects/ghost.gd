tool
extends Node2D

export var font:DynamicFont
export var text:String = ""

func _draw():
	if font == null:
		font = load(Resources.font_path("eb garamond"))
	
	var offset = -font.get_string_size(text) * .5
	offset.y += font.size
	draw_string(font, offset, text)
