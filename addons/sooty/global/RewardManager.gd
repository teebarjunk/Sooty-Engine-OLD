extends Node

var rewards:Dictionary = {
	r1=RewardInfo.new({unlocked=true}),
	r2=RewardInfo.new()
}

func _ready():
	var _e
	_e = Sooty.connect("collect_persistent", self, "_save_persistent")

func _save_persistent(save, data):
	if save:
		data["rewards"] = DictionaryResource.save_collection(rewards)
	elif "rewards" in data:
		DictionaryResource.load_collection(rewards, data["rewards"])

func _reward(id:String):
	id = UtilStr.to_var(id)
	if id in rewards:
		rewards[id].achieve(id)
