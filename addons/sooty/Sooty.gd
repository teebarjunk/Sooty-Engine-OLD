extends Node

const VERSION:String = "0.1"
const PATH_PERSISTENT:String = "user://persistent.json"

signal reloaded()
signal pre_quit()

signal collect_save_data(save, data)
signal collect_save_info(info_dict) # requests data to show in save
signal collect_persistent(save, pers_dict)

signal started()
signal chapter(path)
signal finished()

signal hide_ui(hide)
signal node(name, type, args, kwargs)
signal text_started(from, text, kwargs)
signal text_finished(from)

var meta:Dictionary = {}

var _menu:Node
var _booted:bool = false
var _screenshot:Image

var _f_save_persistent:bool = false
func save_persistent():
	_f_save_persistent = true
	set_process(true)

var _stack:Array = []
var _progress:bool = false
var _parser:Parser
var _data:Node
var _memory:Array = []
var _nodes:Dictionary = {}
var _node_types:Dictionary = {
	"": "image",
	"text": "printer_main",
	"list": "options"
}

#func get_markdown_path() -> String: return markdown_path
#func set_markdown_path(p:String):
#	if markdown_path != p:
#		markdown_path = p
#		script_reload(markdown_path)

func boot(path:String):
	_parser = load(path)
	
	yield(get_tree(), "idle_frame")
	
	script_reload()
	
	# DEBUG: For testing the main menu.
	if get_tree().current_scene.filename.ends_with("menu/main/main.tscn"):
		_menu = get_tree().current_scene
		
		var ps = PackedScene.new()
		ps.pack(Node.new())
		get_tree().change_scene_to(ps)

func _ready():
	pause_mode = Node.PAUSE_MODE_STOP
	get_tree().set_auto_accept_quit(false)
	set_process(false)
	
	_data = Node.new()
	add_child(_data)
	_data.set_name("__data__")
	_data.set_owner(self)
	_data.set_process(true)
	_data.pause_mode = Node.PAUSE_MODE_STOP

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		emit_signal("pre_quit")
		show_menu({_toggle=["quit"]})

func _save() -> Dictionary:
	var other_data = {}
	emit_signal("collect_save_data", true, other_data)
	return {
		other=other_data,
		stack=_stack.duplicate(true),
		nodes=_save_nodes(),
		scene=get_tree().current_scene.filename
	}

func _load(d:Dictionary):
	if d.scene != get_tree().current_scene.filename:
		get_tree().change_scene(d.scene)
		yield(get_tree(), "idle_frame")
		
	_stack = d.stack
	_load_nodes(d.nodes)
	emit_signal("collect_save_data", false, d.other)

func _save_info() -> Dictionary:
	var info = {
		game_time=_data.time._save(),
		play_time=_data.play_time._save(),
		save_time=DateTime.new().set_from_current_datetime()._save()
	}
	emit_signal("collect_save_info", info)
	return info

func get_character(id) -> CharacterInfo:
	id = UtilStr.to_var(id)
	if id in _data:
		return _data[id]
	return null

func script_was_modified() -> bool:
	return _parser and _parser._was_modified()

func _stack_to_step(s:Array) -> Array:
	return _data.CHAPTERS[s[0]][s[1]]

func rewind():
	_memory.pop_back()
	_memory.pop_back()
	var last_state = _memory.pop_back()
	_load(last_state)

func script_reload():
	if not _parser:
		push_error("can't reload script without a parser.")
		return
	
	var last_state = _memory.pop_back()
	var state = _save()
	_clear_nodes()
	
	# generate script
	var script:GDScript = GDScript.new()
	var script_text:String
	
	if not UtilGodot.is_html():#OS.is_debug_build():
#		_parser.parse()
		script_text = _parser.update_script(true)
	
	else:
