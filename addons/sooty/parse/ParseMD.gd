tool
class_name ParseMD

var meta:Dictionary = {}
var internal:Array = []
var chapters:Array = []

static func get_link(text:String):
	if "](" in text:
		var p = text.split("](", true, 1)
		text = p[0].split("[", true, 1)[1].strip_edges()
		var link = p[1].split(")", true, 1)[0].strip_edges()
		return { text=text, link=link }
#		return # { text=text, link=link }
	else:
		return { text=text, link="" }
#		return { text=text, link="" }

func _init(md_path):
	var text:String = UtilFile.load_text(md_path)
	
	var sections = [ParserSteps.CHAPTER("ROOT")]
	var path = ["ROOT"]
	var path_named = ["ROOT"]
	var last = sections[-1]
	last["path"] = []
	last["path_named"] = []
	last["data"] = {}
	
	var lines = text.split("\n")# UtilStr.erase_between(text, "<!--", "-->").split("\n")
	for i in len(lines):
		lines[i] = SootyLocalizer.erase_localization(lines[i])
	
	var i = 0
	
	# get meta
	var yaml = ""
	if lines[0].begins_with("---"):
		i += 1
		while not lines[i].begins_with("---"):
			yaml += lines[i] + "\n"
			i += 1
		i += 1
	meta = ParserCommon.parse_yaml(yaml)
	
	while i < len(lines):
		var line = lines[i]
		
		i += 1
		
		# skip blank lines
		if not line.strip_edges():
			continue
		
		elif line.strip_edges().to_lower() == "[[toc]]":
			continue
		
		# collect code
		elif line.begins_with("```"):
			while i < len(lines) and not lines[i].begins_with("```"):
				line += "\n" + lines[i]
				i += 1
			i += 1
			last["then"].append(ParserSteps.str_to_CODE(line))
		
		# collect tables
		elif "|" in line and "-|" in lines[i]:
			var table = [line]
			while i < len(lines):
				table.append(lines[i])
				i += 1
				if not lines[i].strip_edges():
					break
			last["then"].append(ParserSteps.TABLE(table))
		
		# collect quotes
		elif line[0] == ">":
			line = line.substr(1).strip_edges()
			while i < len(lines) and (lines[i].strip_edges() or lines[i].begins_with(">")):
				var l = lines[i]
				if l.begins_with(">"):
					l = l.substr(1).stripe_edges()
				line += "\n" + l
				i += 1
			last["then"].append(ParserSteps.QUOTE(line))
		
		# chapter heading
		elif line[0] == "#":
			var deep = _count_depth(line, "#")
			var name = line.substr(deep).strip_edges()
			last = ParserSteps.CHAPTER(name)
			sections.append(last)
			
			if deep >= len(path):
				path.append(last.id)
				path_named.append(last.name)
			
			else:
				path[deep] = last.id
				path_named[deep] = last.name
			
			last["path"] = Util.part(path, 1, deep)
			last["path_named"] = Util.part(path_named, 1, deep)
		
		# lines
		else:
			last["then"].append(line)
	
	# sections
	for section in sections:
		section.then = _collect_indented_lines(section.then)
	
	# seperate internal data from chapters
	var chapter_ids = []
	
	for c in sections:
		if c.path_named and UtilStr.is_wrapped(c.path_named[0], "_", "_"):
			internal.append(c)
		
		else:
			chapter_ids.append(c.path)
			chapters.append(c)
	
	i = 0
	for c in chapters:
		c.prev = chapter_ids[i-1] if i > 0 else null
		c.next = chapter_ids[i+1] if i < len(chapter_ids)-1 else null
		i += 1

func _collect_indented_lines(lines:Array):
	var out = []
	var indent_style = null
	var last = null
	for line in lines:
		if line is Dictionary:
			out.append(line)
		
		else:
			var indent = _count_indent(line)
			
			if indent == 0:
				indent_style = null
				last = { line=line, then=[] }
				out.append(last)
			
			else:
				# the first indented line defines the tab style
				if indent_style == null:
					indent_style = Util.part(line, 0, indent)
				
				# trim the front
				last["then"].append(Util.part(line, len(indent_style)))
	
	# recursive
	for line in out:
		if "then" in line:
			line["then"] = _collect_indented_lines(line.then)
	
	# 
	out = _post_process_lines(out)
	
	return out

func _count_indent(s:String) -> int:
	return len(s) - len(s.strip_edges(true, false))

func _count_depth(s:String, c:String) -> int:
	var count = 0
	while count < len(s) and s[count] == c:
		count += 1
	return count

func _post_process_lines(lines:Array):
	var out = []
	var last = null
	for line in lines:
		if not "T" in line:
			line = ParserSteps._str_to_step(line.line, line.then)
		
		# recursive 'then'
		if "then" in line:
			line.then = _post_process_lines(line.then)
		
		match line["T"]:
			# clump together lists
			"-", "*", "+":
				# add to a text line
				if last and last["T"] == "rand":
					var r = [ParserSteps._str_to_step(line.text, [])]
					r.append_array(line.then)
					last.rand.append(r)
					line = null
					continue
					
				elif last and last["T"] == "text":
					last["T"] = "list"
					
					if not "list" in last:
						last["-"] = line["T"]
						last["list"] = []
				
				# add to it's own list object
				elif not (last and last["T"] == "list" and last["-"] == line["T"]):
					last = ParserSteps.LIST() # { "T": "list", "-": line["T"], "list": [] }
					last["-"] = line["T"]
					out.append(last)
				
				last["list"].append(line)
				line = null
			
			"case":
				if last and last["T"] == "match":
					last.list.append(line)
				line = null
			
			# clump 'if' 'elif' and 'else'
			"elif", "else":
				if last and last["T"] == "if":
					last["else"].append(line)
				else:
					push_error("'elif' and 'else' require an 'if': %s" % [line])
				line = null
			
			"data":
				if last and last["T"] == "data":
					for k in line.data:
						last.data[k] = line.data[k]
					line = null
					
			"eval":
				if last and last["T"] == "eval":
					if not last.eval is Array:
						last.eval = [last.eval]
					
					ParserCommon.append(last.eval, line.eval)
					line = null
		if line:
			ParserCommon.append(out, line)
			last = line
	return out


