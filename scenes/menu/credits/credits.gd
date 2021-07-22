extends Control

export var title_color:Color = Color.orange
export var name_color:Color = Color.white
export var item_color:Color = Color.webgray

func _ready():
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	
	get_tree().paused = true
	pause_mode = Node.PAUSE_MODE_PROCESS
	
	var tcolor = "#" + title_color.to_html()
	var ncolor = "#" + name_color.to_html()
	var icolor = "#" + item_color.to_html()
	
	var credits = Sooty._parser.credits
	var s = ""
	s += "[center][table=3]" 
	for k in credits:
		var first = true
		for item in credits[k]:
			if not first:
				s += "\n"
			s += "[cell][color=%s][b]%s[/b][/color][/cell]" % [tcolor, k if first else ""]
			first = false
			if item.link != "":
				s += "[cell][url=\"%s\"][color=%s]%s[/color][/url][/cell][cell][color=%s][i]%s[/i][/color][/cell]" % [item.link, ncolor, item.name, icolor, item.item]
			else:
				s += "[cell][color=%s]%s[/color][/cell][cell][color=%s][i]%s[/i][/color][/cell]" % [ncolor, item.name, icolor, item.item]
		s += "[cell][/cell][cell][/cell][cell][/cell]"
	s += "[/table][/center]"
	
	var text = $scroll/text
	var shadow = $scroll/text/shadow
	Resources.set_fonts(text, "open_sans_16")
	Resources.set_fonts(shadow, "open_sans_16")
	text.bbcode_text = s
	shadow.bbcode_text = s
	
	text.connect("meta_clicked", self, "_meta")
	
	material = Resources.create_shader_material("blur_screen_lod", { blur=3 })

func _exit_tree():
	get_tree().paused = false

func _meta(id):
	UtilGodot.print_if_error(OS.shell_open(id.substr(1, len(id)-2)), "credits meta error: %s")