#		Resources.load_collection()
		Resources._load_collection(_parser.resource_list)
		script_text = _parser.source_code
	
	script.set_source_code(script_text)
	UtilGodot.print_if_error(script.reload(true))
	_data.set_script(script)
	
	if _booted and last_state:
		print("modified %s." % [_parser.path_to_markdown])
		_load(last_state)
	
	else:
		# Show Main Menu
		_booted = true
		_set_scene(Config.menu_image, false)
		Audio.music(Config.menu_music)
		show_menu()
	
	# load persistent data
	var data = UtilFile.load_dict(PATH_PERSISTENT)
	emit_signal("collect_persistent", false, data)
	
	emit_signal("reloaded")

func format(s:String, obj:Object=_data):
	return UtilStr.format(s, obj)

func evaluate_is_true(s:String) -> bool:
	return UtilStr.evaluate_string(s, _data) == true

func progress():
	if not _progress and _stack and has_chapters():
		# TODO: Make sure it clears the stack if it was last step
		_progress = true
		set_process(true)

func _eval(e):
	var got = UtilStr.evaluate(e, _data)
#	prints(">> %s: %s" % [e, got])
	return got

func _rand(r):
	_stack_call(Rand.pick(r))

func _process(_delta):
	
	if _progress and has_chapters() and not _is_node_waiting():
		_progress = false
		_memory.append(_save())
		
		while _stack:
			var step = _stack[-1]
			var list = _data.CHAPTERS[step[0]]
			step[1] += 1
			if step[1] >= len(list):
				_stack.pop_back()
			else:
				break
		
		if _stack:
			_stack_step()
		
		set_process(false)
	
	# save persistent data
	if _f_save_persistent:
		_f_save_persistent = false
		var pers = {}
		emit_signal("collect_persistent", true, pers)
		UtilFile.save_dict(PATH_PERSISTENT, pers)
	
	if Input.is_action_pressed("progress"):
		for node_id in _nodes:
			if UtilGodot.is_good(_nodes[node_id].node):
				Util.try_call(_nodes[node_id].node, "_sooty_progress")

func _stack_step():
	var step = _stack[-1]
	var list = _data.CHAPTERS[step[0]]
	var list_step = list[step[1]]
	if has_method(list_step[0]):
		callv(list_step[0], list_step[1])

func _start():
	hide_menu()
	Audio._stop_all()
	for k in _data.CHAPTERS:
		_stack_goto(k)
		break

func has_chapters() -> bool:
	return _data and "CHAPTERS" in _data

func has_chapter(chapter:String) -> bool:
	return has_chapters() and chapter in _data.CHAPTERS

func _stack_goto(chapter:String):
	if chapter != null and chapter != "null" and has_chapter(chapter):
		_stack.clear()
		_stack_call(chapter)

func _stack_call(chapter:String):
	if chapter != null and chapter != "null" and has_chapter(chapter):
#		prints(">>", chapter, UtilGodot.type_name(chapter))
		_stack.append([chapter, -1])

func _if(test, then_if:String, then_else:Array):
	if evaluate_is_true(test):
		_stack_call(then_if)
	
	else:
		for item in then_else:
			# elif
			if "test" in item and evaluate_is_true(item.test):
				_stack_call(item.then)
				break
			
			# else
			else:
				_stack_call(item.then)

func _save_nodes() -> Dictionary:
	var out = {}
	for n in _nodes:
		var node = _nodes[n]
		if UtilGodot.is_good(node.node):
			if node.node.has_method("_save"):
				out[n] = { type=node.type, node=node.node._save() }
			else:
				out[n] = { type=node.type }
	return out

func _load_nodes(d:Dictionary):
	_clear_nodes()
	for node_id in d:
		var info = d[node_id]
#		prints("> CREATE ", node_id, info.type)
		var node = _new_node(node_id, info.type)
		if node.has_method("_load"):
			node._load(info.node)

func _is_node_waiting() -> bool:
	for id in _nodes:
		var node = _nodes[id].node
		if UtilGodot.is_good(node) and Util.call_method(node, "_pause_sooty") == true:
			return true
	return false

func has_node(node_id) -> bool:
	return node_id in _nodes and UtilGodot.is_good(_nodes[node_id].node)

