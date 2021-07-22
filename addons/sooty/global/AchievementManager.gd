extends Node

var achievements:Dictionary = {}

func _ready():
	set_process(false)
	var _e
	_e = Sooty.connect("collect_persistent", self, "_save_persistent")

func _save_persistent(save:bool, data:Dictionary):
	if save:
		data["achievements"] = DictionaryResource.save_collection(achievements)
	elif "achievements" in data:
		DictionaryResource.load_collection(achievements, data["achievements"])

func clear():
	achievements.clear()

func clear_states():
	for k in achievements:
		achievements[k].clear()

func add(id:String, data:Dictionary):
	achievements[id] = AchievementInfo.new(data)

func achieve(id:String, tick:int=1):
	id = UtilStr.to_var(id.strip_edges())
	if id in achievements:
		if achievements[id].progress(tick):
			Sooty.save_persistent()
	else:
		print("No award %s" % [id])

func calculate_totals() -> Dictionary:
	var total = len(achievements)
	var completed = 0
	
	for achievement in achievements.values():
		if achievement.is_complete():
			completed += 1
	
	return { total=total, completed=completed, progress=Util.div(completed, total) }







#
