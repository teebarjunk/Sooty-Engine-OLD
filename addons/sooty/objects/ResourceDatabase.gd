tool
extends DictionaryResource

#static func _get_tool_buttons(): return ["update"]

func _init(d=null).(d):
	pass

func update():
	Resources._update()
	Resources.save_collection()