func _node(node_id, type="", args=null, kwargs=null, evals=null):
	if node_id is Array:
		for n in node_id:
			_node(n, type, args, kwargs, evals)
	
	else:
		# create the object
		var node
		var was_created:bool = false
		if not has_node(node_id):
			
			if not type:
				if node_id in _node_types:
					type = _node_types[node_id]
				
				elif not Resources.scene_path(node_id):
					type = "image"
				
				else:
					type = node_id
			
			_new_node(node_id, type)
			was_created = true
		
		node = _nodes[node_id].node
		
		# call the main function
		Util.try_call(node, "_main", [args, kwargs])
		
		# evaluate strings
		if evals:
			if not Util.try_call(node, "_eval", [evals]):
				UtilStr.evaluate(evals, node)
		
		if was_created:
			Util.try_call(node, "_created")
		
		emit_signal("node", node_id, type, args, kwargs)

func _new_node(node_id:String, type:String):
	var parent = get_tree().current_scene
	var node = Resources.create_scene(type, self)
	node.set("node_type", type)
	node.set_name(node_id)
	_nodes[node_id] = { type=type, node=node }
	return node

func _remove_node(node_id):
	var node = _nodes[node_id].node
	_nodes.erase(node_id)
	if UtilGodot.is_good(node):
		node.get_parent().remove_child(node)
		node.queue_free()

func _clear_nodes(names=null):
	for node_id in _nodes.keys():
		_remove_node(node_id)

func _set_scene(id, trans_in=true, trans_out=true):
	if trans_in:
		var node = Resources.create_scene("simple_fade", self, {reverse=false})
		if node:
			yield(node, "finished")
	
	_clear_nodes()
	_node("bg", "bg", [id])
	
	if trans_out:
		var node = Resources.create_scene("simple_fade", self, {reverse=true})
		if node:
			yield(node, "finished")

func toggle_menu():
	if UtilGodot.is_good(_menu):
		hide_menu()
	else:
		show_menu()

func show_menu(kwargs=null):
	if not UtilGodot.is_good(_menu):
		emit_signal("hide_ui", true)
		yield(get_tree(), "idle_frame")
		yield(get_tree(), "idle_frame")
		cache_screenshot()
		if not kwargs:
			kwargs = {}
		kwargs["_show_bg"] = false
		_menu = Resources.create_scene("menu_main", self, kwargs)
		set_process(false)
	
	elif kwargs:
		for k in kwargs:
			if _menu.has_method(k):
				_menu.callv(k, kwargs[k])

func hide_menu():
	if UtilGodot.is_good(_menu):
		show_ui()
		_menu.queue_free()
		_menu = null
		set_process(true)

func show_ui():
	emit_signal("hide_ui", false)

func get_viewport_image() -> Image:
	return get_tree().current_scene.get_viewport().get_texture().get_data()

func cache_screenshot():
	_screenshot = get_viewport_image()

var _slot:String = "A1"
func _get_slot_path(slot:String, file:String) -> String:
	return "user://slot_%s/%s" % [slot, file]

func save_game(slot=_slot):
	# save data
	var node = load("res://addons/sooty/prefab/save_data.tscn").instance()
	node.data = _save()
	var compressed = false
	var data_path = _get_slot_path(slot, "save.scn" if compressed else "save.tscn")
	UtilFile.save_node(data_path, node)
	
	# save info
	var info = _save_info()
	var info_path = _get_slot_path(slot, "info.json")
	UtilFile.save_dict(info_path, info)
	
	# save preview
	if Sooty._screenshot:
		var image_path = _get_slot_path(slot, "save.png")
		var img = _screenshot.duplicate()
		img.shrink_x2()
		img.shrink_x2()
		img.flip_y()
		UtilFile.save_image(image_path, img)
	
func load_game(slot=_slot):
	hide_menu()
	var data = load(_get_slot_path(slot, "save.tscn")).instance().data
	_load(data)

func get_slot_info(slot=_slot) -> Dictionary:
	var image_path = _get_slot_path(slot, "save.png")
	var image = UtilFile.load_image(image_path)
	
	var info_path = _get_slot_path(slot, "info.json")
	var info = UtilFile.load_dict(info_path)
	return { image=image, info=info }


#
