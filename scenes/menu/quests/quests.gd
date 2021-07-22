extends Node

var p_subgoal:Node
var p_subgoal_parent:Node

var goal_buttons:Dictionary = {}

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	get_tree().paused = true
	
	# button prefab
	var p_button = $backing/panel/l_scroll/goal_list/goal_button
	var p_button_parent = p_button.get_parent()
	p_button_parent.remove_child(p_button)
	
	# subgoal prefab
	p_subgoal = $backing/panel/r_scroll/info/subgoal_list/subgoal
	p_subgoal_parent = p_subgoal.get_parent()
	p_subgoal_parent.remove_child(p_subgoal)
	
	var sooty:Sooty = get_parent()
	
	var quests = sooty.quests.values()
	quests = DateTime.new().sort(quests, "last_update")
	
	for quest in quests:
		var id = UtilStr.to_var(quest.name)
		quest = quest as QuestInfo
#		var quest:QuestInfo = sooty.quests[id]
		var button:Button = p_button.duplicate()
		goal_buttons[id] = button
		
		if quest.is_complete():
			button.modulate = Color.greenyellow
			button.set_button_icon(load(Resources.image_path("icon checkmark")))
		
		var _e = button.connect("pressed", self, "_select_quest", [id])
		button.set_text(quest.name)
		p_button_parent.add_child(button)
	
	# select most recently modified
	_select_quest(UtilStr.to_var(quests[0].name))

func _exit_tree():
	get_tree().paused = false

func _unhandled_key_input(event):
	if event.pressed and event.scancode == KEY_G:
		queue_free()

func _select_quest(id:String):
	var sooty:Sooty = get_parent()
	var quest:QuestInfo = sooty.quests[id]
	var t_name = $backing/panel/r_scroll/info/name
	var t_desc = $backing/panel/r_scroll/info/desc
	t_name.bbcode_text = quest.name
	t_desc.bbcode_text = quest.desc
	
	# clear old goals
	for child in p_subgoal_parent.get_children():
		p_subgoal_parent.remove_child(child)
		child.queue_free()
	
	# create new ones
	for gid in quest.goals:
		var goal:QuestInfo.Goal = quest.goals[gid]
		
		if not quest.has_requirements(gid):
			continue
		
		var prop = p_subgoal.duplicate()
		p_subgoal_parent.add_child(prop)
		
		var p_check = prop.get_node("properties/check")
		var p_name = prop.get_node("properties/text/name")
		var p_desc = prop.get_node("properties/text/desc")
		
		if goal.is_complete():
			p_check.modulate = Color.greenyellow
			p_check.texture = Resources.load_texture("icon check")
#			p_check.pressed = goal.is_complete()
		else:
			p_check.modulate = Color(1, 1, 1, 0.5)
			p_check.texture = Resources.load_texture("icon stop")
		
		if goal.toll > 1:
			p_name.bbcode_text = "%s (%s/%s)" % [goal.name, goal.tick, goal.toll]
		
		else:
			p_name.bbcode_text = goal.name
		
		p_desc.bbcode_text = goal.desc
	
	
#
