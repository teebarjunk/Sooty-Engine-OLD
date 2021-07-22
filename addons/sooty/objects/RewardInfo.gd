tool
extends DictionaryResource
class_name RewardInfo

var unlocked:bool = false

func _init(d=null).(d):
	if d:
		unlocked = d.get("unlocked", false)

func unlock():
	if not unlocked:
		unlocked = true
		var s = Global.get_tree().current_scene
		s.bell("", {
			type="Unlock"
		})
		Global.save()
