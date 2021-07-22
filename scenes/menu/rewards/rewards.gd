extends Node

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	get_tree().paused = true
	
	var prefab = $backing/scroll/buttons/button
	var parent = $backing/scroll/buttons
	parent.remove_child(prefab)
	
	for id in RewardManager.rewards:
		var reward:RewardInfo = RewardManager.rewards[id]
		var button = prefab.duplicate()
		button.disabled = not reward._unlocked
		button.set_name(id)
		parent.add_child(button)

func _exit_tree():
	get_tree().paused = false
