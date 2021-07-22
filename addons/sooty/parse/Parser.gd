tool
extends Resource
class_name Parser, "res://addons/sooty/sooty_icon.png"

export(String, FILE, GLOBAL, "*.md") var path_to_markdown:String = ""
export(PoolStringArray) var langs:PoolStringArray = PoolStringArray(["en"])

export(String, MULTILINE) var source_code:String = ""

export(Dictionary) var resource_list:Dictionary = {}

#func _get_property_list():
#	return [
#
#	]

var _last_modified:String = ""
var meta:Dictionary = {}
var chapters:Array = []
var internal:Array = []
var chapter_paths:Dictionary = {}

var config:Dictionary = {}
var chars:Dictionary = {}
var quests:Dictionary = {}
var credits:Dictionary = {}
var achievements:Dictionary = {}
var chars_upper:Dictionary = {}
var scripts = []

func _get_modified_time() -> String:
	if UtilFile.exists(path_to_markdown):
		return UtilFile.mtime(path_to_markdown)
	else:
		return _last_modified

func _was_modified() -> bool:
	return OS.is_debug_build() and not UtilGodot.is_html() and _get_modified_time() != _last_modified

func update_resource_list():
	Resources._update()
	resource_list = Resources._save_collection()
	
func parse(p=path_to_markdown):
	if not UtilFile.exists(p):
		push_error("no file at %s" % [p])
		return
		
	_last_modified = _get_modified_time()
	
	update_resource_list()
	
	# clear old data
	for item in [chapters, internal, chapter_paths,
		config, chars, quests, achievements, chars_upper, scripts]:
		item.clear()
	
	path_to_markdown = p
	var t1 = OS.get_system_time_msecs()
	var md = ParseMD.new(p)
	var t2 = OS.get_system_time_msecs()
	chapters = md.chapters
	internal = md.internal
	meta = md.meta
	
	for chapter in md.internal:
		var k = "_PROCINT_%s" % [chapter.path[0]]
		if has_method(k):
			call(k, chapter)
		else:
			push_error("no internal processor for %s." % [chapter.path[0]])
	
	# collect ids
	for chapter in md.chapters:
		chapter_paths[chapter.path] = UtilStr.to_var(chapter.path)
	
	# 
	for chapter in md.chapters:
		_PROC_CHAPTER(chapter)
	
	var t3 = OS.get_system_time_msecs()
	print("parsed in %s msec" % [t3 - t1])

func _generated_script_path() -> String:
	return UtilFile.replace_extension(path_to_markdown, "sooty.gd")

func update_script(save_to_file:bool=true):
	parse()
	var script_generator = load("res://addons/sooty/parse/GenerateScript.gd").new(self)
	if save_to_file:
		UtilFile.save_text(_generated_script_path(), script_generator.text)
	source_code = script_generator.text
	return script_generator.text

func _find_chapter_id(name) -> String:
	name = UtilStr.to_var(name)
	
	if [name] in chapter_paths:
		return chapter_paths[[name]]
	
	for c in chapter_paths:
		if len(c) > 1 and c[-1] == name:
			return chapter_paths[c]
	
	for c in chapter_paths:
		if PoolStringArray(c).join(" ") == name:
			return chapter_paths[c]
	
	for c in chapter_paths:
		if len(c) > 1 and c[-1].begins_with(name):
			return c
	
	for c in chapter_paths:
		if PoolStringArray(c).join(" ").begins_with(name):
			return c
	
	return "???"

func _strip_bbcode(s:String) -> String:
	var out = ""
	var inside = false
	for c in s:
		if c == "[": inside = true
		elif c == "]": inside = false
		elif not inside: out += c
	return out

func _replace_html(s:String) -> String:
	return UtilStr.replace_between(s, "<", ">", funcref(self, "_html_tag"))

var _html_font = {}
func _html_tag(s:String):
	var args = Array(s.split(" "))
	var type = args.pop_front()
	if len(args) > 0:
		var d = {}
		for arg in args:
			arg = arg.split("=", true, 1)
			d[arg[0]] = arg[1].replace("\"", "")
		args = d
	
	var out = ""
	match type:
		"a":
			out = "[url=%s]" % [args.href]
		"/a":
			out = "[/url]"
		
		"font":
			for k in args:
				_html_font[k] = true
				out += "[%s=%s]" % [k, args[k]]
		"/font": 
			for k in _html_font:
				out += "[/%s]" % [k]
	return out

func _replace_markdown(s:String) -> String:
	s = s.replace("\\*", "%%")
	s = _md_to_bbcode(s, "***", "[b][i]", "[/i][/b]")
	s = _md_to_bbcode(s, "**", "[b]", "[/b]")
	s = _md_to_bbcode(s, "*", "[i]", "[/i]")
	s = _md_to_bbcode(s, "~~", "[s]", "[/s]")
	s = s.replace("%%", "*")
	return s

