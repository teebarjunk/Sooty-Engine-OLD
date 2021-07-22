extends CanvasLayer

var scene_history:Array = []
var persistent:DictionaryResource = DictionaryResource.new()

func _save():
	var out = {
		persistent=persistent._save(),
	}
	return out

func _load(d):
	persistent._load(d.persistent)

func _init():
	layer = 128
	if not Engine.editor_hint:
		return

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS

var _awards_screen:Node
var _rewards_screen:Node
var _screenshot:Image
var _t:float = 0.0

func _process(_delta):
	if get_tree().paused:
		return
	
	if Sooty.has_chapters():
		Sooty.progress()
	
	if OS.is_debug_build() and not UtilGodot.is_html():
		_t += _delta
		if _t >= 1.0:
			_t -= 1.0
			if Sooty.script_was_modified():
				print("hot reloading...")
				Sooty.script_reload()
				return

func goto_scene(name:String, d=null):
	# add to history
	if len(scene_history) > 10:
		scene_history.pop_front()
	scene_history.append(get_tree().current_scene.filename)
	
	if name.begins_with("res://"):
		get_tree().change_scene(name)
	else:
		get_tree().change_scene(Resources.scene_path(name))
	
	yield(get_tree(), "idle_frame")
	# set some properties, after scene changed.
	if d:
		for k in d:
			get_tree().current_scene.set(k, d[k])
	
	get_tree().current_scene.set_process(true)

func goto_last_scene():
	if scene_history:
		goto_scene(scene_history[-1])
	else:
		push_error("No scene to go back to.")

func _unhandled_key_input(e):
	if e.pressed:
		match e.scancode:
			KEY_ESCAPE:
				Sooty.toggle_menu()
			
			KEY_BACKSPACE:
				Sooty.rewind()






#
