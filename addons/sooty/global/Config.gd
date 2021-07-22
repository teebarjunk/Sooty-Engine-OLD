tool
extends Node

# Main Menu
var menu_image:String = "menu_image"	# image shown when game starts
var menu_music:String = "menu_music"	# music played when game starts
var menu_title_font:String = "eb_garamond_64"
var menu_author_font:String = "eb_garamond_24"
var menu_version_font:String = "eb_garamond_16"

# Menu
var options_font:String = "open_sans_24"

# Text
var name_font:String = "open_sans_24"
var caption_font:String = "open_sans_24"

# Alert/Bell
var alert_title_font:String = "open_sans_24" 
var alert_name_font:String = "open_sans_16" 
var alert_desc_font:String = "open_sans_16" 

# Window
var screen_size:Vector2 setget set_screen_size, get_screen_size
var screen_width:int setget set_screen_width, get_screen_width
var screen_height:int setget set_screen_height, get_screen_height

func get_screen_size(): return OS.get_window_size()
func set_screen_size(s):
	OS.set_window_size(s)
	ProjectSettings.set_setting("display/window/size/width", s.x)
	ProjectSettings.set_setting("display/window/size/height", s.y)

func get_screen_width(): ProjectSettings.get_setting("display/window/size/width")
func set_screen_width(s):
	OS.set_window_size(Vector2(s, OS.get_window_size().y))
	ProjectSettings.set_setting("display/window/size/width", s)

func get_screen_height(): ProjectSettings.get_setting("display/window/size/height")
func set_screen_height(s):
	OS.set_window_size(Vector2(OS.get_window_size().x, s))
	ProjectSettings.set_setting("display/window/size/height", s)