func _fix_text(s:String) -> String:
	s = _replace_markdown(s)
	s = _replace_html(s)
	s = _fix_color(s)
	s = _replace_char_names(s)
	return s

func _fix_color(s):
	if "[color=" in s:
		s = UtilStr.replace_between(s, "[color=", "]", funcref(self, "__fix_color"))
	return s

func __fix_color(clr):
	if clr.begins_with("#"):
		return "[color=%s]" % [clr]
	else:
		return "[color=#%s]" % [ColorN(clr).to_html()]

func _md_to_bbcode(s:String, tag:String, head:String, tail:String):
	while true:
		var a = s.find(tag)
		if a == -1: break
		var b = s.find(tag, a+len(tag))
		if b == -1: break
		var inner:String = Util.part(s, a+len(tag), b)
		s = Util.part(s, 0, a) + head + inner + tail + Util.part(s, b+len(tag))
	return s

var _processed_chapter:Dictionary
func _PROC_CHAPTER(chapter):
	_processed_chapter = chapter
	_pp_steps(chapter)

func _pp_steps(d):
	UtilDict.dig(d, funcref(self, "_replace_then"))
	UtilDict.dig(d, funcref(self, "_replace_tags"))

func _replace_then(d):
	if "T" in d:
		match d["T"]:
			"rand":
				for i in len(d.rand):
					d.rand[i] = _process_steps(d.rand[i])
				
			"-":
				if "->" in d.text:
					var p = d.text.split("->", true, 1)
					d.text = p[0].strip_edges()
					var goto = p[1].strip_edges()
					if not goto:
						goto = _processed_chapter.next
					d.then.append(ParserSteps.GOTO(goto))
				
				if not d.then:
					d.erase("then")
			
	
	if "then" in d:
		d.then = _process_steps(d.then)

func _process_steps(steps:Array):
	var out = []
	for step in steps:
		match step["T"]:
			"text": ParserCommon.append(out, _TEXT(step))
			_: out.append(step)
	return out

func _replace_tags(d):
	if "T" in d:
		match d["T"]:
			"goto":
				var goto = _find_chapter_id(d.goto)
				d.goto = goto
			
			"call":
				var call = _find_chapter_id(d.call)
				d.call = call
	
	if "text" in d:
#		var text = _replace_char_names(d.text)
		var text = _fix_text(d.text)
		d.text = text

func _TEXT(d):
	if d.text.begins_with("INT. ") or d.text.begins_with("EXT. "):
		var scene = UtilStr.to_var(d.text.substr(4).strip_edges())
		return ParserSteps.EVAL("scene %s" % [scene], [])
	
	else:
		var s = _get_text_info(d.text, "")
		var out = [s]
		var last = s.from
		if "list" in d:
			d["T"] = "text"
			for ss in d.list:
				var line = _get_text_info(ss.text, last)
				line.erase("then")
				out.append(line)
				last = line.from
			d.erase("list")
		d.erase("then")
		return out

func _get_text_info(text:String, last) -> Dictionary:
	var old_text = text
	var from = last
	var args = null
	var kwargs = null
	var printer = ""
	
	if text.begins_with("[["):
		var p = text.split("]]", true, 1)
		printer = p[0].substr(2).strip_edges()
		text = p[1].strip_edges()

	if text.begins_with("(") or text.ends_with(")"):
		from = ""
		if text.begins_with("("):
			text = text.substr(1)
		
		if text.ends_with(")"):
			text = text.substr(0, len(text)-1)
	
	elif ":" in text:
		var p = text.split(":", true, 1)
		from = p[0].strip_edges()
		text = p[1].strip_edges()
		
		if "(" in from:
			p = from.split("(", true, 1)
			from = p[0].strip_edges()
			var ak = ParseKwargs.get_args_and_kwargs(p[1].rsplit(")", true, 1)[0].strip_edges())
			args = ak.args
			kwargs = ak.kwargs
	
	from = _get_char_name(from)
	
	var t = { "T": "text", "from": from, "text": text, "A": args, "K": kwargs, "P": printer }
	return t

func _get_char_name(name):
	if not name:
		return ""
	
	if name.begins_with('"'):
		return name.substr(1, len(name)-2)
		
	else:
		var var_name = UtilStr.to_var(name)
		if var_name in chars:
			return var_name
			
		# using innitials
		for k in chars:
			if k.begins_with(var_name):
				return k
				
	return name

