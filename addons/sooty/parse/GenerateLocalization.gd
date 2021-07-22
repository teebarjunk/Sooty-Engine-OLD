tool
extends Node
class_name SootyLocalizer

static func erase_localization(text:String) -> String:
	if "<!--" in text:
		return text.rsplit("<!--", true, 1)[0].strip_edges(false, true)
	else:
		return text

func _ignore_line(l) -> bool:
	if not l: return true
	if l[0] in ".`@": return true
	if l.begins_with("INT.") or l.begins_with("EXT."): return true
	if l.to_lower() == "[[toc]]": return true
	if l == "---": return true
	return false

func _get_lines(markdown:String, generate_tag:bool):
	var lines:Array = []
	var tagged:Dictionary = {}
	var longest = 0
	var i = -1
	for line in markdown.split("\n"):
		i += 1
		
		var line_s = line.strip_edges(true, true)
		
		# heading
		if line_s.begins_with("#"):
			lines.append({line=line, tag=null})
		
		# previously tagged
		elif "<!--" in line_s and " :: " in line_s and line_s.ends_with("-->"):
			var p = line.rsplit("<!--", true, 1)
			var tag = p[1].split("-->", true, 1)[0]
			if " :: " in tag:
				tag = tag.split(" :: ")[1].strip_edges()
			line_s = p[0].strip_edges(false, true)
			lines.append({line=line_s, tag=tag})
			tagged[tag] = lines[-1]
		
		# not tagged, but needed
		elif not _ignore_line(line_s):
			var tag = "???"
			if generate_tag:
				tag = str(hash(line))
			
			lines.append({line=line, tag=tag})
			
			if generate_tag:
				tagged[tag] = lines[-1]
		
		# not tagged, not needed
		else:
			lines.append({line=line, tag=null})
		
		var length = len(lines[-1].line)
		if length > longest:
			longest = length
	
	return {lines=lines, tagged=tagged, longest=longest}

func _compile(lines1, lines2):
	var output = ""
	var longest = max(lines1.longest, lines2.longest) + 4
	for line in lines1.lines:
		if output != "":
			output += "\n"
		if line.tag != null:
			var text = line.line
			if line.tag in lines2.tagged:
				text = lines2.tagged[line.tag].line
			
			var text_stripped = text.strip_edges(false, true)
			var spaces = " ".repeat(longest - len(text_stripped))
			output += "%s%s<!-- %s :: %s -->" % [text, spaces, line.line, line.tag]
			if text.ends_with("  "):
				output += "  "
		
		else:
			output += line.line
	
	# keep track of deleted lines, in case they come back
	var spares = []
	for k in lines2.tagged.keys():
		if not k in lines1.tagged:
			spares.append(lines2.tagged[k])
	if spares:
		output += "\n# _removed_lines_\n"
		for line in spares:
			var text_stripped = line.line.strip_edges(false, true)
			var spaces = " ".repeat(longest - len(text_stripped))
			output += "%s%s<!-- %s :: %s -->  \n" % [line.line, spaces, line.line, line.tag]
	
	return output

func localize():
	var path_main:String = "res://simplestory.en.md"
	var path_patch:String = "res://simplestory.py.md"
	
	var text_main = UtilFile.load_text(path_main)
	var text_patch = UtilFile.load_text(path_patch)
	
	UtilFile.save_text(path_main, text_main, "backup." + UtilFile.get_extension(path_main))
	UtilFile.save_text(path_patch, text_patch, "backup." + UtilFile.get_extension(path_patch))
	
	var lines_main = _get_lines(text_main, true)
	var lines_patch = _get_lines(text_patch, false)
	
	var output_main = _compile(lines_main, lines_main)
	var output_patch = _compile(lines_main, lines_patch)
	
	UtilFile.save_text(path_main, output_main, "en.md")
	UtilFile.save_text(path_patch, output_patch, "py.md")
	
	return output_main
