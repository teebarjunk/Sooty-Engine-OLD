tool

var text = ""
var parser:Parser
#var created_chapters = []

func _init(p:Parser):
	parser = p
	text = "extends %s # %s\n" % ["SootyBaseScript", "version 0.1"]
	
	_print_code_and_vars()
	_print_chars()
	_print_init()
	_print_chapters()

func _chapter_path_to_func(path) -> String:
	return UtilStr.to_var(UtilStr.join(path, " "))

const EMPTY_STRING:String = "\"\""

func _step_to_func(step:Dictionary) -> String:
	var call
	var args = []
	
	match step["T"]:
		"@":
			call = "_node"
			args = [var2str(step["@"]), EMPTY_STRING, var2str(step["A"]), JSON.print(step["K"]), var2str(step["eval"])]
		"text":
			var type = EMPTY_STRING
			if "P" in step and step["P"]:
				type = "\"printer_%s\"" % [step.P]
#			print(type)
			call = "_node"
			args = ["\"text\"", type, var2str([step.get("from"), step.text])]
		"list":
			call = "_node"
			args = [var2str("list"), EMPTY_STRING, [
				var2str(step.get("from")),
				var2str(step.get("text")),
				JSON.print(step.list)]]
		"rand":
			call = "_rand"
			args = [JSON.print(step.rand)]
		"goto":
			call = "_stack_goto"
			args = [var2str(_chapter_path_to_func(step["goto"]))]
		"call":
			call = "_stack_call"
			args = [var2str(_chapter_path_to_func(step["call"]))]
		"stop":
			call = "_stop"
			
		"eval":
			call = "_eval"
			args = JSON.print([Util.array(step.eval)])
		"clear": 
			call = "_clear_nodes"
		"if":
			call = "_if"
			args = [var2str(step.test), var2str(step.then), JSON.print(step.else)]
		_:
			call = "???"
			args = JSON.print(step)
	
	call = var2str(call)
	var space = " ".repeat(20 - len(call))
	return "[%s,%s%s]" % [call, space, args]


func _print_code_and_vars():
	for script in parser.scripts:
		match script["T"]:
			"code":
				text += script.code + "\n"
			
			"data":
				for k in script.data:
					var v = script.data[k]
					text += "export var %s:%s = %s\n" % [k, UtilGodot.type_name(v), var2str(v)]

func _print_init():
	text += "func _init():\n"
	text += "\t_reset_everything()\n"
	
	text += "func _reset_everything():\n"
	_print_meta()
	_print_config()
	_print_achievements()
	_print_quests()

func _print_meta():
	text += "\tSooty.meta = %s\n" % [JSON.print(parser.meta)]

func _print_config():
	for k in parser.config:
		text += "\tConfig.%s = %s\n" % [k, var2str(parser.config[k])]

func _print_achievements():
	text += "\tAchievementManager.clear()\n"
	for k in parser.achievements:
		text += "\tAchievementManager.add(\"%s\", %s)\n" % [k, JSON.print(parser.achievements[k])]

func _print_quests():
	text += "\tQuestManager.clear()\n"
	for k in parser.quests:
		text += "\tQuestManager.add(\"%s\", %s)\n" % [k, JSON.print(parser.quests[k])]

func _print_chars():
	text += "const PROP_CHARACTERS:Array = [\"%s\"]\n" % [PoolStringArray(parser.chars.keys()).join("\", \"")]
	text += "# %s\n" % [len(parser.chars)]
	for ch in parser.chars:
		text += "var %s:CharacterInfo = CharacterInfo.new(%s)\n" % [ch, JSON.print(parser.chars[ch])]
		
#	text += "var C:Dictionary = {\n"
#	for c in parser.chars:
#		text += "\t\"%s\": CharacterInfo.new(%s),\n" % [c, JSON.print(parser.chars[c])]
#	text += "}\n"

func _print_chapters():
	var if_count = 0
	var menu_count = 0
	var rand_count = 0
	var chaps = {}
	
	for chapter in parser.chapters:
		for step in chapter.then:
			
			if step["T"] == "if":
				var path = chapter.path.duplicate()
				path.append("if%s" % [if_count])
				if_count += 1
				path = _chapter_path_to_func(path)
				chaps[path] = step.then
				step.then = path
				
				for item in step.else:
					path = chapter.path.duplicate()
					path.append("if%s" % [if_count])
					if_count += 1
					path = _chapter_path_to_func(path)
					chaps[path] = item.then
					item.then = path
					item.erase("T")

			elif step["T"] == "list":
				for item in step.list:
					if "then" in item:
						var path = chapter.path.duplicate()
						path.append("menu%s" % [menu_count])
						menu_count += 1
						path = _chapter_path_to_func(path)
						chaps[path] = item.then
						item.then = path
					item.erase("T")
			
			elif step["T"] == "rand":
				for i in len(step.rand):
					var path = chapter.path.duplicate()
					path.append("rand%s" % [rand_count])
					rand_count += 1
					path = _chapter_path_to_func(path)
					chaps[path] = step.rand[i]
					step.rand[i] = path
			
			chaps[_chapter_path_to_func(chapter.path)] = chapter.then
	
	text += "const CHAPTERS:Dictionary = {\n"
	for cid in chaps:
		text += "\t\"%s\": [\n" % [cid]
		for i in len(chaps[cid]):
			var step = chaps[cid][i]
#			print(">>>", step)
			text += "\t\t%s" % [_step_to_func(step)]
			if i == len(chaps[cid])-1:
				text += "\n"
			else:
				text += ",\n"
		text += "\t],\n"
	text += "}\n"

func _tab_lines(s:String):
	return s.split("\n").join("\n\t")
	
	
	
	
#
