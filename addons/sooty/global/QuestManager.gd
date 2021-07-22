extends Node

var quests:Dictionary = {}

func clear():
	quests.clear()

func clear_states():
	for quest in quests.values():
		quest.clear()

func add(id:String, data:Dictionary):
	quests[id] = QuestInfo.new(data)

func _ready():
	var _e = Sooty.connect("collect_save_info", self, "_collect_save_info")

func tick(id:String, tick:int):
	id = UtilStr.to_var(id)
	if id in quests:
		quests[id].tick(tick)

func _collect_save_info(info:Dictionary):
	var toll = len(quests)
	var tick = 0
	var max_toll = 0
	var max_tick = 0
	for quest in quests.values():
		if quest.is_complete():
			tick += 1
		var tt = quest.get_tick_and_toll()
		max_tick += tt.tick
		max_toll += tt.toll
	info["quests"] = {tick=tick, toll=toll, max_tick=max_tick, max_toll=max_toll}