# Hey JOHN, what's up?		-> 		Hey {john}, what's up?
# WHAT IS MARY DOING!?		->		WHAT IS {mary|upper} doing!?
func _replace_char_names(text:String):
	var words = text.split(" ")
	for i in len(words):
		var word = words[i]
		for name in chars_upper:
			if name in word:
				if i > 0 and UtilStr.is_capitalized(words[i-1][-1]):
					word.replace(name, "{%s|upper}" % [chars_upper[name]])
				else:
					words[i] = word.replace(name, "{%s}" % [chars_upper[name]])
#			if word == name:
##				if (i > 0 and UtilStr.is_capitalized(words[i-1])) or (i <= len(words)+1 and UtilStr.is_capitalized(words[i+1])):
##					words[i] = "{%s|upper}" % [chars_upper[name]]
##				else:
#				words[i] = "{C.%s}" % [chars_upper[name]]
#				break
#
#			elif word.begins_with(name):
#				if (i > 0 and UtilStr.is_capitalized(words[i-1])):
#					words[i] = word.replace(name, "{C.%s|upper}" % [chars_upper[name]])
#				else:
#					words[i] = word.replace(name, "{C.%s}" % [chars_upper[name]])
#				break

	return words.join(" ")

func _PROCINT_stats(d): pass
func _PROCINT_locations(d): pass

func _PROCINT_config(d:Dictionary):
	for line in d.then:
		match line["T"]:
			"text": UtilDict.merge(config, ParseKwargs.tupleize(line.text))
			"eval": UtilDict.merge(config, ParseKwargs.eval_to_tupleize(line.eval))

# CHARACTERS
func _PROCINT_characters(d:Dictionary):
	if len(d.path_named) == 3:
		var name = d.path_named[-1]
		var var_name = UtilStr.to_var(name)
		var data = { name=name }
		for line in d.then:
			match line["T"]:
				"?":
					data["desc"] = line.text
		ParserCommon.merge(chars, var_name, data)
	
	else:
		for line in d.then:
			match line["T"]:
				"table":
					for row in line.table:
						if "name" in row:
							var var_name = UtilStr.to_var(row.name)
							ParserCommon.merge(chars, var_name, row)
				
				"text":
					var p = line.text.split(" - ")
					
					var name = p[0].strip_edges()
					name = _fix_text(name)
					
					var desc = "" if len(p) == 1 else p[1].strip_edges()
					desc = _fix_text(desc)
					
					var name_stripped = _strip_bbcode(name)
					var form = name.replace(name_stripped, "%s")
					name = name_stripped
					var var_name = UtilStr.to_var(name)
					chars_upper[name.to_upper()] = var_name
					var info = { name=name, desc=desc, form=form }
					match len(d.path_named):
						2: info["type"] = d.path[1]
					ParserCommon.merge(chars, var_name, info)

# ACHIEVEMENTS
func _PROCINT_achievements(d:Dictionary):
	for line in d.then:
#		UtilDict.printd(line)
		match line["T"]:
			"text":
				var p = line.text.split(" - ")
				var name = p[0].strip_edges()
				var desc = p[1].strip_edges()
				var var_name = UtilStr.to_var(name)
				name = _replace_char_names(name)
				desc = _replace_char_names(desc)
				achievements[var_name] = {name=name, desc=desc}
				
#				for subline in line.get("then", []):
#					match subline["T"]:
#						"data": UtilDict.merge(achievements[var_name], subline.data)
				
				if "list" in line:
					for list_line in line.list:
						match list_line["T"]:
							"data": UtilDict.merge(achievements[var_name], list_line.data)
							"text": UtilDict.merge(achievements[var_name], ParseKwargs.tupleize(list_line.text))
							"eval": UtilDict.merge(achievements[var_name], ParseKwargs.eval_to_tupleize(list_line.eval))

# GOALS
func _PROCINT_quests(d:Dictionary):
	var quest = {}
	for line in d.then:
		match line["T"]:
			"list":
				quest.name = d.name
				quest.desc = line.text
				quest.goals = {}
				for item in line.list:
					var gid = UtilStr.to_var(item.text)
					var gdata = { "name": item.text }
					quest.goals[gid] = gdata
					for subitem in item.get("then", []):
						match subitem["T"]:
							"data": UtilDict.merge(gdata, subitem.data)
							"text": gdata.desc = subitem.text
	
	if quest:
		quests[d.id] = quest

func _PROCINT_credits(d:Dictionary):
	for line in d.then:
		match line["T"]:
			"list":
				credits[line.text] = []
				for list_line in line.list:
					var link = ParseMD.get_link(list_line.text)
					var text = link.text
					link = link.link
					var item = ""
					if " - " in text:
						var p = text.split(" - ", true, 1)
						item = p[0].strip_edges()
						text = p[1].strip_edges()
					credits[line.text].append( { name=text, link=link, item=item })


#
#

