tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("Parser", "Resource",
		preload("res://addons/sooty/parse/Parser.gd"),
		preload("res://addons/sooty/sooty_icon.png"))

func _exit_tree():
	remove_custom_type("Parser")
