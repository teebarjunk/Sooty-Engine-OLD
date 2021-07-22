extends Node

const OPTIONS = ["start", "save", "load", "settings", "credits", "quit"]
const EXTRA_OPTIONS = ["achievements", "rewards"]

var _show_bg:bool = true
var _is_pause_menu:bool = false
var _submenu:Node = null

func _ready():
	var _e
	_e = $control/settings/lang.connect("item_selected", self, "_lang_selected")
	
	_e = Sooty.connect("reloaded", self, "_sooty_reloaded")
	
	var buttons = []
	
	var prefab = $control/buttons/options/button
	var parent = $control/buttons/options
	parent.remove_child(prefab)
	for b in OPTIONS:
		var button = prefab.duplicate()
		buttons.append(button)
		parent.add_child(button)
		button.text = b
		button.set_name(b)
		Resources.set_fonts(button.get_node("text"), Config.menu_version_font)
		_e = button.connect("pressed", self, "_pressed", [button.name])
	
	var parent2 = $control/buttons/extra_options
	for b in EXTRA_OPTIONS:
		var button = prefab.duplicate()
		buttons.append(button)
		parent2.add_child(button)
		button.text = b
		button.set_name(b)
		Resources.set_fonts(button.get_node("text"), Config.menu_version_font)
		_e = button.connect("pressed", self, "_pressed", [button.name])
	
	$control/buttons.hide()
	$control/buttons.show()
	for b in buttons:
		b.rect_min_size = b.rect_size
		b.get_node("text").text = b.text
		b.text = ""
	
	var ob = $control/options_backing
	ob.rect_position = $control/buttons.rect_position
	ob.rect_size = $control/buttons.rect_size + Vector2(0, 8.0)
	ob.material = Resources.create_shader_material("blur_screen_lod")
	
	if not _show_bg:
		$control/bg.visible = false
	
#	if not _is_pause_menu:
#		for item in [$options/save, $options/back, $options/history, $options/quests]:
#			item.visible = false
	_sooty_reloaded()

func _enter_tree():
	get_tree().paused = true
	pause_mode = Node.PAUSE_MODE_PROCESS

func _exit_tree():
	get_tree().paused = false

func _main(_a, k):
	$control/bg.visible = k.get("bg", true)

func _pause_sooty():
	return true

func _sooty_reloaded():
	if not Sooty._booted:
		yield(get_tree(), "idle_frame")
		yield(get_tree(), "idle_frame")
	$control/bg.texture = Resources.load_texture(Config.menu_image)
	
	Resources.set_fonts($control/text/items/title, Config.menu_title_font)
	Resources.set_fonts($control/text/items/subtitle, Config.menu_author_font)
#	Resources.set_fonts($control/text/items/version, Config.menu_version_font)
	$control/text/items/title.bbcode_text = "[center]" + Sooty.meta.get("title", "NO_TITLE")
	$control/text/items/subtitle.bbcode_text = "[center]" + Sooty.meta.get("subtitle", "NO_SUBTITLE")
	$control/settings/version.text = "%s - %s" % [Sooty.meta.get("author", "NO_AUTHOR"), Sooty.meta.get("version", "v1.0")]
	
	$control/settings/lang.selected = 0 if Lang.lang == "en" else 1
	
	$control.hide()
	$control.show()

func _lang_selected(i):
	var _ob:OptionButton = $control/settings/lang
	match i:
		0: Lang.lang = "en"
		1: Lang.lang = "??"


func _toggle(menu, kwargs=null):
	if UtilGodot.is_good(_submenu) and _submenu.name == menu:
		$control/text.visible = true
		$control/submenu.visible = false
		_submenu.queue_free()
		_submenu = null
	
	else:
		$control/text.visible = false
		$control/submenu.visible = true
		
		if UtilGodot.is_good(_submenu):
			_submenu.queue_free()
			_submenu = null
		
		_submenu = Resources.create_scene(menu, $control/submenu, kwargs)

func _pressed(id):
	match id:
		"start": Sooty._start()
		"credits": _toggle("credits")
		"settings": _toggle("settings")
		"save": _toggle("slots", {_save=true})
		"load": _toggle("slots", {_save=false})
		"achievements": _toggle("achievements")
#		"rewards": _toggle("rewards")
		
		
		"quit": _toggle("quit")
#			var node = Resources.create_scene("menu quit", self)
#			if not node:
#				
#			Global.goto_scene("menu quit")

#func _unhandled_key_input(event):
#	if event.pressed:
#		match event.scancode:
#			KEY_ESCAPE:
#				Global.load_slot("temp", false)



#
