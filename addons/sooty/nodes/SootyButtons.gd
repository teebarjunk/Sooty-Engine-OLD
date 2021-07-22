extends Node
class_name SootyButtons

# useful for maps and clickable scenes

export(String) var parent_chapter:String = ""

func _ready():
	var _e
	for child in get_children():
		if child is BaseButton:
			_e = child.connect("pressed", self, "_pressed", [child.name])

func _pause_sooty():
	return true

func _pressed(id):
	var s:Sooty = get_tree().current_scene
	print(id)
	s.goto("%s %s" % [parent_chapter, id])
	queue_free()
